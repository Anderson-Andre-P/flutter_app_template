import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/widgets/app_button.dart';
import 'package:flutter_app_template/core/widgets/app_button_group.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

Rect _rect(WidgetTester tester, String label) =>
    tester.getRect(find.widgetWithText(AppButton, label));

void main() {
  testBothThemes('pair: secondary on the left, both the same width', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      AppButtonGroup.pair(
        secondary: AppButton(
          label: 'Descartar',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        primary: AppButton(label: 'Salvar', onPressed: () {}),
      ),
      dark: dark,
    );
    final discard = _rect(tester, 'Descartar');
    final save = _rect(tester, 'Salvar');
    expect(discard.left, lessThan(save.left));
    expect(discard.width, save.width);
  });

  testWidgets('triple: the primary is the widest, on the right', (
    tester,
  ) async {
    await pumpApp(
      tester,
      AppButtonGroup.triple(
        first: AppButton(
          label: 'Voltar',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        second: AppButton(
          label: 'Pular',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
        primary: AppButton(label: 'Continuar', onPressed: () {}),
      ),
    );
    final back = _rect(tester, 'Voltar');
    final skip = _rect(tester, 'Pular');
    final next = _rect(tester, 'Continuar');
    expect(back.width, skip.width);
    expect(next.width, greaterThan(skip.width));
    expect(next.left, greaterThan(skip.left));
  });

  testWidgets('stacked: the main action on top, full width', (tester) async {
    await pumpApp(
      tester,
      AppButtonGroup.stacked(
        primary: AppButton(
          label: 'Excluir',
          variant: AppButtonVariant.destructive,
          onPressed: () {},
        ),
        secondary: AppButton(
          label: 'Manter',
          variant: AppButtonVariant.secondary,
          onPressed: () {},
        ),
      ),
    );
    final delete = _rect(tester, 'Excluir');
    final keep = _rect(tester, 'Manter');
    expect(delete.bottom, lessThanOrEqualTo(keep.top));
    expect(delete.width, keep.width);
  });
}
