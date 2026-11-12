import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/widgets/app_headers.dart';
import 'package:flutter_app_template/core/widgets/app_icon_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('tab header shows overline, title and the action', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppTabHeader(
        overline: 'Hoje',
        title: 'Treino',
        action: AppIconButton(icon: Icons.add, label: 'Novo', onPressed: () {}),
      ),
      dark: dark,
    );
    expect(find.text('HOJE'), findsOneWidget);
    expect(find.text('Treino'), findsOneWidget);
    expect(find.byType(AppIconButton), findsOneWidget);
  });

  testWidgets('tab header is a heading for screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppTabHeader(title: 'Treino'));
    expect(
      tester.getSemantics(find.text('Treino')),
      isSemantics(label: 'Treino', isHeader: true),
    );
    handle.dispose();
  });

  testBothThemes('section header runs its action', (tester, dark) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppSectionHeader(
        title: 'Rotinas',
        actionLabel: 'Ver tudo',
        onAction: () => taps++,
      ),
      dark: dark,
    );
    expect(find.text('ROTINAS'), findsOneWidget);
    await tester.tap(find.byKey(AppSectionHeader.actionKey));
    expect(taps, 1);
  });

  testWidgets('section header without an action is only the label', (
    tester,
  ) async {
    await pumpApp(tester, const AppSectionHeader(title: 'Rotinas'));
    expect(find.text('ROTINAS'), findsOneWidget);
    expect(find.byKey(AppSectionHeader.actionKey), findsNothing);
  });
}
