import 'package:flutter_app_template/core/widgets/app_accordion.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

const _items = [
  AppAccordionItem(title: 'Como criar um registro?', body: 'Toque em Novo.'),
  AppAccordionItem(title: 'Funciona sem internet?', body: 'Sim, sincroniza.'),
];

void main() {
  testBothThemes('only the expanded panel shows its body', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppAccordion(items: _items, expanded: 1, onChanged: (_) {}),
      dark: dark,
    );
    await tester.pumpAndSettle();
    expect(find.text('Sim, sincroniza.'), findsOneWidget);
    expect(find.text('Toque em Novo.'), findsNothing);
  });

  testWidgets('tapping a closed header opens it; the open one closes', (
    tester,
  ) async {
    final reported = <int?>[];
    await pumpApp(
      tester,
      AppAccordion(items: _items, expanded: 1, onChanged: reported.add),
    );
    await tester.tap(find.text('Como criar um registro?'));
    await tester.tap(find.text('Funciona sem internet?'));
    expect(reported, [0, null]);
  });

  testWidgets('a header reads as expanded or collapsed', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppAccordion(items: _items, expanded: 1, onChanged: (_) {}),
    );
    expect(
      tester.getSemantics(find.text('Funciona sem internet?')),
      isSemantics(
        label: 'Funciona sem internet?',
        isButton: true,
        hasExpandedState: true,
        isExpanded: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
      ),
    );
    handle.dispose();
  });
}
