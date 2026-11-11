import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// Day of an activity history (design system, section 37): the number in a
/// circle — solid primary [today] — and below it one dot per activity done
/// that day, each in its [AppTone] (one tone per kind of activity). Future
/// days are faded.
class AppHistoryDay extends StatelessWidget {
  const AppHistoryDay({
    super.key,
    required this.day,
    this.marks = const [],
    this.today = false,
    this.future = false,
    this.semanticLabel,
  });

  final int day;
  final List<AppTone> marks;
  final bool today;
  final bool future;

  /// What the day means for a screen reader ("9, treino e corrida").
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: semanticLabel ?? '$day',
      selected: today,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: AppSizes.dayCell),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.dayCircle,
                height: AppSizes.dayCircle,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: today ? c.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$day',
                  style:
                      (today ? AppTypography.label : AppTypography.labelMedium)
                          .copyWith(
                            color: today
                                ? c.onPrimary
                                : future
                                ? c.textDisabled
                                : c.textPrimary,
                          ),
                ),
              ),
              SizedBox(height: AppSpacing.xxs),
              SizedBox(
                height: AppSizes.dayMark,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (i, tone) in marks.indexed) ...[
                      if (i > 0) SizedBox(width: AppSpacing.xxs),
                      Container(
                        width: AppSizes.dayMark,
                        height: AppSizes.dayMark,
                        decoration: BoxDecoration(
                          color: c.toneForeground(tone),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// How a day did against its goal.
enum AppGoalStatus { met, below, today, future }

/// Day against a daily goal (design system, section 37): a tile with the
/// number and the day's [value] ("3,0"), coloured by [status] — green when
/// the goal was met, amber below it, tinted today, plain in the future.
class AppGoalDay extends StatelessWidget {
  const AppGoalDay({
    super.key,
    required this.day,
    required this.status,
    this.value,
    this.semanticLabel,
  });

  final int day;
  final AppGoalStatus status;
  final String? value;

  /// What the day means for a screen reader ("9, meta batida, 3,0").
  final String? semanticLabel;

  static ({Color background, Color foreground}) colorsOf(
    AppColors c,
    AppGoalStatus status,
  ) => switch (status) {
    AppGoalStatus.met => (background: c.success, foreground: c.onPrimary),
    AppGoalStatus.below => (background: c.alertSubtle, foreground: c.alertText),
    AppGoalStatus.today => (background: c.primarySubtle, foreground: c.primary),
    AppGoalStatus.future => (background: c.card, foreground: c.textMuted),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (:background, :foreground) = colorsOf(c, status);
    final future = status == AppGoalStatus.future;
    return Semantics(
      label: semanticLabel ?? ['$day', ?value].join(', '),
      selected: status == AppGoalStatus.today,
      child: ExcludeSemantics(
        // Up to 44px, smaller when seven of them share a narrow card.
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppSizes.goalDay,
            maxHeight: AppSizes.goalDay,
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: AppRadius.brSmPlus,
                border: future ? Border.all(color: c.border) : null,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$day',
                      style:
                          (future
                                  ? AppTypography.labelMedium
                                  : AppTypography.label)
                              .copyWith(color: foreground),
                    ),
                    if (value != null)
                      Text(
                        value!,
                        style: AppTypography.micro.copyWith(color: foreground),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A week of days side by side, spread across the width — the strip at the
/// top of a history or goal screen. [days] are `AppHistoryDay`s or
/// `AppGoalDay`s.
class AppDayStrip extends StatelessWidget {
  const AppDayStrip({super.key, required this.days});

  final List<Widget> days;

  @override
  Widget build(BuildContext context) => _Columns(days);
}

/// Equal columns, each item centred, as far apart as the rows of a
/// calendar ([AppSpacing.xs]).
class _Columns extends StatelessWidget {
  const _Columns(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final (i, child) in children.indexed) ...[
        if (i > 0) SizedBox(width: AppSpacing.xs),
        Expanded(child: Center(child: child)),
      ],
    ],
  );
}

/// Read-only month with a mark on each day (design system, section 37):
/// the weekday initials (week starting on Sunday) and one cell per day,
/// built by [dayBuilder] — an `AppHistoryDay` for a history, an
/// `AppGoalDay` for goals. To choose a date, use `AppCalendar`.
class AppMarkedCalendar extends StatelessWidget {
  const AppMarkedCalendar({
    super.key,
    required this.month,
    required this.dayBuilder,
  });

  /// Any day of the month to show.
  final DateTime month;
  final Widget Function(BuildContext context, DateTime day) dayBuilder;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final first = DateTime(month.year, month.month);
    // DateTime.weekday: Monday = 1 … Sunday = 7; the grid starts on Sunday.
    final leading = first.weekday % 7;
    final days = DateUtils.getDaysInMonth(first.year, first.month);
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= days; d++) DateTime(first.year, first.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Columns([
          for (final initial in CommonStrings.weekdayInitials)
            ExcludeSemantics(
              child: Text(
                initial,
                style: AppTypography.microBold.copyWith(color: c.textMuted),
              ),
            ),
        ]),
        for (var row = 0; row < cells.length; row += 7) ...[
          SizedBox(height: AppSpacing.xs),
          _Columns([
            for (final day in cells.sublist(row, row + 7))
              day == null ? const SizedBox.shrink() : dayBuilder(context, day),
          ]),
        ],
      ],
    );
  }
}
