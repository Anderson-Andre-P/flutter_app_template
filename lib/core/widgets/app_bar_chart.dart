import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Simple vertical bar chart: one bar per value, scaled to the largest, with
/// a label under each ([labels] has one entry per value). The bar at [highlightIndex] is solid primary.
///
/// [valueLabels] (one per value, "3,0") go just above each bar. [goal] draws
/// a green line across the bars at that value, with [goalLabel] ("meta")
/// over its end (design system, section 37); the scale grows to fit it.
class AppBarChart extends StatelessWidget {
  const AppBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.highlightIndex,
    this.height,
    this.valueLabels,
    this.goal,
    this.goalLabel,
  });

  final List<double> values;
  final List<String> labels;
  final int? highlightIndex;
  final double? height;
  final List<String>? valueLabels;
  final double? goal;
  final String? goalLabel;

  static const goalKey = ValueKey('bar-chart-goal');

  @override
  Widget build(BuildContext context) {
    final height = this.height ?? AppSizes.chart;
    final c = context.colors;
    assert(values.length == labels.length, 'one label per value');
    assert(
      valueLabels == null || valueLabels!.length == values.length,
      'one value label per value',
    );
    final goal = this.goal;
    final goalLabel = this.goalLabel;
    final max = values.fold<double>(goal ?? 0, (m, v) => v > m ? v : m);
    // Room above the tallest bar for its value or the goal's label.
    final headroom = valueLabels != null || goalLabel != null
        ? AppSpacing.x2l
        : 0.0;
    final barArea = height - headroom;
    double share(double v) => max == 0 ? 0 : v / max;
    final gap = EdgeInsets.symmetric(horizontal: AppSpacing.xs);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < values.length; i++)
                    Expanded(
                      child: Padding(
                        padding: gap,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (valueLabels case final texts?) ...[
                              // Shrinks rather than overflow at large text.
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    texts[i],
                                    maxLines: 1,
                                    style: AppTypography.microBold.copyWith(
                                      color: c.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.xs),
                            ],
                            SizedBox(
                              key: ValueKey('bar-$i'),
                              height: barArea * share(values[i]),
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: i == highlightIndex
                                      ? c.primary
                                      : c.primarySubtle,
                                  borderRadius: AppRadius.brXs,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (goal != null)
                Positioned(
                  key: goalKey,
                  left: 0,
                  right: 0,
                  bottom: barArea * share(goal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (goalLabel != null)
                        Text(
                          goalLabel,
                          style: AppTypography.microBold.copyWith(
                            color: c.success,
                          ),
                        ),
                      Container(
                        height: AppSizes.chartGoalLine,
                        color: c.success,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (final label in labels)
              Expanded(
                child: Padding(
                  padding: gap,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTypography.micro.copyWith(color: c.textMuted),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
