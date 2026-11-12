import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/widgets/app_radio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('tapping an option selects its value', (tester, dark) async {
    int? chosen;
    await pumpApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadio(value: 1, groupValue: 1, label: 'Pix', onChanged: (_) {}),
          AppRadio(
            value: 2,
            groupValue: 1,
            label: 'Boleto',
            onChanged: (v) => chosen = v,
          ),
        ],
      ),
      dark: dark,
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
    await tester.tap(find.text('Boleto'));
    expect(chosen, 2);
  });

  testWidgets('is exposed as a checked option of a group', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      AppRadio(value: 1, groupValue: 1, label: 'Pix', onChanged: (_) {}),
    );
    expect(
      tester.getSemantics(find.byType(AppRadio<int>)),
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
