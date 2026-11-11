import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/widgets/app_load_more.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the summary and loads on tap', (tester, dark) async {
    var loads = 0;
    await pumpApp(
      tester,
      AppLoadMore(
        label: 'Carregar mais 20',
        summary: 'Mostrando 21–40 de 179',
        onPressed: () => loads++,
      ),
      dark: dark,
    );
    expect(find.text('Mostrando 21–40 de 179'), findsOneWidget);
    await tester.tap(find.text('Carregar mais 20'));
    expect(loads, 1);
  });

  testWidgets('while loading shows a spinner and ignores taps', (tester) async {
    var loads = 0;
    await pumpApp(
      tester,
      AppLoadMore(
        label: 'Carregar mais 20',
        loading: true,
        onPressed: () => loads++,
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(AppLoadMore));
    expect(loads, 0);
  });
}
