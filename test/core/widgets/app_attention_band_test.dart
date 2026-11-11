import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_attention_band.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the icon, the title and the message', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      const AppAttentionBand(
        title: 'Ação necessária',
        message: 'Confirme o endereço de entrega.',
      ),
      dark: dark,
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('AÇÃO NECESSÁRIA')).style!.color,
      c.danger,
    );
    expect(find.text('Confirme o endereço de entrega.'), findsOneWidget);
  });

  testWidgets('an alert band uses the readable alert text colour', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppAttentionBand(
        title: 'Atenção',
        message: 'Revise antes de enviar.',
        tone: AppTone.alert,
      ),
    );
    expect(
      tester.widget<Text>(find.text('ATENÇÃO')).style!.color,
      AppColors.light.alertText,
    );
  });
}
