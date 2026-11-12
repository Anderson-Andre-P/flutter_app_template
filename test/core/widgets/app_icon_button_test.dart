import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_icon_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('is a 44px square that calls onPressed', (tester, dark) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppIconButton(
        icon: Icons.edit_outlined,
        label: 'Editar',
        onPressed: () => taps++,
      ),
      dark: dark,
    );
    expect(
      tester.getSize(find.byType(AppIconButton)),
      const Size.square(AppSizes.minTouchTarget),
    );
    await tester.tap(find.byType(AppIconButton));
    expect(taps, 1);
  });

  testWidgets('a screen reader hears the label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppIconButton(
        icon: Icons.edit_outlined,
        label: 'Editar',
        onPressed: () {},
      ),
    );
    expect(
      tester.getSemantics(find.byType(AppIconButton)),
      isSemantics(
        label: 'Editar',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('a long press shows the label as a tooltip', (tester) async {
    await pumpApp(
      tester,
      AppIconButton(
        icon: Icons.edit_outlined,
        label: 'Editar',
        onPressed: () {},
      ),
    );
    await tester.longPress(find.byType(AppIconButton));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Editar'), findsOneWidget);
  });
}
