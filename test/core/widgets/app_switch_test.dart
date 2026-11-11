import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_switch.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('a tap flips the value', (tester, dark) async {
    bool? next;
    await pumpApp(
      tester,
      AppSwitch(
        value: false,
        label: 'Notificações',
        onChanged: (v) => next = v,
      ),
      dark: dark,
    );
    await tester.tap(find.text('Notificações'));
    expect(next, isTrue);
  });

  testWidgets('disabled ignores taps', (tester) async {
    await pumpApp(
      tester,
      const AppSwitch(value: true, label: 'Wi-Fi', onChanged: null),
    );
    await tester.tap(find.text('Wi-Fi'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('has a 44px touch target and a 46x26 track', (tester) async {
    await pumpApp(tester, AppSwitch(value: true, onChanged: (_) {}));
    expect(
      tester.getSize(find.byType(AppSwitch)).height,
      greaterThanOrEqualTo(AppSizes.minTouchTarget),
    );
    expect(
      tester.getSize(find.byKey(AppSwitch.trackKey)),
      Size(AppSizes.switchWidth, AppSizes.switchHeight),
    );
  });

  testWidgets('is exposed as a toggled control', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppSwitch(value: true, label: 'Wi-Fi', onChanged: (_) {}),
    );
    expect(
      tester.getSemantics(find.byType(AppSwitch)),
      isSemantics(
        label: 'Wi-Fi',
        hasToggledState: true,
        isToggled: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
      ),
    );
    handle.dispose();
  });
}
