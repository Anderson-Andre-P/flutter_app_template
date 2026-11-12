import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/widgets/app_split_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('the two halves call different actions', (tester, dark) async {
    var main = 0;
    var menu = 0;
    await pumpApp(
      tester,
      AppSplitButton(
        label: 'Exportar',
        menuLabel: 'Outros formatos',
        onPressed: () => main++,
        onMenu: () => menu++,
      ),
      dark: dark,
    );
    await tester.tap(find.text('Exportar'));
    await tester.tap(find.byIcon(Icons.expand_more));
    expect(main, 1);
    expect(menu, 1);
  });

  testWidgets('the menu half reads its label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppSplitButton(
        label: 'Exportar',
        menuLabel: 'Outros formatos',
        onPressed: () {},
        onMenu: () {},
      ),
    );
    expect(find.bySemanticsLabel('Outros formatos'), findsOneWidget);
    handle.dispose();
  });
}
