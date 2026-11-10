import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('a disabled button ignores taps', (tester, dark) async {
    await pumpApp(
      tester,
      const AppButton(label: 'Salvar', onPressed: null),
      dark: dark,
    );
    await tester.tap(find.text('Salvar'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping calls onPressed', (tester) async {
    var taps = 0;
    await pumpApp(tester, AppButton(label: 'Salvar', onPressed: () => taps++));
    await tester.tap(find.text('Salvar'));
    expect(taps, 1);
  });

  testWidgets('loading shows a spinner and ignores taps', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppButton(label: 'Salvar', loading: true, onPressed: () => taps++),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(taps, 0);
  });

  test('the large button matches the field height of the design', () {
    expect(AppSizes.buttonLg, AppSizes.field);
  });

  testWidgets('heights follow the size scale', (tester) async {
    for (final (size, height) in [
      (AppButtonSize.lg, AppSizes.buttonLg),
      (AppButtonSize.md, AppSizes.buttonMd),
      (AppButtonSize.sm, AppSizes.buttonSm),
    ]) {
      await pumpApp(
        tester,
        AppButton(label: 'x', size: size, expanded: false, onPressed: () {}),
      );
      expect(tester.getSize(find.byType(AppButton)).height, height);
    }
  });

  testBothThemes('every variant renders', (tester, dark) async {
    for (final v in AppButtonVariant.values) {
      await pumpApp(
        tester,
        AppButton(label: v.name, variant: v, icon: Icons.add, onPressed: () {}),
        dark: dark,
      );
      expect(find.text(v.name), findsOneWidget);
    }
  });
}
