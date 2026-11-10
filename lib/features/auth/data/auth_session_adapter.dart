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

  /// Throws when signing out failed, so callers can tell; the repository
  /// has already wiped what it could.
  @override
  Future<void> end() async {
    final result = await _signOut(const NoParams());
    if (result case ResultFailure(:final failure)) {
      throw StateError('sign out failed: ${failure.message}');
    }
  }
}
