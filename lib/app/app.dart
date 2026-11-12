import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection_container.dart';
import '../core/session/session_bloc.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_tokens.dart';
import '../core/theme/mode/theme_mode_bloc.dart';

/// Root widget: app-wide blocs, light/dark theme, pt-BR, router.
class App extends StatelessWidget {
  const App({super.key, required this.router});

  static const title = 'App Template';
  static const locale = Locale('pt', 'BR');

  final GoRouter router;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<ThemeModeBloc>.value(value: sl<ThemeModeBloc>()),
      BlocProvider<SessionBloc>.value(value: sl<SessionBloc>()),
    ],
    // Above MaterialApp, so the themes are built with sizes for this screen;
    // a new size rebuilds them.
    child: ScreenUtilPlusInit(
      designSize: AppScreen.designSize,
      minTextAdapt: true,
      builder: (context, _) => BlocBuilder<ThemeModeBloc, ThemeModeState>(
        builder: (context, theme) => MaterialApp.router(
          title: title,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: theme.mode,
          locale: locale,
          supportedLocales: const [locale],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: router,
        ),
      ),
    ),
  );
}
