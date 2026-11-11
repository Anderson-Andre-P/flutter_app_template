import 'package:flutter/material.dart';
import 'package:flutter_app_template/app/app.dart';
import 'package:flutter_app_template/app/navigation/app_router.dart';
import 'package:flutter_app_template/core/config/env_config.dart';
import 'package:flutter_app_template/core/constants/keys/storage_keys.dart';
import 'package:flutter_app_template/core/di/injection_container.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_app_template/core/widgets/app_button.dart';
import 'package:flutter_app_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_app_template/features/home/presentation/home_strings.dart';
import 'package:flutter_app_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_app_template/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_app_template/features/settings/presentation/settings_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/memory_secure_storage.dart';
import '../../helpers/phone_screen.dart';

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
  usePhoneScreen(tester);
  await tester.pumpWidget(App(router: router));
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.text(HomeStrings.tabSettings));
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() => sl.reset());

  testWidgets('home greets the signed-in user', (tester) async {
    await _startSignedIn(tester);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Olá, Ana'), findsOneWidget);
  });

  testWidgets('settings shows the user and the app version', (tester) async {
    await _startSignedIn(tester);
    await _openSettings(tester);
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text('Ana Souza'), findsOneWidget);
    expect(find.text('ana@ex.com'), findsOneWidget);
    expect(find.text('AS'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Versão 0.1.0 (1)'), 200);
    expect(find.text('Versão 0.1.0 (1)'), findsOneWidget);
  });

  testWidgets('choosing Escuro switches the theme at runtime', (tester) async {
    await _startSignedIn(tester);
    await _openSettings(tester);
    await tester.tap(find.text(SettingsStrings.themeDark));
    await tester.pumpAndSettle();
    final ctx = tester.element(find.byType(SettingsPage));
    expect(Theme.of(ctx).brightness, Brightness.dark);
    expect(
      (await SharedPreferences.getInstance()).getString(StorageKeys.themeMode),
      'dark',
    );
    await tester.tap(find.text(SettingsStrings.themeLight));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(SettingsPage))).brightness,
      Brightness.light,
    );
  });

  testWidgets('the settings tab is named Configurações with a gear', (
    tester,
  ) async {
    await _startSignedIn(tester);
    expect(find.text('Configurações'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    await _openSettings(tester);
    expect(find.text('Configurações'), findsNWidgets(2));
  });

  testWidgets('menu rows explain they are not available yet', (tester) async {
    await _startSignedIn(tester);
    await _openSettings(tester);
    await tester.tap(find.text(SettingsStrings.personalData));
    await tester.pump();
    expect(find.text(SettingsStrings.comingSoon), findsOneWidget);
  });

  testWidgets('the sign-out button has the large button height', (
    tester,
  ) async {
    await _startSignedIn(tester);
    await _openSettings(tester);
    await tester.scrollUntilVisible(find.text(SettingsStrings.signOut), 200);
    expect(
      tester
          .getSize(find.widgetWithText(AppButton, SettingsStrings.signOut))
          .height,
      AppSizes.buttonLg,
    );
  });

  testWidgets('Sair + confirm signs out to sign in', (tester) async {
    await _startSignedIn(tester);
    await _openSettings(tester);
    await tester.scrollUntilVisible(find.text(SettingsStrings.signOut), 200);
    await tester.tap(find.text(SettingsStrings.signOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text(SettingsStrings.signOutConfirm).last);
    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('Sair + cancel keeps the session', (tester) async {
    await _startSignedIn(tester);
    await _openSettings(tester);
    await tester.scrollUntilVisible(find.text(SettingsStrings.signOut), 200);
    await tester.tap(find.text(SettingsStrings.signOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(sl<SessionBloc>().state.status, SessionStatus.authenticated);
  });
}
