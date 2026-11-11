import 'package:flutter_app_template/core/widgets/app_counter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the count and caps at 99+', (tester, dark) async {
    await pumpApp(tester, const AppCounter(count: 12), dark: dark);
    expect(find.text('12'), findsOneWidget);
    await pumpApp(tester, const AppCounter(count: 140), dark: dark);
    expect(find.text('99+'), findsOneWidget);
  });

  testWidgets('the new-item dot reads its label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppNewDot(label: 'Há novidade'));
    expect(find.bySemanticsLabel('Há novidade'), findsOneWidget);
    handle.dispose();
  });
}
