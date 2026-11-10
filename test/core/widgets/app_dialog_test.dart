import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/widgets/dialogs/app_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

Future<BuildContext> _host(WidgetTester tester, {bool dark = false}) async {
  late BuildContext ctx;
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.dark() : AppTheme.light(),
      home: Builder(
        builder: (c) {
          ctx = c;
          return const Scaffold();
        },
      ),
    ),
  );
  return ctx;
}

void main() {
  Future<bool> openConfirm(BuildContext ctx, {bool destructive = false}) =>
      AppDialog.confirm(
        ctx,
        title: 'Sair da conta?',
        message: 'Você vai precisar entrar de novo.',
        confirmLabel: 'Sair',
        destructive: destructive,
      );

  testWidgets('confirm returns true on the confirm button', (tester) async {
    final ctx = await _host(tester);
    final result = openConfirm(ctx);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });

  testWidgets('confirm returns false on cancel', (tester) async {
    final ctx = await _host(tester, dark: true);
    final result = openConfirm(ctx, destructive: true);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
  });

  testWidgets('confirm returns false when dismissed outside', (tester) async {
    final ctx = await _host(tester);
    final result = openConfirm(ctx);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
  });

  testWidgets('alert closes with its button', (tester) async {
    final ctx = await _host(tester);
    final done = AppDialog.alert(ctx, title: 'Aviso', message: 'Mensagem');
    await tester.pumpAndSettle();
    expect(find.text('Mensagem'), findsOneWidget);
    await tester.tap(find.text('Entendi'));
    await tester.pumpAndSettle();
    await done;
    expect(find.text('Mensagem'), findsNothing);
  });
}
