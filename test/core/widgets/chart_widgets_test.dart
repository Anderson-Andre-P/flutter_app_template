import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/widgets/app_donut_chart.dart';
import 'package:flutter_app_template/core/widgets/app_line_chart.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('line chart paints with its labels', (tester, dark) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 300.w,
        child: const AppLineChart(
          values: [3, 5, 2, 7],
          labels: ['Jan', 'Fev', 'Mar', 'Abr'],
        ),
      ),
      dark: dark,
    );
    expect(find.text('Jan'), findsOneWidget);
    expect(find.text('Abr'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('line chart survives one value and all zeros', (tester) async {
    for (final values in [
      [4.0],
      [0.0, 0.0, 0.0],
      <double>[],
    ]) {
      await pumpApp(
        tester,
        SizedBox(
          width: 300.w,
          child: AppLineChart(values: values),
        ),
      );
      expect(tester.takeException(), isNull, reason: '$values');
    }
  });

  testBothThemes('donut shows the centre text and a legend entry per '
      'segment', (tester, dark) async {
    await pumpApp(
      tester,
      const AppDonutChart(
        centerLabel: '68%',
        centerCaption: 'usado',
        segments: [
          AppChartSegment(label: 'Moradia', value: 40),
          AppChartSegment(label: 'Mercado', value: 28),
          AppChartSegment(label: 'Lazer', value: 0),
        ],
      ),
      dark: dark,
    );
    expect(find.text('68%'), findsOneWidget);
    expect(find.text('usado'), findsOneWidget);
    expect(find.text('Moradia'), findsOneWidget);
    expect(find.text('Lazer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('donut with all-zero segments does not divide by zero', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppDonutChart(
        centerLabel: '0',
        segments: [
          AppChartSegment(label: 'A', value: 0),
          AppChartSegment(label: 'B', value: 0),
          AppChartSegment(label: 'C', value: 0),
        ],
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('donut needs at least three segments', (tester) async {
    await pumpApp(
      tester,
      const AppDonutChart(
        centerLabel: '68%',
        segments: [
          AppChartSegment(label: 'A', value: 1),
          AppChartSegment(label: 'B', value: 2),
        ],
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });
}
