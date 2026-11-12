import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'app/navigation/app_router.dart';
import 'core/config/env_config.dart';
import 'core/di/injection_container.dart';
import 'core/monitoring/monitoring.dart';
import 'core/session/session_bloc.dart';
import 'core/theme/mode/theme_mode_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = EnvConfig.fromEnvironment();
  await setupDependencies(config);

  sl<ThemeModeBloc>().add(const ThemeModeStarted());
  final session = sl<SessionBloc>()..add(const SessionChecked());
  final router = AppRouter.create(session);

  await Monitoring.run(config, () async => runApp(App(router: router)));
}
