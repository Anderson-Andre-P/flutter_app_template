import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import '../utils/formatters.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';
import 'app_button_group.dart';
import 'app_icon_button.dart';
import 'app_interactive.dart';

/// Month calendar of the design system (section 26): the month with arrows
/// to move, weeks starting on Sunday, days outside [firstDate]..[lastDate]
/// blocked (a deadline that cannot go back blocks the past).
///
/// On a phone, choose a date with [AppCalendar.pick]: a bottom sheet with
/// Cancelar and Aplicar.
class AppCalendar extends StatelessWidget {
  const AppCalendar({
    super.key,
    required this.initialMonth,
    required this.onSelected,
    this.selected,
    this.firstDate,
    this.lastDate,
  });

  final DateTime initialMonth;
  final DateTime? selected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onSelected;

  /// Opens the calendar in a bottom sheet; resolves to the chosen day on
  /// Aplicar, or `null` on Cancelar or a dismiss.
  static Future<DateTime?> pick(
    BuildContext context, {
    required String title,
    DateTime? initial,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final start = initial ?? firstDate ?? DateUtils.dateOnly(DateTime.now());
    return AppBottomSheet.show<DateTime>(
      context,
      title: title,
      child: BlocProvider(
        create: (_) => _CalendarBloc(start, initial),
        child: Builder(
          builder: (sheetContext) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CalendarBody(firstDate: firstDate, lastDate: lastDate),
              SizedBox(height: AppSpacing.lg),
              BlocBuilder<_CalendarBloc, _CalendarState>(
                builder: (context, state) => AppButtonGroup.pair(
                  secondary: AppButton(
                    label: CommonStrings.cancel,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                  primary: AppButton(
                    label: CommonStrings.apply,
                    onPressed: state.picked == null
                        ? null
                        : () => Navigator.of(sheetContext).pop(state.picked),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => _CalendarBloc(initialMonth, selected),
    child: _CalendarBody(
      firstDate: firstDate,
      lastDate: lastDate,
      onSelected: onSelected,
    ),
  );
}

final class _CalendarState extends Equatable {
  const _CalendarState(this.month, this.picked);

  /// First day of the month on screen.
  final DateTime month;
  final DateTime? picked;

  @override
  List<Object?> get props => [month, picked];
}

sealed class _CalendarEvent {
  const _CalendarEvent();
}

final class _MonthShifted extends _CalendarEvent {
  const _MonthShifted(this.by);
  final int by;
}

final class _DayPicked extends _CalendarEvent {
  const _DayPicked(this.day);
  final DateTime day;
}

/// The month on screen and the day tapped — UI-only state of one calendar.
class _CalendarBloc extends Bloc<_CalendarEvent, _CalendarState> {
  _CalendarBloc(DateTime month, DateTime? picked)
    : super(
        _CalendarState(
          DateTime(month.year, month.month),
          picked == null ? null : DateUtils.dateOnly(picked),
        ),
      ) {
    on<_MonthShifted>(
      (e, emit) => emit(
        _CalendarState(
          DateTime(state.month.year, state.month.month + e.by),
          state.picked,
        ),
      ),
    );
    on<_DayPicked>((e, emit) => emit(_CalendarState(state.month, e.day)));
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody({this.firstDate, this.lastDate, this.onSelected});

  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onSelected;

  bool _blocked(DateTime day) =>
      (firstDate != null && day.isBefore(DateUtils.dateOnly(firstDate!))) ||
      (lastDate != null && day.isAfter(DateUtils.dateOnly(lastDate!)));

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = context.watch<_CalendarBloc>().state;
    final bloc = context.read<_CalendarBloc>();
    final month = state.month;
    // DateTime.weekday: Monday = 1 … Sunday = 7; the grid starts on Sunday.
    final leading = month.weekday % 7;
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= days; d++) DateTime(month.year, month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                formatMonthYear(month),
                style: AppTypography.section.copyWith(color: c.textPrimary),
              ),
            ),
            AppIconButton(
              icon: Icons.chevron_left,
              label: CommonStrings.previousMonth,
              bordered: false,
              onPressed: () => bloc.add(const _MonthShifted(-1)),
            ),
            AppIconButton(
              icon: Icons.chevron_right,
              label: CommonStrings.nextMonth,
              bordered: false,
              onPressed: () => bloc.add(const _MonthShifted(1)),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (final initial in CommonStrings.weekdayInitials)
              Expanded(
                child: Center(
                  child: Text(
                    initial,
                    style: AppTypography.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        for (var row = 0; row < cells.length; row += 7)
          Row(
            children: [
              for (final day in cells.sublist(row, row + 7))
                Expanded(
                  child: day == null
                      ? const SizedBox(height: AppSizes.minTouchTarget)
                      : _Day(
                          day: day,
                          selected: day == state.picked,
                          onTap: _blocked(day)
                              ? null
                              : () {
                                  bloc.add(_DayPicked(day));
                                  onSelected?.call(day);
                                },
                        ),
                ),
            ],
          ),
      ],
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({required this.day, required this.selected, required this.onTap});

  final DateTime day;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: SizedBox.square(
        dimension: AppSizes.minTouchTarget,
        child: MergeSemantics(
          child: Semantics(
            button: true,
            selected: selected,
            enabled: onTap != null,
            child: AppInteractive(
              onTap: onTap,
              borderRadius: AppRadius.brFull,
              surface: (state) => (
                color: selected
                    ? c.primary
                    : state.pressed
                    ? c.primarySubtle
                    : Colors.transparent,
                border: null,
                shadows: const <BoxShadow>[],
              ),
              builder: (context, state) => Center(
                child: Text(
                  '${day.day}',
                  style: (selected ? AppTypography.label : AppTypography.body)
                      .copyWith(
                        color: selected
                            ? c.onPrimary
                            : onTap == null
                            ? c.textDisabled
                            : c.textPrimary,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
