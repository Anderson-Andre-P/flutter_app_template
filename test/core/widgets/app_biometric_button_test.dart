import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/widgets/app_biometric_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the icon above the label and taps', (
    tester,
    dark,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppBiometricButton(
        icon: Icons.fingerprint,
        label: 'Touch ID',
        onPressed: () => taps++,
      ),
      dark: dark,
    );
    expect(
      tester.getCenter(find.byIcon(Icons.fingerprint)).dy,
      lessThan(tester.getCenter(find.text('Touch ID')).dy),
    );
    await tester.tap(find.text('Touch ID'));
    expect(taps, 1);
  });
}
