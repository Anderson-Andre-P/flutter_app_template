import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth_feature.dart';
import '../../features/examples/examples_feature.dart';
import '../config/env_config.dart';
import '../logging/app_logger.dart';
import '../logging/debug_app_logger.dart';
import '../network/api_client.dart';
import '../session/session_bloc.dart';
import '../storage/prefs/preferences_storage.dart';
import '../storage/secure/secure_storage.dart';
import '../theme/mode/theme_mode_bloc.dart';

/// The service locator. Only the composition root (this file, `lib/app` and
/// `main.dart`) reads it; widgets get blocs through `BlocProvider`.
final GetIt sl = GetIt.instance;

/// Registers core services, then each feature (`register<Feature>Feature`).
/// The only place in `core/` allowed to import `features/`.
///
/// [secureStorage] lets tests swap the plugin-backed storage.
Future<void> setupDependencies(
  EnvConfig config, {
  SecureStorage? secureStorage,
}) async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerSingleton<EnvConfig>(config)
    ..registerSingleton<AppLogger>(const DebugAppLogger())
    ..registerSingleton<SecureStorage>(
      secureStorage ?? const FlutterSecureStorageImpl(FlutterSecureStorage()),
    )
    ..registerSingleton<PreferencesStorage>(SharedPreferencesStorage(prefs))
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton(
      () => ApiClient(client: sl(), config: sl(), storage: sl()),
    )
    ..registerLazySingleton(() => ThemeModeBloc(sl()));

  registerAuthFeature(sl);
  registerExamplesFeature(sl);

  // Needs the SessionPort registered by the auth feature.
  sl.registerLazySingleton(() => SessionBloc(sl()));
}
