import 'package:flutter_app_template/core/widgets/app_load_stepper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows label, value, unit and hint, and reports the taps', (
    tester,
    dark,
  ) async {
    var down = 0;
    var up = 0;
    await pumpApp(
      tester,
      AppLoadStepper(
        label: 'Carga',
        value: '45',
        unit: 'kg',
        hint: 'anterior: 40 kg',
        decreaseLabel: '−1',
        increaseLabel: '+1',
        onDecrease: () => down++,
        onIncrease: () => up++,
      ),
      dark: dark,
    );
    expect(find.text('CARGA'), findsOneWidget);
    expect(find.text('45 kg', findRichText: true), findsOneWidget);
    expect(find.text('anterior: 40 kg'), findsOneWidget);
    await tester.tap(find.byKey(AppLoadStepper.decreaseKey));
    await tester.tap(find.byKey(AppLoadStepper.increaseKey));
    await tester.tap(find.byKey(AppLoadStepper.increaseKey));
    expect((down, up), (1, 2));
  });

  testWidgets('a null callback disables its button', (tester) async {
    var up = 0;
    await pumpApp(
      tester,
      AppLoadStepper(
        label: 'Carga',
        value: '0',
        decreaseLabel: '−1',
        increaseLabel: '+1',
        onDecrease: null,
        onIncrease: () => up++,
      ),
    );
    await tester.tap(find.byKey(AppLoadStepper.decreaseKey));
    expect(up, 0);
    expect(
      tester.getSemantics(find.byKey(AppLoadStepper.decreaseKey)),
      isSemantics(isButton: true, hasEnabledState: true, isEnabled: false),
    );
  });

  testWidgets('reads the label with the value and its unit', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppLoadStepper(
        label: 'Carga',
        value: '45',
        unit: 'kg',
        decreaseLabel: '−1',
        increaseLabel: '+1',
        onDecrease: () {},
        onIncrease: () {},
      ),
    );
    expect(find.bySemanticsLabel('Carga'), findsOneWidget);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Carga')),
      isSemantics(label: 'Carga', value: '45 kg', isLiveRegion: true),
    );
    handle.dispose();
  });
}
