import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/widgets/app_bottom_sheet.dart';
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
            return const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  return ctx;
}

void main() {
  for (final dark in [false, true]) {
    testWidgets('show renders title, message and content '
        '(${dark ? 'dark' : 'light'})', (tester) async {
      final ctx = await _host(tester, dark: dark);
      unawaited(
        AppBottomSheet.show<void>(
          ctx,
          title: 'Filtros',
          message: 'Escolha o período',
          child: const Text('conteúdo'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Filtros'), findsOneWidget);
      expect(find.text('Escolha o período'), findsOneWidget);
      expect(find.text('conteúdo'), findsOneWidget);
      expect(find.byKey(AppBottomSheet.handleKey), findsOneWidget);
    });
  }

  testWidgets('options returns the tapped value', (tester) async {
    final ctx = await _host(tester);
    final result = AppBottomSheet.options<int>(
      ctx,
      title: 'Ordenar',
      options: const [
        AppSheetOption(value: 1, label: 'Mais recentes', icon: Icons.schedule),
        AppSheetOption(value: 2, label: 'Maior valor', icon: Icons.sort),
      ],
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maior valor'));
    await tester.pumpAndSettle();
    expect(await result, 2);
    expect(find.text('Ordenar'), findsNothing);
  });

  testWidgets('dismissing returns null', (tester) async {
    final ctx = await _host(tester);
    final result = AppBottomSheet.options<int>(
      ctx,
      title: 'Ordenar',
      options: const [AppSheetOption(value: 1, label: 'A')],
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(await result, isNull);
  });

  testWidgets('a selected option is marked with a check', (tester) async {
    final ctx = await _host(tester);
    unawaited(
      AppBottomSheet.options<int>(
        ctx,
        title: 'Ordenar',
        selected: 2,
        options: const [
          AppSheetOption(value: 1, label: 'A'),
          AppSheetOption(value: 2, label: 'B'),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('a header action sits next to the title', (tester) async {
    var cleared = 0;
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (c) {
            ctx = c;
            return const Scaffold();
          },
        ),
      ),
    );
    unawaited(
      AppBottomSheet.show<void>(
        ctx,
        title: 'Filtros',
        actionLabel: 'Limpar',
        onAction: () => cleared++,
        child: const Text('Status'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(find.text('Limpar')).dy,
      closeTo(tester.getCenter(find.text('Filtros')).dy, 12),
    );
    await tester.tap(find.text('Limpar'));
    expect(cleared, 1);
  });
}
