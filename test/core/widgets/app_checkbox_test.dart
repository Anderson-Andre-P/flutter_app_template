import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_checkbox.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('a tap flips the value', (tester, dark) async {
    bool? next;
    await pumpApp(
      tester,
      AppCheckbox(value: true, label: 'Lembrar', onChanged: (v) => next = v),
      dark: dark,
    );
    await tester.tap(find.text('Lembrar'));
    expect(next, isFalse);
  });

  testBothThemes('checked shows the check on the primary colour', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      AppCheckbox(value: true, onChanged: (_) {}),
      dark: dark,
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
    final box = tester.widget<AnimatedContainer>(
      find.byKey(AppCheckbox.boxKey),
    );
    expect((box.decoration! as BoxDecoration).color, c.primary);
  });

  testWidgets('unchecked shows no check', (tester) async {
    await pumpApp(tester, AppCheckbox(value: false, onChanged: (_) {}));
    expect(find.byIcon(Icons.check), findsNothing);
  });

  testWidgets('has a 44px touch target', (tester) async {
    await pumpApp(tester, AppCheckbox(value: false, onChanged: (_) {}));
    final size = tester.getSize(find.byType(AppCheckbox));
    expect(size.height, greaterThanOrEqualTo(AppSizes.minTouchTarget));
    expect(size.width, greaterThanOrEqualTo(AppSizes.minTouchTarget));
  });

  testWidgets('is exposed as a checked control', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppCheckbox(value: true, label: 'Lembrar', onChanged: (_) {}),
    );
    expect(
      tester.getSemantics(find.byType(AppCheckbox)),
      isSemantics(
        label: 'Lembrar',
        hasCheckedState: true,
        isChecked: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
      ),
    );
    handle.dispose();
  });
}
