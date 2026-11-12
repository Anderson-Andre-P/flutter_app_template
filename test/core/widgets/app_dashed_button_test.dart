import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_dashed_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the plus icon and calls onPressed', (
    tester,
    dark,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppDashedButton(label: 'Adicionar item', onPressed: () => taps++),
      dark: dark,
    );
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.text('Adicionar item'));
    expect(taps, 1);
  });

  testWidgets('has the medium button height', (tester) async {
    await pumpApp(
      tester,
      AppDashedButton(label: 'Adicionar item', onPressed: () {}),
    );
    expect(
      tester.getSize(find.byType(AppDashedButton)).height,
      AppSizes.buttonMd,
    );
  });
}
