import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_tabs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

const _tabs = [
  AppTab(label: 'Visão geral', count: 3),
  AppTab(label: 'Histórico'),
  AppTab(label: 'Documentos', count: 12),
];

void main() {
  testBothThemes('the selected tab is primary and underlined', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      AppTabs(tabs: _tabs, selected: 0, onChanged: (_) {}),
      dark: dark,
    );
    expect(
      tester.widget<Text>(find.text('Visão geral')).style!.color,
      c.primary,
    );
    expect(
      tester.widget<Text>(find.text('Histórico')).style!.color,
      c.textMuted,
    );
    expect(find.byKey(AppTabs.indicatorKey), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('tapping a tab reports its index', (tester) async {
    int? chosen;
    await pumpApp(
      tester,
      AppTabs(tabs: _tabs, selected: 0, onChanged: (i) => chosen = i),
    );
    await tester.tap(find.text('Documentos'));
    expect(chosen, 2);
  });

  testWidgets('a tab is a selectable button', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, AppTabs(tabs: _tabs, selected: 0, onChanged: (_) {}));
    expect(
      tester.getSemantics(find.text('Visão geral')),
      isSemantics(
        label: 'Visão geral\n3',
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
}
