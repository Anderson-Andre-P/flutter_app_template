import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_button.dart';
import 'package:flutter_app_template/core/widgets/app_chip.dart';
import 'package:flutter_app_template/core/widgets/app_interactive.dart';
import 'package:flutter_app_template/core/widgets/app_list_tile.dart';
import 'package:flutter_app_template/core/widgets/app_text_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

AppColors _colors(bool dark) => dark ? AppColors.dark : AppColors.light;

Material _surface(WidgetTester tester, Finder of) => tester.widget<Material>(
  find.descendant(of: of, matching: find.byType(Material)).first,
);

BorderSide _side(Material m) => (m.shape! as RoundedRectangleBorder).side;

/// Holds a press long enough for the tap-down to register.
Future<TestGesture> _press(WidgetTester tester, Finder target) async {
  final gesture = await tester.startGesture(tester.getCenter(target));
  await tester.pump(kPressTimeout + const Duration(milliseconds: 10));
  return gesture;
}

void main() {
  testBothThemes('primary darkens while pressed', (tester, dark) async {
    final c = _colors(dark);
    await pumpApp(
      tester,
      AppButton(label: 'Salvar', onPressed: () {}),
      dark: dark,
    );
    final button = find.byType(AppButton);
    expect(_surface(tester, button).color, c.primary);
    final gesture = await _press(tester, button);
    expect(_surface(tester, button).color, c.primaryHover);
    await gesture.up();
    await tester.pump();
    expect(_surface(tester, button).color, c.primary);
  });

  testBothThemes('secondary gains the primary tint and border while pressed', (
    tester,
    dark,
  ) async {
    final c = _colors(dark);
    await pumpApp(
      tester,
      AppButton(
        label: 'Cancelar',
        variant: AppButtonVariant.secondary,
        onPressed: () {},
      ),
      dark: dark,
    );
    final button = find.byType(AppButton);
    final gesture = await _press(tester, button);
    final surface = _surface(tester, button);
    expect(surface.color, c.primarySubtle);
    expect(_side(surface).color, c.primary);
    expect(tester.widget<Text>(find.text('Cancelar')).style!.color, c.primary);
    await gesture.up();
  });

  testBothThemes('keyboard focus draws the focus ring', (tester, dark) async {
    await pumpApp(
      tester,
      AppButton(label: 'Salvar', onPressed: () {}),
      dark: dark,
    );
    expect(find.byKey(AppInteractive.focusRingKey), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final ring = find.byKey(AppInteractive.focusRingKey);
    expect(ring, findsOneWidget);
    final button = tester.getRect(find.byType(AppButton));
    final drawn = tester.getRect(ring);
    // 2px ring, 2px away from the control.
    expect(drawn.left, button.left - 4);
    expect(drawn.bottom, button.bottom + 4);
  });

  testBothThemes('a disabled chip is neutral and borderless', (
    tester,
    dark,
  ) async {
    final c = _colors(dark);
    await pumpApp(tester, const AppChip(label: 'Concluído'), dark: dark);
    final surface = _surface(tester, find.byType(AppChip));
    expect(surface.color, c.sunken);
    expect(_side(surface), BorderSide.none);
  });

  testBothThemes('an unselected chip gains the primary tint while pressed', (
    tester,
    dark,
  ) async {
    final c = _colors(dark);
    await pumpApp(
      tester,
      AppChip(label: 'Críticas', onSelected: (_) {}),
      dark: dark,
    );
    final chip = find.byType(AppChip);
    final gesture = await _press(tester, chip);
    final surface = _surface(tester, chip);
    expect(surface.color, c.primarySubtle);
    expect(_side(surface).color, c.primary);
    await gesture.up();
  });

  testBothThemes('a list row gains the primary tint while pressed', (
    tester,
    dark,
  ) async {
    final c = _colors(dark);
    await pumpApp(
      tester,
      AppListTile(title: 'OS-2041', onTap: () {}),
      dark: dark,
    );
    final row = find.byType(AppListTile);
    final gesture = await _press(tester, row);
    expect(_surface(tester, row).color, c.primarySubtle);
    await gesture.up();
  });

  testBothThemes('a disabled field has the neutral fill', (tester, dark) async {
    final c = _colors(dark);
    await pumpApp(
      tester,
      const AppTextField(label: 'Código', enabled: false),
      dark: dark,
    );
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration!.fillColor, c.sunken);
  });
}
