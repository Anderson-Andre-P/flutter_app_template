import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_status_tile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the value, the label and a bar in the tone', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      const AppStatusTile(value: '24', label: 'Em atraso', tone: AppTone.alert),
      dark: dark,
    );
    expect(find.text('24'), findsOneWidget);
    expect(find.text('Em atraso'), findsOneWidget);
    final bar = tester.widget<ColoredBox>(find.byKey(AppStatusTile.barKey));
    expect(bar.color, c.alert);
  });

  testWidgets('reads value and label together', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppStatusTile(value: '24', label: 'Em atraso'));
    expect(
      tester.getSemantics(find.byType(AppStatusTile)),
      isSemantics(label: '24\nEm atraso'),
    );
    handle.dispose();
  });
}
