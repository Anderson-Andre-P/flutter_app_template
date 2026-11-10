import 'package:equatable/equatable.dart';

/// Who is signed in, as `core` sees it (no dependency on any feature).
final class SessionUser extends Equatable {
  const SessionUser({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}

/// What `core` needs from authentication. The auth feature implements it
/// and the composition root (`core/di`) wires it, so `core` never imports a
/// feature.
abstract interface class SessionPort {
  /// The stored session's user, or `null`.
  Future<SessionUser?> current();

  /// Ends the session (sign out).
  Future<void> end();
}
