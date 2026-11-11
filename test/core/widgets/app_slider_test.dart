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
}
