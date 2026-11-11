import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_number_stepper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('minus and plus change the value by one', (
    tester,
    dark,
  ) async {
    final reported = <int>[];
    await pumpApp(
      tester,
      AppNumberStepper(label: 'Quantidade', value: 3, onChanged: reported.add),
      dark: dark,
    );
    expect(find.text('3'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(CommonStrings.increase));
    await tester.tap(find.bySemanticsLabel(CommonStrings.decrease));
    expect(reported, [4, 2]);
  });

  testWidgets('the limits disable their button', (tester) async {
    final reported = <int>[];
    await pumpApp(
      tester,
      AppNumberStepper(
        label: 'Quantidade',
        value: 1,
        min: 1,
        max: 1,
        onChanged: reported.add,
      ),
    );
    await tester.tap(find.bySemanticsLabel(CommonStrings.increase));
    await tester.tap(find.bySemanticsLabel(CommonStrings.decrease));
    expect(reported, isEmpty);
  });

  testWidgets('max never goes above 99', (tester) async {
    await pumpApp(
      tester,
      AppNumberStepper(
        label: 'Quantidade',
        value: 1,
        max: 150,
        onChanged: (_) {},
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });
}
