import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/widgets/app_button.dart';
import 'package:flutter_app_template/core/widgets/dialogs/app_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

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
  Future<bool> openConfirm(
    BuildContext ctx, {
    bool destructive = false,
    IconData? icon,
  }) => AppDialog.confirm(
    ctx,
    title: 'Sair da conta?',
    message: 'Você vai precisar entrar de novo.',
    confirmLabel: 'Sair',
    destructive: destructive,
    icon: icon,
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

  testBothThemes('destructive: icon on top, full-width action above Cancelar', (
    tester,
    dark,
  ) async {
    final ctx = await _host(tester, dark: dark);
    unawaited(openConfirm(ctx, destructive: true, icon: Icons.logout));
    await tester.pumpAndSettle();
    final icon = tester.getRect(find.byIcon(Icons.logout));
    final title = tester.getRect(find.text('Sair da conta?'));
    final confirm = tester.getRect(find.widgetWithText(AppButton, 'Sair'));
    final cancel = tester.getRect(find.widgetWithText(AppButton, 'Cancelar'));
    expect(icon.bottom, lessThanOrEqualTo(title.top));
    expect(confirm.bottom, lessThanOrEqualTo(cancel.top));
    expect(confirm.width, cancel.width);
    expect(confirm.left, cancel.left);
  });

  testWidgets('destructive without an icon shows a warning icon', (
    tester,
  ) async {
    final ctx = await _host(tester);
    unawaited(openConfirm(ctx, destructive: true));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('a plain confirm has no icon unless one is given', (
    tester,
  ) async {
    final ctx = await _host(tester);
    unawaited(openConfirm(ctx));
    await tester.pumpAndSettle();
    expect(find.byType(Icon), findsNothing);
  });

  testBothThemes('modal: icon beside the title and a close button', (
    tester,
    dark,
  ) async {
    final ctx = await _host(tester, dark: dark);
    final result = AppDialog.modal(
      ctx,
      icon: Icons.task_alt,
      title: 'Aplicar modelo?',
      message: 'O conteúdo atual será substituído.',
      confirmLabel: 'Aplicar',
    );
    await tester.pumpAndSettle();
    final icon = tester.getRect(find.byIcon(Icons.task_alt));
    final title = tester.getRect(find.text('Aplicar modelo?'));
    expect(icon.right, lessThanOrEqualTo(title.left));
    await tester.tap(find.bySemanticsLabel(CommonStrings.close));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
  });

  testWidgets('modal resolves true on the confirm button', (tester) async {
    final ctx = await _host(tester);
    final result = AppDialog.modal(
      ctx,
      icon: Icons.task_alt,
      title: 'Aplicar modelo?',
      message: 'O conteúdo atual será substituído.',
      confirmLabel: 'Aplicar',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aplicar'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });
}
