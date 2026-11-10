import 'package:equatable/equatable.dart';

import 'session_port.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

final class SessionState extends Equatable {
  const SessionState._(this.status, this.user);

  const SessionState.unknown() : this._(SessionStatus.unknown, null);

  const SessionState.authenticated(SessionUser user)
    : this._(SessionStatus.authenticated, user);

  const SessionState.unauthenticated()
    : this._(SessionStatus.unauthenticated, null);

  final SessionStatus status;
  final SessionUser? user;

  @override
  List<Object?> get props => [status, user];
}
