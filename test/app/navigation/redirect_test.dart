import 'package:flutter_app_template/app/navigation/app_router.dart';
import 'package:flutter_app_template/app/navigation/app_routes.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unknown session always waits on the splash', () {
    expect(
      resolveRedirect(SessionStatus.unknown, AppRoutes.home),
      AppRoutes.splash,
    );
    expect(resolveRedirect(SessionStatus.unknown, AppRoutes.splash), isNull);
  });

  test('signed out: protected routes go to sign in, public ones stay', () {
    expect(
      resolveRedirect(SessionStatus.unauthenticated, AppRoutes.home),
      AppRoutes.signIn,
    );
    expect(
      resolveRedirect(SessionStatus.unauthenticated, AppRoutes.splash),
      AppRoutes.signIn,
    );
    expect(
      resolveRedirect(SessionStatus.unauthenticated, AppRoutes.signUp),
      isNull,
    );
    expect(
      resolveRedirect(SessionStatus.unauthenticated, AppRoutes.signIn),
      isNull,
    );
  });

  test('signed in: public routes go home, protected ones stay', () {
    expect(
      resolveRedirect(SessionStatus.authenticated, AppRoutes.signIn),
      AppRoutes.home,
    );
    expect(
      resolveRedirect(SessionStatus.authenticated, AppRoutes.splash),
      AppRoutes.home,
    );
    expect(
      resolveRedirect(SessionStatus.authenticated, AppRoutes.settings),
      isNull,
    );
  });
}
