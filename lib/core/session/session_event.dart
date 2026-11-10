import 'package:equatable/equatable.dart';

import 'session_port.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => const [];
}

/// Reads the stored session (splash).
final class SessionChecked extends SessionEvent {
  const SessionChecked();
}

/// A sign-in or sign-up succeeded.
final class SessionStarted extends SessionEvent {
  const SessionStarted(this.user);

  final SessionUser user;

  @override
  List<Object?> get props => [user];
}

/// The user signed out.
final class SessionEnded extends SessionEvent {
  const SessionEnded();
}
