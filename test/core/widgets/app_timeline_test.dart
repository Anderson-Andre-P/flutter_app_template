import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_timeline.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

const _events = [
  AppTimelineEvent(title: 'Execução iniciada', meta: 'Hoje, 09:15 · Rafael'),
  AppTimelineEvent(title: 'Atribuído a Rafael', meta: '9 ago, 16:30 · Admin'),
  AppTimelineEvent(title: 'Registro criado', meta: '9 ago, 16:22 · Admin'),
];

void main() {
  testBothThemes('the latest event leads with the primary dot', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(tester, const AppTimeline(events: _events), dark: dark);
    expect(find.text('Registro criado'), findsOneWidget);
    final dots = tester.widgetList<Container>(find.byKey(AppTimeline.dotKey));
    expect((dots.first.decoration! as BoxDecoration).color, c.primary);
    expect((dots.last.decoration! as BoxDecoration).color, isNot(c.primary));
  });

  testBothThemes('the vertical stepper checks what is done', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      const AppVerticalStepper(steps: _events, current: 2),
      dark: dark,
    );
    expect(find.byIcon(Icons.check), findsNWidgets(2));
  });

  testBothThemes('a segmented bar names its parts for screen readers', (
    tester,
    dark,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      const AppSegmentedBar(
        segments: [
          AppBarSegment(label: 'Concluídas', value: 60, tone: AppTone.primary),
          AppBarSegment(label: 'Em atraso', value: 30, tone: AppTone.alert),
          AppBarSegment(label: 'Bloqueadas', value: 10, tone: AppTone.danger),
        ],
      ),
      dark: dark,
    );
    expect(
      find.bySemanticsLabel('Concluídas 60%, Em atraso 30%, Bloqueadas 10%'),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('page dots mark the current page', (tester) async {
    await pumpApp(tester, const AppPageDots(count: 4, current: 1));
    final dots = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();
    expect(dots, hasLength(4));
    expect(
      tester.getSize(find.byWidget(dots[1])).width,
      greaterThan(tester.getSize(find.byWidget(dots[0])).width),
    );
  });
}
