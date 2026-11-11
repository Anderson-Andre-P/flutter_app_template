import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_bar_chart.dart';
import 'package:flutter_app_template/core/widgets/app_icon_box.dart';
import 'package:flutter_app_template/core/widgets/app_info_card.dart';
import 'package:flutter_app_template/core/widgets/app_progress_bar.dart';
import 'package:flutter_app_template/core/widgets/app_search_field.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('progress bar fills its share of the width', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      SizedBox(width: 200.w, child: const AppProgressBar(value: .25)),
      dark: dark,
    );
    final fill = tester.getSize(find.byKey(AppProgressBar.fillKey));
    expect(fill.width, 50);
    expect(fill.height, AppSizes.progressBar);
  });

  testWidgets('progress bar clamps values out of range', (tester) async {
    await pumpApp(
      tester,
      SizedBox(width: 200.w, child: const AppProgressBar(value: 1.7)),
    );
    expect(tester.getSize(find.byKey(AppProgressBar.fillKey)).width, 200);
  });

  testBothThemes('bar chart draws one bar and label per value', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 300.w,
        child: const AppBarChart(
          values: [2, 4, 0],
          labels: ['S', 'T', 'Q'],
          highlightIndex: 1,
        ),
      ),
      dark: dark,
    );
    expect(find.text('S'), findsOneWidget);
    expect(find.text('Q'), findsOneWidget);
    final tallest = tester.getSize(find.byKey(const ValueKey('bar-1')));
    final half = tester.getSize(find.byKey(const ValueKey('bar-0')));
    expect(half.height, closeTo(tallest.height / 2, 1));
  });

  testWidgets('bar chart with only zeros renders without dividing by zero', (
    tester,
  ) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 300.w,
        child: const AppBarChart(values: [0, 0], labels: ['A', 'B']),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testBothThemes('bar chart shows the values and the goal line', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 300.w,
        child: const AppBarChart(
          values: [2, 4],
          labels: ['S', 'T'],
          valueLabels: ['2,0', '4,0'],
          goal: 3,
          goalLabel: 'meta',
        ),
      ),
      dark: dark,
    );
    expect(find.text('2,0'), findsOneWidget);
    expect(find.text('4,0'), findsOneWidget);
    expect(find.text('meta'), findsOneWidget);
    // The goal line sits between the two bars' tops.
    final line = tester.getBottomLeft(find.byKey(AppBarChart.goalKey)).dy;
    final low = tester.getTopLeft(find.byKey(const ValueKey('bar-0'))).dy;
    final high = tester.getTopLeft(find.byKey(const ValueKey('bar-1'))).dy;
    expect(line, inExclusiveRange(high, low));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a goal above every value grows the scale', (tester) async {
    await pumpApp(
      tester,
      SizedBox(
        width: 300.w,
        child: const AppBarChart(values: [2], labels: ['S'], goal: 4),
      ),
    );
    final bar = tester.getSize(find.byKey(const ValueKey('bar-0'))).height;
    expect(bar, closeTo(AppSizes.chart / 2, 1));
  });

  testBothThemes('icon box shows its icon in every tone', (tester, dark) async {
    await pumpApp(
      tester,
      Row(
        children: [
          for (final t in AppTone.values)
            AppIconBox(icon: Icons.star_outline, tone: t),
        ],
      ),
      dark: dark,
    );
    expect(
      find.byIcon(Icons.star_outline),
      findsNWidgets(AppTone.values.length),
    );
  });

  testBothThemes('info card lists its title and rows', (tester, dark) async {
    await pumpApp(
      tester,
      const AppInfoCard(
        title: 'Resumo',
        rows: [('Valor', 'R\$ 10,00'), ('Total', 'R\$ 10,00')],
        emphasizeLast: true,
      ),
      dark: dark,
    );
    expect(find.text('RESUMO'), findsOneWidget);
    expect(find.text('Valor'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
  });

  testBothThemes('search field reports typed text and shows its hint', (
    tester,
    dark,
  ) async {
    String? typed;
    await pumpApp(
      tester,
      AppSearchField(hint: 'Buscar', onChanged: (v) => typed = v),
      dark: dark,
    );
    expect(find.text('Buscar'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'café');
    expect(typed, 'café');
  });
}
