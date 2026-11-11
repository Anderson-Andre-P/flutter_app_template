import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_metric.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('metric shows the label in caps and the value with unit', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      const AppMetric(label: 'Distância', value: '5,20', unit: 'km'),
      dark: dark,
    );
    expect(find.text('DISTÂNCIA'), findsOneWidget);
    expect(find.text('5,20 km', findRichText: true), findsOneWidget);
  });

  for (final (positive, name) in [(true, 'green'), (false, 'red')]) {
    testBothThemes('a KPI paints its change $name', (tester, dark) async {
      final c = dark ? AppColors.dark : AppColors.light;
      await pumpApp(
        tester,
        AppKpi(
          label: 'Treinos',
          value: '12',
          unit: 'no mês',
          change: '+3 vs mês anterior',
          positive: positive,
        ),
        dark: dark,
      );
      expect(find.text('12 no mês', findRichText: true), findsOneWidget);
      final change = tester.widget<Text>(find.byKey(AppKpi.changeKey));
      expect(change.data, '+3 vs mês anterior');
      expect(change.style!.color, positive ? c.success : c.danger);
    });
  }
}
