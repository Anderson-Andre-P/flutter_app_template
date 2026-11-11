import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/widgets/app_chat.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('own messages are on the right in primary, read ticked', (
    tester,
    dark,
  ) async {
    final c = dark ? AppColors.dark : AppColors.light;
    await pumpApp(
      tester,
      SizedBox(
        width: 360.w,
        child: const Column(
          children: [
            AppChatBubble(
              text: 'Consegue conferir?',
              time: '08:42',
              author: 'Ana Duarte',
              initials: 'AD',
            ),
            AppChatBubble(
              text: 'Confirmado.',
              time: '08:47',
              mine: true,
              read: true,
            ),
          ],
        ),
      ),
      dark: dark,
    );
    final mine = tester.getRect(find.text('Confirmado.'));
    final theirs = tester.getRect(find.text('Consegue conferir?'));
    expect(mine.right, greaterThan(theirs.right));
    expect(
      tester.widget<Text>(find.text('Confirmado.')).style!.color,
      c.onPrimary,
    );
    expect(find.text('Ana Duarte'), findsOneWidget);
    expect(find.byIcon(Icons.done_all), findsOneWidget);
  });

  testWidgets('a follow-up from the same person hides name and avatar', (
    tester,
  ) async {
    await pumpApp(
      tester,
      const AppChatBubble(
        text: 'Segue o anexo.',
        time: '09:31',
        author: 'Rafael Souza',
        initials: 'RS',
        firstInGroup: false,
      ),
    );
    expect(find.text('Rafael Souza'), findsNothing);
    expect(find.text('RS'), findsNothing);
  });

  testBothThemes('the composer sends trimmed text and clears', (
    tester,
    dark,
  ) async {
    final sent = <String>[];
    var attach = 0;
    await pumpApp(
      tester,
      AppMessageComposer(
        hint: 'Escrever comentário...',
        onSend: sent.add,
        onAttach: () => attach++,
      ),
      dark: dark,
    );
    await tester.tap(find.bySemanticsLabel(CommonStrings.send));
    expect(sent, isEmpty);
    await tester.enterText(find.byType(TextField), '  Perfeito ');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(CommonStrings.send));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(CommonStrings.attach));
    expect(sent, ['Perfeito']);
    expect(attach, 1);
    expect(find.text('  Perfeito '), findsNothing);
  });

  testWidgets('the day separator shows its label', (tester) async {
    await pumpApp(tester, const AppChatDay(label: 'Hoje'));
    expect(find.text('Hoje'), findsOneWidget);
  });
}
