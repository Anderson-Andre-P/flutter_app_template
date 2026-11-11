import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Simple vertical bar chart: one bar per value, scaled to the largest, with
/// a label under each ([labels] has one entry per value). The bar at [highlightIndex] is solid primary.
class AppBarChart extends StatelessWidget {
  const AppBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.highlightIndex,
    this.height,
  });

  final List<double> values;
  final List<String> labels;
  final int? highlightIndex;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final height = this.height ?? AppSizes.chart;
    final c = context.colors;
    assert(values.length == labels.length, 'one label per value');
    final max = values.fold<double>(0, (m, v) => v > m ? v : m);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < values.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: height,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        key: ValueKey('bar-$i'),
                        heightFactor: max == 0 ? 0 : values[i] / max,
                        widthFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: i == highlightIndex
                                ? c.primary
                                : c.primarySubtle,
                            borderRadius: AppRadius.brXs,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    labels[i],
                    style: AppTypography.micro.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
