import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_select.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

const _priorities = [
  AppSelectOption(value: 0, label: 'Baixa'),
  AppSelectOption(value: 1, label: 'Média'),
  AppSelectOption(value: 2, label: 'Alta'),
];

Future<void> _pump(
  WidgetTester tester, {
  int? value,
  ValueChanged<int>? onChanged,
  List<AppSelectOption<int>> options = _priorities,
  String? errorText,
  bool dark = false,
}) => pumpApp(
  tester,
  Padding(
    padding: EdgeInsets.all(AppSpacing.lg),
    child: AppSelect<int>(
      label: 'Prioridade',
      options: options,
      value: value,
      errorText: errorText,
      onChanged: onChanged ?? (_) {},
    ),
  ),
  dark: dark,
);

void main() {
  testBothThemes('shows the hint until a value is chosen', (
    tester,
    dark,
  ) async {
    await _pump(tester, dark: dark);
    expect(find.text('Prioridade'), findsOneWidget);
    expect(find.text(CommonStrings.selectHint), findsOneWidget);
  });

  testBothThemes('opens a list below the field and picks an option', (
    tester,
    dark,
  ) async {
    int? chosen;
    await _pump(tester, value: 1, onChanged: (v) => chosen = v, dark: dark);
    await tester.tap(find.byType(AppSelect<int>));
    await tester.pumpAndSettle();
    final field = tester.getRect(find.byKey(AppSelect.fieldKey));
    final list = tester.getRect(find.text('Baixa'));
    expect(list.top, greaterThanOrEqualTo(field.bottom));
    expect(find.byKey(AppSelect.selectedMarkKey), findsOneWidget);
    await tester.tap(find.text('Alta'));
    await tester.pumpAndSettle();
    expect(chosen, 2);
  });

  testWidgets('the error shows below the field', (tester) async {
    await _pump(tester, errorText: 'Escolha uma prioridade');
    expect(find.text('Escolha uma prioridade'), findsOneWidget);
  });

  testWidgets('more than seven options open a searchable list', (tester) async {
    int? chosen;
    await _pump(
      tester,
      options: [
        for (final (i, city) in const [
          'Belém',
          'Brasília',
          'Curitiba',
          'Florianópolis',
          'Goiânia',
          'Manaus',
          'Recife',
          'São Paulo',
        ].indexed)
          AppSelectOption(value: i, label: city),
      ],
      onChanged: (v) => chosen = v,
    );
    await tester.tap(find.byType(AppSelect<int>));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'sao');
    await tester.pumpAndSettle();
    expect(find.text('Recife'), findsNothing);
    await tester.tap(find.text('São Paulo'));
    await tester.pumpAndSettle();
    expect(chosen, 7);
  });
}
