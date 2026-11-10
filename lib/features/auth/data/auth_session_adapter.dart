import '../../../core/error/result.dart';
import '../../../core/session/session_port.dart';
import '../../../core/usecase/usecase.dart';
import '../domain/entities/user_session.dart';
import '../domain/usecases/get_current_session.dart';
import '../domain/usecases/sign_out.dart';

/// Implements core's [SessionPort] with the auth usecases.
final class AuthSessionAdapter implements SessionPort {
  const AuthSessionAdapter(this._getCurrentSession, this._signOut);

  final GetCurrentSession _getCurrentSession;
  final SignOut _signOut;

  @override
  Future<SessionUser?> current() async =>
      switch (await _getCurrentSession(const NoParams())) {
        Success(:final value) => value?.toSessionUser(),
        ResultFailure() => null,
      };

  @override
  Future<void> end() async {
    await _signOut(const NoParams());
  }
}
