import 'package:flutter/material.dart';
import 'package:flutter_app_template/app/app.dart';
import 'package:flutter_app_template/app/navigation/app_router.dart';
import 'package:flutter_app_template/core/config/env_config.dart';
import 'package:flutter_app_template/core/constants/keys/storage_keys.dart';
import 'package:flutter_app_template/core/di/injection_container.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_app_template/features/auth/presentation/auth_strings.dart';
import 'package:flutter_app_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_app_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/memory_secure_storage.dart';

const _config = EnvConfig(apiBaseUrl: 'https://api.test', sentryDsn: '');

Future<GoRouter> _start(
  WidgetTester tester,
  MemorySecureStorage storage,
) async {
  SharedPreferences.setMockInitialValues({});
  await sl.reset();
  await setupDependencies(_config, secureStorage: storage);
  final router = AppRouter.create(sl<SessionBloc>());
  sl<SessionBloc>().add(const SessionChecked());
  await tester.pumpWidget(App(router: router));
  await tester.pumpAndSettle();
  return router;
}

void main() {
  tearDown(() => sl.reset());

  testWidgets('without a session the app opens on sign in', (tester) async {
    await _start(tester, MemorySecureStorage());
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('with a stored session the app opens on home', (tester) async {
    final storage = MemorySecureStorage()
      ..data[StorageKeys.authUser] =
          '{"id":"1","name":"Ana","email":"ana@ex.com"}';
    await _start(tester, storage);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('a failing secure storage falls back to sign in', (tester) async {
    await _start(tester, MemorySecureStorage(failReads: true));
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('signing in lands on home and back does not return', (
    tester,
  ) async {
    final router = await _start(tester, MemorySecureStorage());
    await tester.enterText(find.byType(TextField).at(0), '  Ana@Ex.com ');
    await tester.enterText(find.byType(TextField).at(1), '12345678');
    await tester.tap(find.text(AuthStrings.signIn));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(router.canPop(), isFalse);
  });

  testWidgets('Criar conta opens sign up', (tester) async {
    await _start(tester, MemorySecureStorage());
    await tester.ensureVisible(find.text(AuthStrings.createAccount));
    await tester.tap(find.text(AuthStrings.createAccount));
    await tester.pumpAndSettle();
    expect(find.text(AuthStrings.signUpSubtitle), findsOneWidget);
  });
}
