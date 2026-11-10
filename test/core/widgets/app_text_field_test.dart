import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/widgets/app_text_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the label above and the error below', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      const AppTextField(
        label: 'E-mail',
        errorText: 'Informe um e-mail válido',
      ),
      dark: dark,
    );
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Informe um e-mail válido'), findsOneWidget);
  });

  testWidgets('required adds an asterisk to the label', (tester) async {
    await pumpApp(tester, const AppTextField(label: 'Nome', required: true));
    expect(find.text('Nome *'), findsOneWidget);
  });

  testWidgets('obscure toggles visibility with the eye button', (tester) async {
    await pumpApp(tester, const AppTextField(label: 'Senha', obscure: true));
    EditableText field() =>
        tester.widget<EditableText>(find.byType(EditableText));
    expect(field().obscureText, isTrue);
    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pump();
    expect(field().obscureText, isFalse);
    expect(find.byTooltip('Ocultar senha'), findsOneWidget);
  });

  testWidgets('onChanged receives typed text', (tester) async {
    String? value;
    await pumpApp(
      tester,
      AppTextField(label: 'E-mail', onChanged: (v) => value = v),
    );
    await tester.enterText(find.byType(TextField), 'a@b.co');
    expect(value, 'a@b.co');
  });
}
