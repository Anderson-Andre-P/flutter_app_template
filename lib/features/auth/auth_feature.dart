import 'package:get_it/get_it.dart';

import '../../core/logging/app_logger.dart';
import '../../core/session/session_port.dart';
import '../../core/storage/secure/secure_storage.dart';
import 'application/sign_in/sign_in_bloc.dart';
import 'application/sign_up/sign_up_bloc.dart';
import 'data/auth_session_adapter.dart';
import 'data/fake_auth_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_current_session.dart';
import 'domain/usecases/sign_in.dart';
import 'domain/usecases/sign_out.dart';
import 'domain/usecases/sign_up.dart';

/// Registers the auth feature. To use a real backend, register another
/// [AuthRepository] here — nothing else changes.
void registerAuthFeature(GetIt sl) {
  sl
    ..registerLazySingleton<AuthRepository>(
      () => FakeAuthRepository(sl<SecureStorage>()),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => SignOut(sl()))
    ..registerLazySingleton(() => GetCurrentSession(sl(), sl<AppLogger>()))
    ..registerLazySingleton<SessionPort>(() => AuthSessionAdapter(sl(), sl()))
    ..registerFactory(() => SignInBloc(sl()))
    ..registerFactory(() => SignUpBloc(sl()));
}
