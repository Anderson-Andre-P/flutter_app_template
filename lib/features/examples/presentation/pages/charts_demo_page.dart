import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_bar_chart.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_ring.dart';
import '../../../../core/widgets/app_donut_chart.dart';
import '../../../../core/widgets/app_line_chart.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Every chart of the design system with sample data.
class ChartsDemoPage extends StatelessWidget {
  const ChartsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DemoScaffold(
      title: ExamplesStrings.chartsTitle,
      children: [
        DemoSection(
          title: ExamplesStrings.chartBars,
          caption: ExamplesStrings.chartBarsCaption,
          child: AppCard(
            child: AppBarChart(
              values: ExamplesStrings.weekValues,
              labels: ExamplesStrings.weekLabels,
              highlightIndex: DateTime.now().weekday - 1,
            ),
          ),
        ),
        const DemoSection(
          title: ExamplesStrings.chartLine,
          caption: ExamplesStrings.chartLineCaption,
          child: AppCard(
            child: AppLineChart(
              values: ExamplesStrings.chartLineValues,
              labels: ExamplesStrings.chartLineLabels,
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.chartDonut,
          caption: ExamplesStrings.chartDonutCaption,
          child: AppCard(
            child: AppDonutChart(
              centerLabel: ExamplesStrings.chartDonutCenter,
              centerCaption: ExamplesStrings.chartDonutCenterCaption,
              segments: [
                for (final (label, value) in ExamplesStrings.chartDonutSegments)
                  AppChartSegment(label: label, value: value),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.chartRing,
          caption: ExamplesStrings.chartRingCaption,
          child: AppCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final (label, value) in ExamplesStrings.chartRingItems)
                  Column(
                    children: [
                      AppProgressRing(value: value, label: label),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        label,
                        style: AppTypography.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.chartProgress,
          caption: ExamplesStrings.chartProgressCaption,
          child: AppCard(
            child: Column(
              children: [
                for (final (label, value) in ExamplesStrings.goals) ...[
                  if (label != ExamplesStrings.goals.first.$1)
                    const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: AppTypography.labelMedium.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        ExamplesStrings.percent(value),
                        style: AppTypography.captionBold.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppProgressBar(
                    value: value,
                    color: value < .25 ? c.alert : null,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
