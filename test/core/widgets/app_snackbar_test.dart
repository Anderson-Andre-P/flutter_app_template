import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/widgets/app_snackbar.dart';
import 'package:flutter_test/flutter_test.dart';

Future<BuildContext> _host(WidgetTester tester, {bool dark = false}) async {
  late BuildContext ctx;
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.dark() : AppTheme.light(),
      home: Scaffold(
        body: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  return ctx;
}

void main() {
  testWidgets('success shows the message', (tester) async {
    final ctx = await _host(tester);
    AppSnackbar.success(ctx, 'Salvo');
    await tester.pump();
    expect(find.text('Salvo'), findsOneWidget);
  });

  testWidgets('an action that shows another snackbar keeps it visible', (
    tester,
  ) async {
    final ctx = await _host(tester);
    AppSnackbar.info(
      ctx,
      'Arquivado',
      actionLabel: 'Desfazer',
      onAction: () => AppSnackbar.success(ctx, 'Desfeito'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desfazer'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Desfeito'), findsOneWidget);
    expect(find.text('Arquivado'), findsNothing);
  });

  testWidgets('a new snackbar replaces the current one', (tester) async {
    final ctx = await _host(tester, dark: true);
    AppSnackbar.success(ctx, 'Salvo');
    await tester.pump();
    AppSnackbar.error(ctx, 'Falhou');
    await tester.pumpAndSettle();
    expect(find.text('Salvo'), findsNothing);
    expect(find.text('Falhou'), findsOneWidget);
  });

  testWidgets('error without an action offers Fechar', (tester) async {
    final ctx = await _host(tester);
    AppSnackbar.error(ctx, 'Falhou');
    await tester.pump();
    expect(find.text('Fechar'), findsOneWidget);
  });

  testWidgets('a custom action is called', (tester) async {
    var undone = 0;
    final ctx = await _host(tester);
    AppSnackbar.info(
      ctx,
      'Arquivado',
      actionLabel: 'Desfazer',
      onAction: () => undone++,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desfazer'));
    expect(undone, 1);
  });

  testWidgets('warning renders', (tester) async {
    final ctx = await _host(tester);
    AppSnackbar.warning(ctx, 'Atenção');
    await tester.pump();
    expect(find.text('Atenção'), findsOneWidget);
  });
}
