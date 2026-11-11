import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection_container.dart';
import '../../core/session/session_bloc.dart';
import '../../features/auth/application/sign_in/sign_in_bloc.dart';
import '../../features/auth/application/sign_up/sign_up_bloc.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/examples/application/activity_detail_bloc.dart';
import '../../features/examples/application/activity_list_bloc.dart';
import '../../features/examples/application/transfer_bloc.dart';
import '../../features/examples/domain/entities/transfer.dart';
import '../../features/examples/presentation/examples_strings.dart';
import '../../features/examples/presentation/pages/activity_detail_page.dart';
import '../../features/examples/presentation/pages/activity_list_page.dart';
import '../../features/examples/presentation/pages/dashboard_page.dart';
import '../../features/examples/application/demo_selection_bloc.dart';
import '../../features/examples/presentation/pages/bottom_nav_demo_page.dart';
import '../../features/examples/presentation/pages/cards_demo_page.dart';
import '../../features/examples/presentation/pages/charts_demo_page.dart';
import '../../features/examples/presentation/pages/chat_demo_page.dart';
import '../../features/examples/presentation/pages/controls_demo_page.dart';
import '../../features/examples/presentation/pages/forms_demo_page.dart';
import '../../features/examples/presentation/pages/navigation_demo_page.dart';
import '../../features/examples/presentation/pages/modals_demo_page.dart';
import '../../features/examples/presentation/pages/sheets_demo_page.dart';
import '../../features/examples/presentation/pages/states_demo_page.dart';
import '../../features/examples/presentation/pages/toasts_demo_page.dart';
import '../../features/examples/presentation/pages/widgets_demo_page.dart';
import '../../features/examples/presentation/pages/transfer_page.dart';
import '../../features/examples/presentation/pages/transfer_success_page.dart';
import '../../features/home/presentation/home_demo.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/home_shell.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
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
      GoRoute(
        path: AppRoutes.transferDone,
        builder: (context, state) => TransferSuccessPage(
          receipt: state.extra is TransferReceipt
              ? state.extra! as TransferReceipt
              : ExamplesStrings.sampleReceipt(DateTime.now()),
          onHome: () => context.go(AppRoutes.home),
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
                builder: (context, state) =>
                    HomePage(onOpenDemo: (demo) => _openDemo(context, demo)),
                routes: _exampleRoutes,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

void _openDemo(BuildContext context, HomeDemo demo) => switch (demo) {
  HomeDemo.dashboard => context.push(AppRoutes.dashboard),
  HomeDemo.statement => context.push(AppRoutes.statement),
  HomeDemo.detail => context.push(
    AppRoutes.statementItem(ExamplesStrings.sampleActivityId),
  ),
  HomeDemo.form => context.push(AppRoutes.transfer),
  HomeDemo.success => context.push(
    AppRoutes.transferDone,
    extra: ExamplesStrings.sampleReceipt(DateTime.now()),
  ),
  HomeDemo.states => context.push(AppRoutes.states),
  HomeDemo.widgets => context.push(AppRoutes.widgets),
  HomeDemo.bottomNav => context.push(AppRoutes.bottomNav),
  HomeDemo.modals => context.push(AppRoutes.modals),
  HomeDemo.sheets => context.push(AppRoutes.sheets),
  HomeDemo.toasts => context.push(AppRoutes.toasts),
  HomeDemo.charts => context.push(AppRoutes.charts),
  HomeDemo.controls => context.push(AppRoutes.controls),
  HomeDemo.forms => context.push(AppRoutes.forms),
  HomeDemo.navigation => context.push(AppRoutes.navigation),
  HomeDemo.chat => context.push(AppRoutes.chat),
  HomeDemo.cards => context.push(AppRoutes.cards),
};

/// Example screens, nested under the home tab so the bottom navigation
/// stays visible. Paths are relative to [AppRoutes.home].
final _exampleRoutes = <RouteBase>[
  GoRoute(
    path: 'painel',
    builder: (context, state) =>
        DashboardPage(onStartTransfer: () => context.push(AppRoutes.transfer)),
  ),
  GoRoute(
    path: 'extrato',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<ActivityListBloc>()..add(const ActivityListStarted()),
      child: ActivityListPage(
        onOpen: (id) => context.push(AppRoutes.statementItem(id)),
      ),
    ),
    routes: [
      GoRoute(
        path: ':id',
        builder: (context, state) => BlocProvider(
          create: (_) =>
              sl<ActivityDetailBloc>()
                ..add(ActivityDetailRequested(state.pathParameters['id']!)),
          child: const ActivityDetailPage(),
        ),
      ),
    ],
  ),
  GoRoute(
    path: 'transferir',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<TransferBloc>(),
      child: TransferPage(
        onSent: (receipt) => context.go(AppRoutes.transferDone, extra: receipt),
      ),
    ),
  ),
  GoRoute(path: 'estados', builder: (context, state) => const StatesDemoPage()),
  GoRoute(
    path: 'widgets',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<DemoSelectionBloc>(),
      child: const WidgetsDemoPage(),
    ),
  ),
  GoRoute(
    path: 'barra-inferior',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<DemoSelectionBloc>(),
      child: const BottomNavDemoPage(),
    ),
  ),
  GoRoute(path: 'modais', builder: (context, state) => const ModalsDemoPage()),
  GoRoute(
    path: 'bottom-sheets',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<DemoSelectionBloc>(),
      child: const SheetsDemoPage(),
    ),
  ),
  GoRoute(path: 'toasts', builder: (context, state) => const ToastsDemoPage()),
  GoRoute(
    path: 'graficos',
    builder: (context, state) => const ChartsDemoPage(),
  ),
  GoRoute(path: 'conversa', builder: (context, state) => const ChatDemoPage()),
  GoRoute(
    path: 'cartoes',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<DemoSelectionBloc>(),
      child: const CardsDemoPage(),
    ),
  ),
  GoRoute(
    path: 'navegacao',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<DemoSelectionBloc>(),
      child: const NavigationDemoPage(),
    ),
  ),
  GoRoute(
    path: 'formularios',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<DemoSelectionBloc>(),
      child: const FormsDemoPage(),
    ),
  ),
  GoRoute(
    path: 'controles',
    builder: (context, state) => BlocProvider(
      create: (_) => sl<DemoSelectionBloc>(),
      child: const ControlsDemoPage(),
    ),
  ),
];

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
