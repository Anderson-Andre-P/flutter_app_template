import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_stepper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

const _steps = ['Detalhes', 'Prioridade', 'Responsável', 'Agenda'];

void main() {
  testBothThemes('done steps are checked, the current one is highlighted', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      const AppStepper(steps: _steps, current: 1),
      dark: dark,
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Prioridade')).style!.color,
      c.primary,
    );
    expect(tester.widget<Text>(find.text('Agenda')).style!.color, c.textMuted);
  });

  testWidgets('needs three to five steps', (tester) async {
    await pumpApp(tester, const AppStepper(steps: ['A', 'B'], current: 0));
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('reads the position to a screen reader', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester, const AppStepper(steps: _steps, current: 1));
    expect(
      find.bySemanticsLabel(AppStepper.positionLabel(2, 4, 'Prioridade')),
      findsOneWidget,
    );
    handle.dispose();
  });

  testBothThemes('step progress shows "Passo 2 de 5" and the share', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      const AppStepProgress(current: 2, total: 5),
      dark: dark,
    );
    expect(find.text(AppStepProgress.stepLabel(2, 5)), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
  });
}
