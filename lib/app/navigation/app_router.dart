import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection_container.dart';
import '../../core/session/session_bloc.dart';
import '../../features/auth/application/sign_in/sign_in_bloc.dart';
import '../../features/auth/application/sign_up/sign_up_bloc.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/home_shell.dart';
import '../../features/settings/presentation/pages/profile_page.dart';
import 'app_routes.dart';

/// Where [location] must go for the session [status], or `null` to stay.
/// Pure, so the whole access policy is unit-tested.
String? resolveRedirect(SessionStatus status, String location) {
  final isPublic = AppRoutes.public.contains(location);
  return switch (status) {
    SessionStatus.unknown =>
      location == AppRoutes.splash ? null : AppRoutes.splash,
    SessionStatus.unauthenticated => isPublic ? null : AppRoutes.signIn,
    SessionStatus.authenticated =>
      isPublic || location == AppRoutes.splash ? AppRoutes.home : null,
  };
}

abstract final class AppRouter {
  /// Builds the app router. Redirects re-run on every [session] change, and
  /// use `go` semantics, so "back" never returns to sign in after login.
  static GoRouter create(SessionBloc session) => GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _StreamListenable(session.stream),
    redirect: (context, state) =>
        resolveRedirect(session.state.status, state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SignInBloc>(),
          child: SignInPage(
            onCreateAccount: () => context.push(AppRoutes.signUp),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SignUpBloc>(),
          child: SignUpPage(
            onSignIn: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.signIn),
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(
          currentIndex: shell.currentIndex,
          onTabSelected: (i) =>
              shell.goBranch(i, initialLocation: i == shell.currentIndex),
          child: shell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Adapts a stream to the [Listenable] `refreshListenable` expects.
/// Implements [Listenable] directly (not `ChangeNotifier`): it holds no
/// state, it only forwards "the session changed". Lives as long as the app.
class _StreamListenable implements Listenable {
  _StreamListenable(Stream<Object?> stream) {
    stream.listen((_) {
      for (final listener in List.of(_listeners)) {
        listener();
      }
    });
  }

  final _listeners = <VoidCallback>[];

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
}
