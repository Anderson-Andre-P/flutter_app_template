import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_option_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Material _surface(WidgetTester tester, String title) => tester.widget<Material>(
  find
      .descendant(
        of: find.widgetWithText(AppOptionCard<int>, title),
        matching: find.byType(Material),
      )
      .first,
);

void main() {
  testBothThemes('the selected card gets the primary border and tint', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    int? chosen;
    await pumpApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppOptionCard<int>(
            value: 0,
            groupValue: 1,
            icon: Icons.credit_card,
            title: 'Cartão',
            subtitle: 'Visa •••• 4021',
            onChanged: (v) => chosen = v,
          ),
          AppOptionCard<int>(
            value: 1,
            groupValue: 1,
            icon: Icons.pix,
            title: 'Pix',
            onChanged: (v) => chosen = v,
          ),
        ],
      ),
      dark: dark,
    );
    final selected = _surface(tester, 'Pix');
    expect(selected.color, c.primarySubtle);
    expect((selected.shape! as RoundedRectangleBorder).side.color, c.primary);
    expect(_surface(tester, 'Cartão').color, c.card);
    await tester.tap(find.text('Cartão'));
    expect(chosen, 0);
  });

  testWidgets('is a checked option of a group', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppOptionCard<int>(
        value: 1,
        groupValue: 1,
        icon: Icons.pix,
        title: 'Pix',
        onChanged: (_) {},
      ),
    );
    expect(
      tester.getSemantics(find.byType(AppOptionCard<int>)),
      isSemantics(
        label: 'Pix',
        hasCheckedState: true,
        isChecked: true,
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
