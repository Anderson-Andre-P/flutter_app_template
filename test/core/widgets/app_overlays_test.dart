import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/widgets/app_coach_mark.dart';
import 'package:flutter_app_template/core/widgets/app_tooltip.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('a tap shows the tooltip message', (tester, dark) async {
    await pumpApp(
      tester,
      const AppTooltip(
        message: 'Bloqueado após iniciar',
        child: Icon(Icons.lock_outline),
      ),
      dark: dark,
    );
    expect(find.text('Bloqueado após iniciar'), findsNothing);
    await tester.tap(find.byIcon(Icons.lock_outline));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Bloqueado após iniciar'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testBothThemes('a coach mark is dismissed with one tap', (
    tester,
    dark,
  ) async {
    var dismissed = 0;
    await pumpApp(
      tester,
      AppCoachMark(
        title: 'Arraste para reordenar',
        message: 'Segure a alça e mova o item.',
        onDismiss: () => dismissed++,
      ),
      dark: dark,
    );
    expect(find.text('Arraste para reordenar'), findsOneWidget);
    await tester.tap(find.text('Segure a alça e mova o item.'));
    expect(dismissed, 1);
  });
}
