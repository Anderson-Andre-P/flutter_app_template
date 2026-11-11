import 'package:flutter_app_template/core/widgets/app_progress_ring.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the percentage in the centre', (tester, dark) async {
    await pumpApp(tester, const AppProgressRing(value: .62), dark: dark);
    expect(find.text('62%'), findsOneWidget);
  });

  testWidgets('clamps the value and reads it as a percentage', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppProgressRing(value: 1.4, label: 'Envio'));
    expect(find.text('100%'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(AppProgressRing)),
      isSemantics(label: 'Envio', value: '100%'),
    );
    handle.dispose();
  });
}
