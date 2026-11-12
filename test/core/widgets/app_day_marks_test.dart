import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_day_marks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Iterable<Color?> _dotColors(WidgetTester tester) => tester
    .widgetList<Container>(
      find.descendant(
        of: find.byType(AppHistoryDay),
        matching: find.byType(Container),
      ),
    )
    .map((w) => (w.decoration as BoxDecoration?)?.color)
    .skip(1);

void main() {
  testBothThemes('a history day shows one dot per activity, in its tone', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      const AppHistoryDay(day: 9, marks: [AppTone.primary, AppTone.success]),
      dark: dark,
    );
    expect(find.text('9'), findsOneWidget);
    expect(_dotColors(tester), [c.primary, c.success]);
  });

  testBothThemes('today is a solid primary circle', (tester, dark) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(tester, const AppHistoryDay(day: 9, today: true), dark: dark);
    final circle = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AppHistoryDay),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((circle.decoration! as BoxDecoration).color, c.primary);
    expect(tester.widget<Text>(find.text('9')).style!.color, c.onPrimary);
  });

  testBothThemes('a goal day is coloured by its status', (tester, dark) async {
    final c = dark ? AppColors.dark : AppColors.light;
    for (final status in AppGoalStatus.values) {
      await pumpApp(
        tester,
        AppGoalDay(day: 9, value: '3,0', status: status),
        dark: dark,
      );
      final colours = AppGoalDay.colorsOf(c, status);
      final tile = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppGoalDay),
          matching: find.byType(Container),
        ),
      );
      expect((tile.decoration! as BoxDecoration).color, colours.background);
      expect(
        tester.widget<Text>(find.text('3,0')).style!.color,
        colours.foreground,
      );
    }
  });

  testWidgets('goal day colours follow the design system', (tester) async {
    const c = AppColors.light;
    expect(AppGoalDay.colorsOf(c, AppGoalStatus.met).background, c.success);
    expect(
      AppGoalDay.colorsOf(c, AppGoalStatus.below).background,
      c.alertSubtle,
    );
    expect(
      AppGoalDay.colorsOf(c, AppGoalStatus.today).background,
      c.primarySubtle,
    );
  });

  testBothThemes('the marked calendar lays out the month from Sunday', (
    tester,
    dark,
  ) async {
    // November 2026 starts on a Sunday and has 30 days.
    final built = <DateTime>[];
    await pumpApp(
      tester,
      SizedBox(
        width: 320,
        child: AppMarkedCalendar(
          month: DateTime(2026, 11, 15),
          dayBuilder: (context, day) {
            built.add(day);
            return AppGoalDay(day: day.day, status: AppGoalStatus.future);
          },
        ),
      ),
      dark: dark,
    );
    expect(built.length, 30);
    expect(built.first, DateTime(2026, 11));
    final first = tester.getTopLeft(find.text('1')).dx;
    final second = tester.getTopLeft(find.text('2')).dx;
    expect(first, lessThan(second));
    expect(find.text('30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('goal days shrink to fit a narrow card', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 260,
        child: AppMarkedCalendar(
          month: DateTime(2026, 11),
          dayBuilder: (context, day) =>
              AppGoalDay(day: day.day, value: '3,0', status: AppGoalStatus.met),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the day strip shows every day', (tester) async {
    await pumpApp(
      tester,
      AppDayStrip(days: [for (var d = 8; d <= 14; d++) AppHistoryDay(day: d)]),
    );
    for (var d = 8; d <= 14; d++) {
      expect(find.text('$d'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  double gapBetween(WidgetTester tester, String a, String b) {
    Rect tile(String day) => tester.getRect(
      find.ancestor(of: find.text(day), matching: find.byType(AspectRatio)),
    );
    return tile(b).left - tile(a).right;
  }

  testWidgets('calendar columns are as far apart as its rows', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 288,
        child: AppMarkedCalendar(
          month: DateTime(2026, 11),
          dayBuilder: (context, day) =>
              AppGoalDay(day: day.day, value: '3,0', status: AppGoalStatus.met),
        ),
      ),
    );
    Rect tile(String day) => tester.getRect(
      find.ancestor(of: find.text(day), matching: find.byType(AspectRatio)),
    );
    final rowGap = tile('8').top - tile('1').bottom;
    expect(rowGap, greaterThanOrEqualTo(AppSpacing.xs));
    expect(gapBetween(tester, '1', '2'), greaterThanOrEqualTo(rowGap - .5));
  });

  testWidgets('the day strip keeps a gap between goal tiles', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 288,
        child: AppDayStrip(
          days: [
            for (var d = 8; d <= 14; d++)
              AppGoalDay(day: d, value: '3,0', status: AppGoalStatus.met),
          ],
        ),
      ),
    );
    expect(gapBetween(tester, '8', '9'), greaterThanOrEqualTo(AppSpacing.xs));
  });
}
