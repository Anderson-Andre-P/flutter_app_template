import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_avatar.dart';
import 'package:flutter_app_template/core/widgets/app_badge.dart';
import 'package:flutter_app_template/core/widgets/app_bottom_nav.dart';
import 'package:flutter_app_template/core/widgets/app_card.dart';
import 'package:flutter_app_template/core/widgets/app_chip.dart';
import 'package:flutter_app_template/core/widgets/app_list_tile.dart';
import 'package:flutter_app_template/core/widgets/app_state_views.dart';
import 'package:flutter_app_template/core/widgets/app_top_bar.dart';
import 'package:flutter_app_template/core/widgets/section_overline.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testBothThemes('badge renders its label for every tone', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      Column(
        children: [
          for (final t in AppTone.values) AppBadge(label: t.name, tone: t),
        ],
      ),
      dark: dark,
    );
    for (final t in AppTone.values) {
      expect(find.text(t.name), findsOneWidget);
    }
  });

  testBothThemes('card is tappable when onTap is set', (tester, dark) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppCard(onTap: () => taps++, child: const Text('c')),
      dark: dark,
    );
    await tester.tap(find.text('c'));
    expect(taps, 1);
  });

  testWidgets('chip reports the toggled selection', (tester) async {
    bool? selected;
    await pumpApp(
      tester,
      AppChip(label: 'Todos', onSelected: (v) => selected = v),
    );
    await tester.tap(find.text('Todos'));
    expect(selected, isTrue);
  });

  testWidgets('chips hug their label and sit side by side', (tester) async {
    await pumpApp(
      tester,
      Wrap(
        spacing: AppSpacing.sm,
        children: [
          AppChip(label: 'Sistema', onSelected: (_) {}),
          AppChip(label: 'Claro', onSelected: (_) {}),
        ],
      ),
    );
    final a = tester.getRect(find.widgetWithText(AppChip, 'Sistema'));
    final b = tester.getRect(find.widgetWithText(AppChip, 'Claro'));
    expect(a.width, lessThan(200));
    expect(a.height, AppSizes.chip);
    expect(b.top, a.top);
    expect(b.left - a.right, AppSpacing.sm);
  });

  testBothThemes('avatar shows initials', (tester, dark) async {
    await pumpApp(tester, const AppAvatar(initials: 'AE'), dark: dark);
    expect(find.text('AE'), findsOneWidget);
  });

  testWidgets('list tile shows title, subtitle and handles taps', (
    tester,
  ) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppListTile(title: 'T', subtitle: 'S', onTap: () => taps++),
    );
    await tester.tap(find.text('T'));
    expect(find.text('S'), findsOneWidget);
    expect(taps, 1);
  });

  testBothThemes('bottom nav reports the tapped index', (tester, dark) async {
    int? tapped;
    await pumpApp(
      tester,
      AppBottomNav(
        items: const [
          AppBottomNavItem(icon: Icons.home_outlined, label: 'Início'),
          AppBottomNavItem(icon: Icons.person_outline, label: 'Perfil'),
        ],
        currentIndex: 0,
        onTap: (i) => tapped = i,
      ),
      dark: dark,
    );
    await tester.tap(find.text('Perfil'));
    expect(tapped, 1);
  });

  testWidgets('bottom nav content is the nav height plus the safe area', (
    tester,
  ) async {
    tester.view.padding = const FakeViewPadding(bottom: 34 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          bottomNavigationBar: AppBottomNav(
            items: const [
              AppBottomNavItem(icon: Icons.home_outlined, label: 'Início'),
              AppBottomNavItem(icon: Icons.person_outline, label: 'Perfil'),
            ],
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(AppBottomNav)).height,
      AppSizes.bottomNav + 34,
    );
    expect(AppSizes.bottomNav, 56);
  });

  testWidgets('top bar shows its title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(appBar: AppTopBar(title: 'Início')),
      ),
    );
    expect(find.text('Início'), findsOneWidget);
  });

  testWidgets('section overline is upper-cased', (tester) async {
    await pumpApp(tester, const SectionOverline('Resumo'));
    expect(find.text('RESUMO'), findsOneWidget);
  });

  testBothThemes('empty view without action renders no button', (
    tester,
    dark,
  ) async {
    await pumpApp(
      tester,
      const AppEmptyView(
        icon: Icons.inbox_outlined,
        title: 'Vazio',
        message: 'Nada',
      ),
      dark: dark,
    );
    expect(find.text('Vazio'), findsOneWidget);
    expect(find.byType(ButtonStyleButton), findsNothing);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('empty view action is tappable', (tester) async {
    var taps = 0;
    await pumpApp(
      tester,
      AppEmptyView(
        icon: Icons.inbox_outlined,
        title: 'Vazio',
        message: 'Nada',
        actionLabel: 'Criar',
        onAction: () => taps++,
      ),
    );
    await tester.tap(find.text('Criar'));
    expect(taps, 1);
  });

  testWidgets('error view retries', (tester) async {
    var retries = 0;
    await pumpApp(
      tester,
      AppErrorView(
        title: 'Erro',
        message: 'm',
        retryLabel: 'Tentar novamente',
        onRetry: () => retries++,
      ),
    );
    await tester.tap(find.text('Tentar novamente'));
    expect(retries, 1);
  });

  testWidgets('loading view shows a progress indicator', (tester) async {
    await pumpApp(tester, const AppLoadingView());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
