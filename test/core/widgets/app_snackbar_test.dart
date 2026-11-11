import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_snackbar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

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

/// Lets the entry animation finish without settling (a toast's timer is
/// not a frame, so this never waits for it).
Future<void> _shown(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(AppDurations.toast);
}

void main() {
  testBothThemes('shows the title and the description', (tester, dark) async {
    final ctx = await _host(tester, dark: dark);
    AppSnackbar.success(ctx, 'Salvo', description: 'Enviado ao gestor.');
    await _shown(tester);
    expect(find.text('Salvo'), findsOneWidget);
    expect(find.text('Enviado ao gestor.'), findsOneWidget);
    await tester.pump(AppDurations.toastVisible);
  });

  testWidgets('shows at the top, below the top bar', (tester) async {
    final ctx = await _host(tester);
    AppSnackbar.info(ctx, 'Nova versão');
    await _shown(tester);
    final top = tester.getTopLeft(find.text('Nova versão')).dy;
    expect(top, greaterThan(kToolbarHeight));
    expect(top, lessThan(tester.view.physicalSize.height / 4));
    await tester.pump(AppDurations.toastVisible);
  });

  testWidgets('leaves after the visible duration', (tester) async {
    final ctx = await _host(tester);
    AppSnackbar.warning(ctx, 'Atenção');
    await _shown(tester);
    await tester.pump(AppDurations.toastVisible);
    await tester.pump();
    expect(find.text('Atenção'), findsNothing);
  });

  testWidgets('an error stays until it is dismissed with Fechar', (
    tester,
  ) async {
    final ctx = await _host(tester);
    AppSnackbar.error(ctx, 'Falhou');
    await _shown(tester);
    await tester.pump(AppDurations.toastVisible * 3);
    expect(find.text('Falhou'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pump();
    expect(find.text('Falhou'), findsNothing);
  });

  testWidgets('the newest is on top and at most two are visible', (
    tester,
  ) async {
    final ctx = await _host(tester);
    AppSnackbar.info(ctx, 'Primeiro');
    AppSnackbar.info(ctx, 'Segundo');
    await _shown(tester);
    expect(
      tester.getTopLeft(find.text('Segundo')).dy,
      lessThan(tester.getTopLeft(find.text('Primeiro')).dy),
    );
    AppSnackbar.info(ctx, 'Terceiro');
    await _shown(tester);
    expect(find.text('Primeiro'), findsNothing);
    expect(find.text('Segundo'), findsOneWidget);
    expect(find.text('Terceiro'), findsOneWidget);
    await tester.pump(AppDurations.toastVisible);
  });

  testWidgets('the action is called and dismisses the toast', (tester) async {
    var undone = 0;
    final ctx = await _host(tester);
    AppSnackbar.info(
      ctx,
      'Arquivado',
      actionLabel: 'Desfazer',
      onAction: () => undone++,
    );
    await _shown(tester);
    await tester.tap(find.text('Desfazer'));
    await tester.pump();
    expect(undone, 1);
    expect(find.text('Arquivado'), findsNothing);
  });

  testWidgets('an action that shows another toast keeps it visible', (
    tester,
  ) async {
    final ctx = await _host(tester);
    AppSnackbar.info(
      ctx,
      'Arquivado',
      actionLabel: 'Desfazer',
      onAction: () => AppSnackbar.success(ctx, 'Desfeito'),
    );
    await _shown(tester);
    await tester.tap(find.text('Desfazer'));
    await _shown(tester);
    expect(find.text('Desfeito'), findsOneWidget);
    expect(find.text('Arquivado'), findsNothing);
    await tester.pump(AppDurations.toastVisible);
  });

  testWidgets('a swipe dismisses it', (tester) async {
    final ctx = await _host(tester);
    AppSnackbar.error(ctx, 'Falhou', actionLabel: 'Tentar');
    await _shown(tester);
    await tester.drag(find.text('Falhou'), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Falhou'), findsNothing);
  });

  testWidgets('the action has a 44px touch target', (tester) async {
    final ctx = await _host(tester);
    AppSnackbar.error(ctx, 'Falhou');
    await _shown(tester);
    final target = tester.getSize(
      find.ancestor(of: find.text('Fechar'), matching: find.byType(InkWell)),
    );
    expect(target.height, greaterThanOrEqualTo(AppSizes.minTouchTarget));
    expect(target.width, greaterThanOrEqualTo(AppSizes.minTouchTarget));
  });

  testWidgets('is announced as a live region', (tester) async {
    final handle = tester.ensureSemantics();
    final ctx = await _host(tester);
    AppSnackbar.success(ctx, 'Salvo');
    await _shown(tester);
    expect(
      tester.getSemantics(find.text('Salvo')),
      isSemantics(isLiveRegion: true),
    );
    handle.dispose();
    await tester.pump(AppDurations.toastVisible);
  });
}
