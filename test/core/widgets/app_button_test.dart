import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
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

  testWidgets('destructiveTonal is a borderless danger-subtle button', (
    tester,
  ) async {
    await pumpApp(
      tester,
      AppButton(
        label: 'Sair',
        variant: AppButtonVariant.destructiveTonal,
        onPressed: () {},
      ),
    );
    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(AppButton),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, AppColors.light.dangerSubtle);
    expect((material.shape! as RoundedRectangleBorder).side, BorderSide.none);
    final text = tester.widget<Text>(find.text('Sair'));
    expect(text.style!.color, AppColors.light.danger);
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
      (AppButtonSize.xl, AppSizes.buttonXl),
      (AppButtonSize.lg, AppSizes.buttonLg),
      (AppButtonSize.md, AppSizes.buttonMd),
      (AppButtonSize.sm, AppSizes.buttonSm),
      (AppButtonSize.xs, AppSizes.buttonXs),
    ]) {
      await pumpApp(
        tester,
        AppButton(label: 'x', size: size, expanded: false, onPressed: () {}),
      );
      final visual = find.descendant(
        of: find.byType(AppButton),
        matching: find.byType(Material),
      );
      expect(tester.getSize(visual).height, height);
      // Smaller sizes are drawn smaller but still answer to 44px.
      expect(
        tester.getSize(find.byType(AppButton)).height,
        height < AppSizes.minTouchTarget ? AppSizes.minTouchTarget : height,
      );
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

  testBothThemes('success is a solid green button', (tester, dark) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      AppButton(
        label: 'Concluir',
        variant: AppButtonVariant.success,
        onPressed: () {},
      ),
      dark: dark,
    );
    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(AppButton),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, c.success);
    expect(
      tester.widget<Text>(find.text('Concluir')).style!.color,
      c.onPrimary,
    );
  });

  testWidgets('a trailing icon sits after the label', (tester) async {
    await pumpApp(
      tester,
      AppButton(
        label: 'Avançar',
        trailingIcon: Icons.arrow_forward,
        expanded: false,
        onPressed: () {},
      ),
    );
    expect(
      tester.getCenter(find.byIcon(Icons.arrow_forward)).dx,
      greaterThan(tester.getCenter(find.text('Avançar')).dx),
    );
  });

  testBothThemes('outlineSuccess is a green outline', (tester, dark) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      AppButton(
        label: 'Aprovar',
        variant: AppButtonVariant.outlineSuccess,
        onPressed: () {},
      ),
      dark: dark,
    );
    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(AppButton),
        matching: find.byType(Material),
      ),
    );
    expect((material.shape! as RoundedRectangleBorder).side.color, c.success);
    expect(tester.widget<Text>(find.text('Aprovar')).style!.color, c.success);
  });
}
