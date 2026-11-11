import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_segmented_control.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

const _levels = [
  AppSegment(value: 0, label: 'Baixa'),
  AppSegment(value: 1, label: 'Média'),
  AppSegment(value: 2, label: 'Alta'),
];

void main() {
  testBothThemes('the selected segment is in the primary colour', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      AppSegmentedControl(segments: _levels, selected: 1, onChanged: (_) {}),
      dark: dark,
    );
    expect(tester.widget<Text>(find.text('Média')).style!.color, c.primary);
    expect(tester.widget<Text>(find.text('Baixa')).style!.color, c.textMuted);
  });

  testWidgets('tapping a segment reports its value', (tester) async {
    int? chosen;
    await pumpApp(
      tester,
      AppSegmentedControl(
        segments: _levels,
        selected: 1,
        onChanged: (v) => chosen = v,
      ),
    );
    await tester.tap(find.text('Alta'));
    expect(chosen, 2);
  });

  testWidgets('segments share the width and the control is 44px high', (
    tester,
  ) async {
    await pumpApp(
      tester,
      AppSegmentedControl(segments: _levels, selected: 0, onChanged: (_) {}),
    );
    expect(
      tester.getSize(find.byType(AppSegmentedControl<int>)).height,
      AppSizes.buttonMd,
    );
    final a = tester.getSize(find.widgetWithText(InkWell, 'Baixa'));
    final b = tester.getSize(find.widgetWithText(InkWell, 'Alta'));
    expect(a.width, b.width);
  });

  testWidgets('each segment is a selectable button', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppSegmentedControl(segments: _levels, selected: 1, onChanged: (_) {}),
    );
    expect(
      tester.getSemantics(find.text('Média')),
      isSemantics(
        label: 'Média',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
      ),
    );
    handle.dispose();
  });

  testBothThemes('joined: the active segment is tinted inside one outline', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      AppSegmentedControl(
        style: AppSegmentedStyle.joined,
        segments: _levels,
        selected: 0,
        onChanged: (_) {},
      ),
      dark: dark,
    );
    expect(tester.widget<Text>(find.text('Baixa')).style!.color, c.primary);
    expect(tester.widget<Text>(find.text('Média')).style!.color, c.textPrimary);
  });

  testWidgets('an icon-only segment reads its label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppSegmentedControl(
        style: AppSegmentedStyle.joined,
        segments: const [
          AppSegment(
            value: 0,
            label: 'Lista',
            icon: Icons.list,
            iconOnly: true,
          ),
          AppSegment(
            value: 1,
            label: 'Grade',
            icon: Icons.grid_view,
            iconOnly: true,
          ),
        ],
        selected: 0,
        onChanged: (_) {},
      ),
    );
    expect(find.text('Lista'), findsNothing);
    expect(find.bySemanticsLabel('Grade'), findsOneWidget);
    handle.dispose();
  });
}
