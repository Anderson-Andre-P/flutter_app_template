import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_social_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the mark, the label and a chevron', (
    tester,
    dark,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppSocialButton(
        mark: 'G',
        label: 'Continuar com Google',
        onPressed: () => taps++,
      ),
      dark: dark,
    );
    expect(find.text('G'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(
      tester.getSize(find.byType(AppSocialButton)).height,
      AppSizes.socialButton,
    );
    await tester.tap(find.text('Continuar com Google'));
    expect(taps, 1);
  });
}
