import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  final today = DateTime(2026, 10, 23);

  testBothThemes('shows the month and blocks days before firstDate', (
    tester,
    dark,
  ) async {
    DateTime? picked;
    await pumpApp(
      tester,
      AppCalendar(
        initialMonth: today,
        selected: today,
        firstDate: today,
        onSelected: (d) => picked = d,
      ),
      dark: dark,
    );
    expect(find.text('Outubro 2026'), findsOneWidget);
    await tester.tap(find.text('20'));
    expect(picked, isNull);
    await tester.tap(find.text('27'));
    expect(picked, DateTime(2026, 10, 27));
  });

  testWidgets('the arrows move between months', (tester) async {
    await pumpApp(tester, AppCalendar(initialMonth: today, onSelected: (_) {}));
    await tester.tap(find.bySemanticsLabel(CommonStrings.nextMonth));
    await tester.pump();
    expect(find.text('Novembro 2026'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(CommonStrings.previousMonth));
    await tester.tap(find.bySemanticsLabel(CommonStrings.previousMonth));
    await tester.pump();
    expect(find.text('Setembro 2026'), findsOneWidget);
  });

  testWidgets('pick opens a sheet and resolves only on Aplicar', (
    tester,
  ) async {
    late BuildContext ctx;
    await pumpApp(
      tester,
      Builder(
        builder: (c) {
          ctx = c;
          return const SizedBox();
        },
      ),
    );
    final result = AppCalendar.pick(
      ctx,
      title: 'Prazo',
      initial: today,
      firstDate: today,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('28'));
    await tester.pump();
    await tester.tap(find.text(CommonStrings.apply));
    await tester.pumpAndSettle();
    expect(await result, DateTime(2026, 10, 28));
  });

  testWidgets('pick resolves null on Cancelar', (tester) async {
    late BuildContext ctx;
    await pumpApp(
      tester,
      Builder(
        builder: (c) {
          ctx = c;
          return const SizedBox();
        },
      ),
    );
    final result = AppCalendar.pick(ctx, title: 'Prazo', initial: today);
    await tester.pumpAndSettle();
    await tester.tap(find.text('28'));
    await tester.tap(find.text(CommonStrings.cancel));
    await tester.pumpAndSettle();
    expect(await result, isNull);
  });
}
