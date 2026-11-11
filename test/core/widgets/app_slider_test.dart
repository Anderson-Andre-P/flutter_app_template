import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/widgets/app_slider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the value next to the label and the limits', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppSlider(
        label: 'Volume de alertas',
        value: 60,
        max: 100,
        valueLabel: (v) => '${v.round()}%',
        onChanged: (_) {},
      ),
      dark: dark,
    );
    expect(find.text('Volume de alertas'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('dragging reports new values', (tester) async {
    double? reported;
    await pumpApp(
      tester,
      SizedBox(
        width: 300,
        child: AppSlider(
          label: 'Volume',
          value: 50,
          max: 100,
          valueLabel: (v) => '${v.round()}',
          onChanged: (v) => reported = v,
        ),
      ),
    );
    await tester.drag(find.byType(Slider), const Offset(100, 0));
    expect(reported, greaterThan(50));
  });

  testWidgets('the handle has a 44px touch target', (tester) async {
    await pumpApp(
      tester,
      AppSlider(
        label: 'Volume',
        value: 50,
        max: 100,
        valueLabel: (v) => '${v.round()}',
        onChanged: (_) {},
      ),
    );
    expect(
      tester.getSize(find.byType(Slider)).height,
      greaterThanOrEqualTo(44),
    );
  });

  testBothThemes('named steps label each mark and snap to them', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppSlider.steps(
        label: 'Prioridade',
        steps: const ['Baixa', 'Média', 'Alta', 'Crítica'],
        index: 2,
        onChanged: (_) {},
      ),
      dark: dark,
    );
    expect(find.text('Baixa'), findsOneWidget);
    expect(find.text('Crítica'), findsOneWidget);
    // The current step is the value next to the label and its mark.
    expect(find.text('Alta'), findsNWidgets(2));
    expect(tester.widget<Slider>(find.byType(Slider)).divisions, 3);
  });

  testBothThemes('a range shows both ends next to the label', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppRangeSlider(
        label: 'Prazo (dias)',
        values: const RangeValues(7, 21),
        min: 1,
        max: 30,
        valueLabel: (v) => '${v.round()}',
        onChanged: (_) {},
      ),
      dark: dark,
    );
    expect(find.text(AppRangeSlider.rangeLabel('7', '21')), findsOneWidget);
    expect(find.byType(RangeSlider), findsOneWidget);
  });
}
