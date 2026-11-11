import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/widgets/app_settings_tile.dart';
import 'package:flutter_app_template/core/widgets/app_switch.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('a navigation row shows the detail and a chevron', (
    tester,
    dark,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppSettingsTile(
        icon: Icons.palette_outlined,
        title: 'Tema',
        subtitle: 'Claro ou escuro',
        detail: 'Automático',
        onTap: () => taps++,
      ),
      dark: dark,
    );
    expect(find.text('Automático'), findsOneWidget);
    expect(find.byKey(AppSettingsTile.chevronKey), findsOneWidget);
    expect(find.byType(AppSwitch), findsNothing);
    await tester.tap(find.text('Tema'));
    expect(taps, 1);
  });

  testBothThemes('a toggle row flips the switch from anywhere on the row', (
    tester,
    dark,
  ) async {
    final changes = <bool>[];
    await pumpApp(
      tester,
      AppSettingsTile.toggle(
        icon: Icons.notifications_none,
        title: 'Lembretes',
        checked: false,
        onChanged: changes.add,
      ),
      dark: dark,
    );
    expect(find.byKey(AppSettingsTile.chevronKey), findsNothing);
    await tester.tap(find.text('Lembretes'));
    // The switch only shows the state; the row under it takes the tap.
    await tester.tapAt(tester.getCenter(find.byType(AppSwitch)));
    expect(changes, [true, true]);
  });

  testWidgets('a toggle row reads as one toggled control', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppSettingsTile.toggle(
        icon: Icons.notifications_none,
        title: 'Lembretes',
        checked: true,
        onChanged: (_) {},
      ),
    );
    expect(
      tester.getSemantics(find.byType(AppSettingsTile)),
      isSemantics(
        label: 'Lembretes',
        hasToggledState: true,
        isToggled: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });
}
