import 'package:material_ui/material_ui.dart';
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

  testBothThemes('line chart labels the value of every point', (
    tester,
    dark,
  ) async {
    final labelled = <double>[];
    const values = [84.2, 83.1, 83.6, 81.9, 80.7, 79.4];
    await pumpApp(
      tester,
      SizedBox(
        width: 300.w,
        child: AppLineChart(
          values: values,
          startAtZero: false,
          valueLabel: (v) {
            labelled.add(v);
            return '$v';
          },
        ),
      ),
      dark: dark,
    );
    expect(labelled.toSet(), values.toSet());
    expect(tester.takeException(), isNull);
  });

  test('line chart scale fits the values when it does not start at zero', () {
    const values = [84.2, 83.1, 79.4];
    final (low, high) = AppLineChart.range(values, startAtZero: false);
    expect(low, lessThan(79.4));
    expect(low, greaterThan(70));
    expect(high, greaterThan(84.2));
    expect(AppLineChart.range(values), (0.0, 84.2));
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
