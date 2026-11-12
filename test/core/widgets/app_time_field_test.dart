import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_time_field.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('typing HHMM shows HH:MM and reports it', (
    tester,
    dark,
  ) async {
    ({int hour, int minute})? reported;
    await pumpApp(
      tester,
      AppTimeField(label: 'Hora', onChanged: (t) => reported = t),
      dark: dark,
    );
    await tester.enterText(find.byType(TextField), '1430');
    expect(find.text('14:30'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(reported, (hour: 14, minute: 30));
  });

  testWidgets('the clock button lists times in steps', (tester) async {
    ({int hour, int minute})? reported;
    await pumpApp(
      tester,
      AppTimeField(
        label: 'Hora',
        value: (hour: 14, minute: 0),
        onChanged: (t) => reported = t,
      ),
    );
    await tester.tap(find.bySemanticsLabel(CommonStrings.chooseTime));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('15:30'),
      100,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.text('15:30'));
    await tester.pumpAndSettle();
    expect(reported, (hour: 15, minute: 30));
  });
}
