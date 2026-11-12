import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_fab.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('the round FAB is a 58px square with only the icon', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppFab(icon: Icons.add, label: 'Novo', onPressed: () {}),
      dark: dark,
    );
    expect(tester.getSize(find.byType(AppFab)), Size.square(AppSizes.fab));
    expect(find.text('Novo'), findsNothing);
  });

  testBothThemes('the extended FAB shows the label', (tester, dark) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppFab(
        icon: Icons.add,
        label: 'Novo',
        extended: true,
        onPressed: () => taps++,
      ),
      dark: dark,
    );
    expect(tester.getSize(find.byType(AppFab)).height, AppSizes.fabExtended);
    await tester.tap(find.text('Novo'));
    expect(taps, 1);
  });

  testWidgets('the round FAB reads its label to a screen reader', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppFab(icon: Icons.add, label: 'Novo', onPressed: () {}),
    );
    expect(
      tester.getSemantics(find.byType(AppFab)),
      isSemantics(
        label: 'Novo',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
      ),
    );
    handle.dispose();
  });
}
