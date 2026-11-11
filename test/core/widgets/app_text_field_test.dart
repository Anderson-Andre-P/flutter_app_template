import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
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

  testBothThemes('read-only shows the read-only seal on the tinted fill', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      const AppTextField(label: 'Código', readOnly: true),
      dark: dark,
    );
    expect(find.text(CommonStrings.readOnlySeal), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration!.fillColor, c.primarySubtle);
  });

  testWidgets('initialValue fills the field without a controller', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppTextField(label: 'Código', initialValue: 'PED-1042'),
    );
    expect(find.text('PED-1042'), findsOneWidget);
  });

  testBothThemes('a multi-line field with maxLength counts characters', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      const AppTextField(label: 'Descrição', minLines: 3, maxLength: 400),
      dark: dark,
    );
    expect(find.text(CommonStrings.counter(0, 400)), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Olá');
    await tester.pump();
    expect(find.text(CommonStrings.counter(3, 400)), findsOneWidget);
  });

  testBothThemes('a prefix sits in its own box before the text', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      const AppTextField(label: 'Código', prefix: 'ID-', initialValue: '2026'),
      dark: dark,
    );
    expect(
      tester.getCenter(find.text('ID-')).dx,
      lessThan(tester.getCenter(find.text('2026')).dx),
    );
  });

  testBothThemes('validated shows a green check', (tester, dark) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      const AppTextField(label: 'CPF', validated: true),
      dark: dark,
    );
    expect(tester.widget<Icon>(find.byIcon(Icons.check)).color, c.success);
  });

  testWidgets('disabled shows a lock', (tester) async {
    await pumpApp(tester, const AppTextField(label: 'Código', enabled: false));
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });
}
