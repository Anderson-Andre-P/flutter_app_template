import 'package:flutter/material.dart';
import 'package:flutter_app_template/app/app.dart';
import 'package:flutter_app_template/app/navigation/app_router.dart';
import 'package:flutter_app_template/core/config/env_config.dart';
import 'package:flutter_app_template/core/constants/keys/storage_keys.dart';
import 'package:flutter_app_template/core/di/injection_container.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_app_template/core/widgets/app_chip.dart';
import 'package:flutter_app_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_app_template/features/home/presentation/home_strings.dart';
import 'package:flutter_app_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_app_template/features/settings/presentation/pages/profile_page.dart';
import 'package:flutter_app_template/features/settings/presentation/settings_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/memory_secure_storage.dart';

Future<void> _startSignedIn(WidgetTester tester) async {
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

Future<void> _openProfile(WidgetTester tester) async {
  await tester.tap(find.text(HomeStrings.tabProfile));
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() => sl.reset());

  testWidgets('home greets the signed-in user', (tester) async {
    await _startSignedIn(tester);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Olá, Ana'), findsOneWidget);
  });

  testWidgets('tapping a filter chip selects it', (tester) async {
    await _startSignedIn(tester);
    AppChip chip(String label) =>
        tester.widget<AppChip>(find.widgetWithText(AppChip, label));
    expect(chip(HomeStrings.filters[0]).selected, isTrue);
    await tester.tap(find.text(HomeStrings.filters[1]));
    await tester.pump();
    expect(chip(HomeStrings.filters[1]).selected, isTrue);
    expect(chip(HomeStrings.filters[0]).selected, isFalse);
  });

  testWidgets('profile shows the user and the app version', (tester) async {
    await _startSignedIn(tester);
    await _openProfile(tester);
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Ana Souza'), findsOneWidget);
    expect(find.text('ana@ex.com'), findsOneWidget);
    expect(find.text('AS'), findsOneWidget);
    expect(find.text('Versão 0.1.0 (1)'), findsOneWidget);
  });

  testWidgets('choosing Escuro switches the theme at runtime', (tester) async {
    await _startSignedIn(tester);
    await _openProfile(tester);
    await tester.tap(find.text(SettingsStrings.themeDark));
    await tester.pumpAndSettle();
    final ctx = tester.element(find.byType(ProfilePage));
    expect(Theme.of(ctx).brightness, Brightness.dark);
    expect(
      (await SharedPreferences.getInstance()).getString(StorageKeys.themeMode),
      'dark',
    );
    await tester.tap(find.text(SettingsStrings.themeLight));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(ProfilePage))).brightness,
      Brightness.light,
    );
  });

  testWidgets('Sair + confirm signs out to sign in', (tester) async {
    await _startSignedIn(tester);
    await _openProfile(tester);
    await tester.ensureVisible(find.text(SettingsStrings.signOut));
    await tester.tap(find.text(SettingsStrings.signOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text(SettingsStrings.signOutConfirm).last);
    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('Sair + cancel keeps the session', (tester) async {
    await _startSignedIn(tester);
    await _openProfile(tester);
    await tester.ensureVisible(find.text(SettingsStrings.signOut));
    await tester.tap(find.text(SettingsStrings.signOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(sl<SessionBloc>().state.status, SessionStatus.authenticated);
  });
}
