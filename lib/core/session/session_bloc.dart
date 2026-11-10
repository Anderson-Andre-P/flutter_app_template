import 'package:flutter_bloc/flutter_bloc.dart';

import 'session_event.dart';
import 'session_port.dart';
import 'session_state.dart';

export 'session_event.dart';
export 'session_port.dart';
export 'session_state.dart';

/// App-wide session. The router listens to it to redirect between the
/// public (sign in / sign up) and the signed-in areas.
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc(this._port) : super(const SessionState.unknown()) {
    on<SessionChecked>(_onChecked);
    on<SessionStarted>((e, emit) => emit(SessionState.authenticated(e.user)));
    on<SessionEnded>(_onEnded);
  }

  final SessionPort _port;

  Future<void> _onChecked(
    SessionChecked event,
    Emitter<SessionState> emit,
  ) async {
    SessionUser? user;
    try {
      user = await _port.current();
    } catch (_) {
      user = null;
    }
    emit(
      user == null
          ? const SessionState.unauthenticated()
          : SessionState.authenticated(user),
    );
  }

  /// The user asked to leave: the app always signs out locally, even if
  /// ending the session in the port fails.
  Future<void> _onEnded(SessionEnded event, Emitter<SessionState> emit) async {
    try {
      await _port.end();
    } catch (_) {
      // The port is responsible for best-effort cleanup and logging.
    } finally {
      emit(const SessionState.unauthenticated());
    }
  }
}
