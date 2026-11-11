import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_more_menu.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('opens the actions; the destructive one is last and red', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    String? chosen;
    await pumpApp(
      tester,
      AppMoreMenu(
        actions: [
          AppMenuAction(label: 'Editar', onSelected: () => chosen = 'edit'),
          AppMenuAction(label: 'Duplicar', onSelected: () {}),
          AppMenuAction(
            label: 'Excluir',
            destructive: true,
            onSelected: () => chosen = 'delete',
          ),
        ],
      ),
      dark: dark,
    );
    await tester.tap(find.bySemanticsLabel(CommonStrings.moreActions));
    await tester.pumpAndSettle();
    expect(find.byType(Divider), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Excluir')).dy,
      greaterThan(tester.getTopLeft(find.byType(Divider)).dy),
    );
    expect(tester.widget<Text>(find.text('Excluir')).style!.color, c.danger);
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(chosen, 'edit');
  });

  testWidgets('more than six actions is a mistake', (tester) async {
    await pumpApp(
      tester,
      AppMoreMenu(
        actions: [
          for (var i = 0; i < 7; i++)
            AppMenuAction(label: '$i', onSelected: () {}),
        ],
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('a destructive action must come last', (tester) async {
    await pumpApp(
      tester,
      AppMenuActionsProbe(
        actions: [
          AppMenuAction(label: 'Excluir', destructive: true, onSelected: () {}),
          AppMenuAction(label: 'Editar', onSelected: () {}),
        ],
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });
}

/// Pumps an [AppMoreMenu] to run its build-time checks.
class AppMenuActionsProbe extends StatelessWidget {
  const AppMenuActionsProbe({super.key, required this.actions});

  final List<AppMenuAction> actions;

  @override
  Widget build(BuildContext context) => AppMoreMenu(actions: actions);
}
