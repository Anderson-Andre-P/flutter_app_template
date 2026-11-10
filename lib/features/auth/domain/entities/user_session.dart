import '../../../../core/session/session_port.dart';
import 'user.dart';

/// Converts the auth [User] into the feature-agnostic [SessionUser] that
/// `core/session` knows.
extension UserToSession on User {
  SessionUser toSessionUser() => SessionUser(id: id, name: name, email: email);
}
