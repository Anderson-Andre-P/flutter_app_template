import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_date_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the value as DD/MM/AAAA', (tester, dark) async {
    await pumpApp(
      tester,
      AppDateField(
        label: 'Prazo',
        value: DateTime(2026, 10, 23),
        onChanged: (_) {},
      ),
      dark: dark,
    );
    expect(find.text('23/10/2026'), findsOneWidget);
  });

  testWidgets('typing a date reports it when leaving the field', (
    tester,
  ) async {
    DateTime? reported;
    await pumpApp(
      tester,
      AppDateField(label: 'Prazo', onChanged: (d) => reported = d),
    );
    await tester.enterText(find.byType(TextField), '25122026');
    expect(find.text('25/12/2026'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(reported, DateTime(2026, 12, 25));
  });

  testWidgets('the calendar button opens the calendar', (tester) async {
    await pumpApp(
      tester,
      AppDateField(
        label: 'Prazo',
        value: DateTime(2026, 10, 23),
        onChanged: (_) {},
      ),
    );
    await tester.tap(find.bySemanticsLabel(CommonStrings.chooseDate));
    await tester.pumpAndSettle();
    expect(find.text('Outubro 2026'), findsOneWidget);
  });
}
