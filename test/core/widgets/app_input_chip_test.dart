import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_input_chip.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('the × removes the chip', (tester, dark) async {
    var removed = 0;
    await pumpApp(
      tester,
      AppInputChip(label: 'Bomba 02', onRemoved: () => removed++),
      dark: dark,
    );
    expect(find.text('Bomba 02'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(CommonStrings.remove('Bomba 02')));
    expect(removed, 1);
  });

  testWidgets('the remove button has a 44px target', (tester) async {
    await pumpApp(tester, AppInputChip(label: 'Bomba 02', onRemoved: () {}));
    expect(
      tester.getSize(find.byIcon(Icons.close).hitTestable()).width,
      lessThan(44),
    );
    final target = tester.getSize(
      find.ancestor(
        of: find.byIcon(Icons.close),
        matching: find.byType(InkWell),
      ),
    );
    expect(target.height, greaterThanOrEqualTo(32));
    expect(target.width, greaterThanOrEqualTo(32));
  });
}
