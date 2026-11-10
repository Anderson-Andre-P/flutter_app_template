import 'package:flutter/material.dart';
import 'package:flutter_app_template/app/app.dart';
import 'package:flutter_app_template/app/navigation/app_router.dart';
import 'package:flutter_app_template/core/config/env_config.dart';
import 'package:flutter_app_template/core/constants/keys/storage_keys.dart';
import 'package:flutter_app_template/core/di/injection_container.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_app_template/core/widgets/app_bottom_nav.dart';
import 'package:flutter_app_template/features/examples/presentation/examples_strings.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/activity_detail_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/activity_list_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/dashboard_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/feedback_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/transfer_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/transfer_success_page.dart';
import 'package:flutter_app_template/features/home/presentation/home_demo.dart';
import 'package:flutter_app_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/memory_secure_storage.dart';

Future<void> _start(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  PackageInfo.setMockInitialValues(
    appName: 'App Template',
    packageName: 'com.example.app_template',
    version: '0.1.0',
    buildNumber: '1',
    buildSignature: '',
  );
  await sl.reset();
  final storage = MemorySecureStorage()
    ..data[StorageKeys.authUser] =
        '{"id":"1","name":"Ana Souza","email":"ana@ex.com"}';
  await setupDependencies(
    const EnvConfig(apiBaseUrl: 'https://api.test', sentryDsn: ''),
    secureStorage: storage,
  );
  final router = AppRouter.create(sl<SessionBloc>());
  sl<SessionBloc>().add(const SessionChecked());
  await tester.pumpWidget(App(router: router));
  await tester.pumpAndSettle();
}

/// Pumps a fixed time instead of settling: the feedback demo shows a
/// loading view whose spinner never stops.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _open(WidgetTester tester, HomeDemo demo) async {
  await tester.scrollUntilVisible(find.text(demo.title), 100);
  await tester.tap(find.text(demo.title));
  await _settle(tester);
}

void main() {
  tearDown(() => sl.reset());

  testWidgets('every demo card opens its screen', (tester) async {
    await _start(tester);
    final screens = {
      HomeDemo.dashboard: DashboardPage,
      HomeDemo.statement: ActivityListPage,
      HomeDemo.detail: ActivityDetailPage,
      HomeDemo.form: TransferPage,
      HomeDemo.success: TransferSuccessPage,
      HomeDemo.feedback: FeedbackDemoPage,
    };
    for (final MapEntry(key: demo, value: page) in screens.entries) {
      await _open(tester, demo);
      expect(find.byType(page), findsOneWidget, reason: demo.name);
      final nav = tester.state<NavigatorState>(find.byType(Navigator).last);
      nav.pop();
      await _settle(tester);
      expect(find.byType(HomePage), findsOneWidget, reason: demo.name);
    }
  });

  testWidgets('statement: search narrows, an item opens its detail', (
    tester,
  ) async {
    await _start(tester);
    await _open(tester, HomeDemo.statement);
    expect(find.byType(AppBottomNav), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'cafe');
    await tester.pump();
    expect(find.text('Café Aurora'), findsOneWidget);
    expect(find.text('Mercado Bela'), findsNothing);
    await tester.tap(find.text('Café Aurora'));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityDetailPage), findsOneWidget);
    expect(find.text('– R\$ 18,50'), findsOneWidget);
  });

  testWidgets('form: a valid transfer lands on the receipt, then home', (
    tester,
  ) async {
    await _start(tester);
    await _open(tester, HomeDemo.form);
    await tester.tap(find.text('R\$ 200'));
    await tester.enterText(find.byType(TextField).first, 'Ana Souza');
    await tester.tap(find.text(ExamplesStrings.transferContinue));
    await tester.pumpAndSettle();
    expect(find.byType(TransferSuccessPage), findsOneWidget);
    expect(find.byType(AppBottomNav), findsNothing);
    expect(find.text('R\$ 200,00 para Ana Souza'), findsOneWidget);
    await tester.tap(find.text(ExamplesStrings.backHome));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });
}
