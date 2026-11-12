import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_tag_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('shows the tags, adds on Enter and removes with ×', (
    tester,
    dark,
  ) async {
    final added = <String>[];
    final removed = <int>[];
    await pumpApp(
      tester,
      AppTagField(
        label: 'Destinatários',
        tags: const ['Marina Alves'],
        onAdded: added.add,
        onRemoved: removed.add,
      ),
      dark: dark,
    );
    expect(find.text('Marina Alves'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '  Rafael Souza ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(added, ['Rafael Souza']);
    await tester.tap(
      find.bySemanticsLabel(CommonStrings.remove('Marina Alves')),
    );
    expect(removed, [0]);
  });

  testWidgets('blank text is not added', (tester) async {
    final added = <String>[];
    await pumpApp(
      tester,
      AppTagField(
        label: 'Destinatários',
        tags: const [],
        onAdded: added.add,
        onRemoved: (_) {},
      ),
    );
    await tester.enterText(find.byType(TextField), '   ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(added, isEmpty);
  });
}
