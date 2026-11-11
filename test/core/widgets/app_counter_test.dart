import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
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

  testBothThemes('over an icon it is smaller and ringed in the surface', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(tester, const AppCounter(count: 3), dark: dark);
    final plain = tester.getSize(find.byType(AppCounter));
    await pumpApp(tester, AppCounter(count: 3, ring: c.screen), dark: dark);
    final compact = tester.getSize(find.byType(AppCounter));
    expect(compact.height, lessThan(plain.height));
    final box = tester.widget<Container>(
      find.descendant(
        of: find.byType(AppCounter),
        matching: find.byType(Container),
      ),
    );
    final border = (box.decoration! as BoxDecoration).border! as Border;
    expect(border.top.color, c.screen);
  });

  testWidgets('the new-item dot reads its label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppNewDot(label: 'Há novidade'));
    expect(find.bySemanticsLabel('Há novidade'), findsOneWidget);
    handle.dispose();
  });
}
