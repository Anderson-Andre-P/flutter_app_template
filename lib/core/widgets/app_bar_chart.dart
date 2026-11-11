import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Simple vertical bar chart: one bar per value, scaled to the largest, with
/// a label under each ([labels] has one entry per value). The bar at [highlightIndex] is solid primary.
///
/// [valueLabels] (one per value, "3,0") go just above each bar. [goal] draws
/// a green line across the bars at that value, with [goalLabel] ("meta")
/// beside its end, outside the bars, so it never covers a value (design
/// system, section 37); the scale grows to fit it.
///
/// [axisLabel] adds the Y axis: round steps from zero ([ticks]) on the left,
/// formatted by it, each with a light grid line; the scale then ends on the
/// last step.
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
    this.axisLabel,
  });

  final List<double> values;
  final List<String> labels;
  final int? highlightIndex;
  final double? height;
  final List<String>? valueLabels;
  final double? goal;
  final String? goalLabel;
  final String Function(double value)? axisLabel;

  static const goalKey = ValueKey('bar-chart-goal');

  /// How many steps the Y axis aims for.
  static const _axisSteps = 4;

  /// Round steps from zero up to at least [max]: 0, 1, 2, 3, 4 for 3.6. The
  /// step is 1, 2, 2.5 or 5 times a power of ten.
  static List<double> ticks(double max, {int steps = _axisSteps}) {
    if (max <= 0) return const [0];
    final rough = max / steps;
    final magnitude = math
        .pow(10, (math.log(rough) / math.ln10).floor())
        .toDouble();
    final step = [
      1,
      2,
      2.5,
      5,
      10,
    ].map((f) => f * magnitude).firstWhere((s) => s >= rough);
    final count = (max / step - 1e-9).ceil();
    return [for (var i = 0; i <= count; i++) i * step];
  }

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
    final axisLabel = this.axisLabel;
    final largest = values.fold<double>(goal ?? 0, (m, v) => v > m ? v : m);
    final steps = axisLabel == null ? null : ticks(largest);
    final max = steps?.last ?? largest;
    // Room above the tallest bar for its value.
    final headroom = valueLabels != null ? AppSpacing.x2l : 0.0;
    final barArea = height - headroom;
    double share(double v) => max == 0 ? 0 : v / max;
    final gap = EdgeInsets.symmetric(horizontal: AppSpacing.xs);
    final axisStyle = AppTypography.micro.copyWith(color: c.textMuted);

    final plot = Stack(
      clipBehavior: Clip.none,
      children: [
        for (final step in steps ?? const <double>[])
          Positioned(
            left: 0,
            right: 0,
            bottom: barArea * share(step),
            child: Container(height: AppSizes.hairline, color: c.border),
          ),
        // Under the bars: a bar or a value in front of the line stays whole.
        if (goal != null)
          Positioned(
            key: goalKey,
            left: 0,
            right: 0,
            bottom: barArea * share(goal),
            child: Container(height: AppSizes.chartGoalLine, color: c.success),
          ),
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
                            // On the card colour, so a grid or goal line
                            // behind it does not cross the number.
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: c.card,
                                borderRadius: AppRadius.brXs,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xxs,
                                ),
                                child: Text(
                                  texts[i],
                                  maxLines: 1,
                                  style: AppTypography.microBold.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
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
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (steps != null && axisLabel != null) ...[
          _Gutter(
            height: height,
            align: Alignment.centerRight,
            items: [
              for (final step in steps)
                (barArea * share(step), axisLabel(step), axisStyle),
            ],
          ),
          SizedBox(width: AppSpacing.xs),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: height, child: plot),
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
                          style: axisStyle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (goal != null && goalLabel != null) ...[
          SizedBox(width: AppSpacing.xs),
          _Gutter(
            height: height,
            align: Alignment.centerLeft,
            items: [
              (
                barArea * share(goal),
                goalLabel,
                AppTypography.microBold.copyWith(color: c.success),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// A side column of the chart, as tall as the plot: each text is centred
/// on its height above the bottom. As wide as its widest text.
class _Gutter extends StatelessWidget {
  const _Gutter({
    required this.height,
    required this.align,
    required this.items,
  });

  final double height;
  final Alignment align;
  final List<(double bottom, String text, TextStyle style)> items;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    // Measured as the Text below draws: on top of the default text style.
    final base = DefaultTextStyle.of(context).style;
    final width = items.fold<double>(0, (widest, item) {
      final (_, text, style) = item;
      final painter = TextPainter(
        text: TextSpan(text: text, style: base.merge(style)),
        textDirection: Directionality.of(context),
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      final w = painter.width;
      painter.dispose();
      return math.max(widest, w);
    });
    return SizedBox(
      width: width.ceilToDouble(),
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final (bottom, text, style) in items)
            Positioned(
              left: 0,
              right: 0,
              bottom: bottom,
              // Centred on the line, not sitting on it.
              child: FractionalTranslation(
                translation: const Offset(0, .5),
                child: Align(
                  alignment: align,
                  child: Text(text, maxLines: 1, style: style),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
