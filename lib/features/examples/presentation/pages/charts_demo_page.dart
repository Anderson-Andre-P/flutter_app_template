import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_bar_chart.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_countdown_ring.dart';
import '../../../../core/widgets/app_day_marks.dart';
import '../../../../core/widgets/app_metric.dart';
import '../../../../core/widgets/app_timeline.dart';
import '../../../../core/widgets/app_progress_ring.dart';
import '../../../../core/widgets/app_donut_chart.dart';
import '../../../../core/widgets/app_line_chart.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Every chart of the design system with sample data, and the data, time
/// and goal pieces of the app components (section 37).
class ChartsDemoPage extends StatelessWidget {
  const ChartsDemoPage({super.key});

  /// A fixed sample month, so the demo reads the same every day.
  static final _month = DateTime(2026, 11);
  static const _today = 11;

  /// Activities done on each past day of the sample month (one tone per
  /// kind: workout, run, stretch).
  static const _history = <int, List<AppTone>>{
    2: [AppTone.primary],
    3: [AppTone.success],
    4: [AppTone.primary, AppTone.alert],
    6: [AppTone.success],
    8: [AppTone.alert],
    9: [AppTone.primary, AppTone.success],
    10: [AppTone.primary],
    11: [AppTone.success],
  };

  /// Litres drunk on each past day; the goal is [ExamplesStrings.chartGoalValue].
  static const _water = <int, double>{
    1: 3.1,
    2: 2.4,
    3: 3.0,
    4: 3.6,
    5: 1.8,
    6: 3.2,
    7: 2.9,
    8: 3.0,
    9: 3.4,
    10: 2.2,
    11: 1.5,
  };

  static AppHistoryDay _historyDay(int day) {
    final marks = _history[day] ?? const <AppTone>[];
    return AppHistoryDay(
      day: day,
      marks: marks,
      today: day == _today,
      future: day > _today,
      semanticLabel: day == _today ? '$day, ${ExamplesStrings.dayToday}' : null,
    );
  }

