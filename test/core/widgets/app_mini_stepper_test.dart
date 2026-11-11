import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_mini_stepper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('steps the value by one', (tester, dark) async {
    final changes = <int>[];
    await pumpApp(
      tester,
      AppMiniStepper(label: 'Séries', value: 3, onChanged: changes.add),
      dark: dark,
    );
    expect(find.text('3'), findsOneWidget);
    await tester.tap(find.byKey(AppMiniStepper.decreaseKey));
    await tester.tap(find.byKey(AppMiniStepper.increaseKey));
    expect(changes, [2, 4]);
  });

  testWidgets('the button at a limit does nothing', (tester) async {
    final changes = <int>[];
    await pumpApp(
      tester,
      AppMiniStepper(
        label: 'Séries',
        value: 1,
        min: 1,
        max: 1,
        onChanged: changes.add,
      ),
    );
    await tester.tap(find.byKey(AppMiniStepper.decreaseKey));
    await tester.tap(find.byKey(AppMiniStepper.increaseKey));
    expect(changes, isEmpty);
  });

  testWidgets('draws 32px buttons inside 44px touch targets', (tester) async {
    await pumpApp(
      tester,
      AppMiniStepper(label: 'Séries', value: 3, onChanged: (_) {}),
    );
    final target = tester.getSize(find.byKey(AppMiniStepper.increaseKey));
    expect(target.shortestSide, greaterThanOrEqualTo(AppSizes.minTouchTarget));
  });
}