  static AppGoalDay _goalDay(int day) {
    final litres = _water[day];
    final status = day > _today
        ? AppGoalStatus.future
        : day == _today
        ? AppGoalStatus.today
        : litres! >= ExamplesStrings.chartGoalValue
        ? AppGoalStatus.met
        : AppGoalStatus.below;
    final value = litres == null ? null : ExamplesStrings.decimal(litres);
    return AppGoalDay(
      day: day,
      status: status,
      value: value,
      semanticLabel: [
        '$day',
        switch (status) {
          AppGoalStatus.met => ExamplesStrings.goalMet,
          AppGoalStatus.below => ExamplesStrings.goalBelow,
          AppGoalStatus.today => ExamplesStrings.dayToday,
          AppGoalStatus.future => null,
        },
        value,
      ].nonNulls.join(', '),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DemoScaffold(
      title: ExamplesStrings.chartsTitle,
      children: [
        DemoSection(
          title: ExamplesStrings.chartBars,
          caption: ExamplesStrings.chartBarsGoalCaption,
          child: AppCard(
            child: AppBarChart(
              values: ExamplesStrings.chartWaterValues,
              labels: ExamplesStrings.weekLabels,
              valueLabels: [
                for (final v in ExamplesStrings.chartWaterValues)
                  ExamplesStrings.decimal(v),
              ],
              highlightIndex: DateTime.now().weekday - 1,
              goal: ExamplesStrings.chartGoalValue,
              goalLabel: ExamplesStrings.chartGoal,
            ),
          ),
        ),
        const DemoSection(
          title: ExamplesStrings.chartLine,
          caption: ExamplesStrings.chartLineExtremesCaption,
          child: AppCard(
            child: AppLineChart(
              values: ExamplesStrings.chartWeightValues,
              labels: ExamplesStrings.chartLineLabels,
              valueLabel: ExamplesStrings.decimal,
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
          title: ExamplesStrings.chartSegmented,
          caption: ExamplesStrings.chartSegmentedCaption,
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSegmentedBar(
                  segments: [
                    for (final (i, (label, value))
                        in ExamplesStrings.chartSegments.indexed)
                      AppBarSegment(
                        label: label,
                        value: value,
                        tone: const [
                          AppTone.primary,
                          AppTone.alert,
                          AppTone.danger,
                        ][i],
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  children: [
                    for (final (i, (label, _))
                        in ExamplesStrings.chartSegments.indexed)
                      AppBadge(
                        label: label,
                        tone: const [
                          AppTone.primary,
                          AppTone.alert,
                          AppTone.danger,
                        ][i],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.chartTimeline,
          caption: ExamplesStrings.chartTimelineCaption,
          child: AppCard(
            child: AppTimeline(
              events: [
                for (final (title, meta) in ExamplesStrings.timelineEvents)
                  AppTimelineEvent(title: title, meta: meta),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.chartRing,
          caption: ExamplesStrings.chartRingCaption,
          child: AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (label, value) in ExamplesStrings.chartRingItems)
                  Expanded(
                    child: Column(
                      children: [
                        AppProgressRing(value: value, label: label),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          label,
                          style: AppTypography.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
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
                    SizedBox(height: AppSpacing.lg),
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
                  SizedBox(height: AppSpacing.sm),
                  AppProgressBar(
                    value: value,
                    color: value < .25 ? c.alert : null,
                  ),
                ],
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.countdown,
          caption: ExamplesStrings.countdownCaption,
          child: AppCard(
            child: Column(
              children: [
                AppCountdownRing(
                  value: ExamplesStrings.countdownShare,
                  time: ExamplesStrings.countdownTime,
                  label: ExamplesStrings.countdownLabel,
                  caption: ExamplesStrings.countdownTotal,
                  icon: Icons.water_drop_outlined,
                  size: AppSizes.countdownMd,
                ),
                SizedBox(height: AppSpacing.lg),
                AppCountdownRing(
                  value: ExamplesStrings.countdownHoldShare,
                  time: ExamplesStrings.countdownHoldTime,
                  label: ExamplesStrings.countdownHold,
                  caption: ExamplesStrings.countdownHoldTotal,
                  size: AppSizes.countdownSm,
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.dayStrip,
          caption: ExamplesStrings.dayStripCaption,
          child: AppCard(
            child: Column(
              children: [
                AppDayStrip(
                  days: [for (var d = 8; d <= 14; d++) _historyDay(d)],
                ),
                SizedBox(height: AppSpacing.lg),
                AppDayStrip(days: [for (var d = 8; d <= 14; d++) _goalDay(d)]),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.markedCalendar,
          caption: ExamplesStrings.markedCalendarCaption,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ExamplesStrings.markedHistory,
                      style: AppTypography.section.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppMarkedCalendar(
                      month: _month,
                      dayBuilder: (_, day) => _historyDay(day.day),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ExamplesStrings.markedGoal,
                      style: AppTypography.section.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppMarkedCalendar(
                      month: _month,
                      dayBuilder: (_, day) => _goalDay(day.day),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.metrics,
          caption: ExamplesStrings.metricsCaption,
          child: Column(
            children: [
              const AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: AppMetric(
                        label: ExamplesStrings.metricDistance,
                        value: ExamplesStrings.metricDistanceValue,
                        unit: ExamplesStrings.metricDistanceUnit,
                      ),
                    ),
                    Expanded(
                      child: AppMetric(
                        label: ExamplesStrings.metricPace,
                        value: ExamplesStrings.metricPaceValue,
                        unit: ExamplesStrings.metricPaceUnit,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: AppKpi(
                      label: ExamplesStrings.kpiWorkouts,
                      value: ExamplesStrings.kpiWorkoutsValue,
                      unit: ExamplesStrings.kpiPeriod,
                      change: ExamplesStrings.kpiWorkoutsChange,
                      positive: true,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: AppKpi(
                      label: ExamplesStrings.kpiMissed,
                      value: ExamplesStrings.kpiMissedValue,
                      unit: ExamplesStrings.kpiPeriod,
                      change: ExamplesStrings.kpiMissedChange,
                      positive: false,
                      icon: Icons.trending_down,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
