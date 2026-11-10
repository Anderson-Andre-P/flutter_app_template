import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPort extends Mock implements SessionPort {}

const _user = SessionUser(id: '1', name: 'Ana', email: 'ana@ex.com');

void main() {
  late _MockPort port;

  setUp(() => port = _MockPort());

  test('starts unknown', () {
    expect(SessionBloc(port).state.status, SessionStatus.unknown);
  });

  blocTest<SessionBloc, SessionState>(
    'Checked with a stored user is authenticated',
    setUp: () => when(() => port.current()).thenAnswer((_) async => _user),
    build: () => SessionBloc(port),
    act: (b) => b.add(const SessionChecked()),
    expect: () => [const SessionState.authenticated(_user)],
  );

  blocTest<SessionBloc, SessionState>(
    'Checked without a user is unauthenticated',
    setUp: () => when(() => port.current()).thenAnswer((_) async => null),
    build: () => SessionBloc(port),
    act: (b) => b.add(const SessionChecked()),
    expect: () => [const SessionState.unauthenticated()],
  );

  blocTest<SessionBloc, SessionState>(
    'Checked when the port throws is unauthenticated',
    setUp: () => when(() => port.current()).thenThrow(StateError('x')),
    build: () => SessionBloc(port),
    act: (b) => b.add(const SessionChecked()),
    expect: () => [const SessionState.unauthenticated()],
  );

  blocTest<SessionBloc, SessionState>(
    'Started authenticates with the given user',
    build: () => SessionBloc(port),
    act: (b) => b.add(const SessionStarted(_user)),
    expect: () => [const SessionState.authenticated(_user)],
  );

  blocTest<SessionBloc, SessionState>(
    'Ended ends the session in the port',
    setUp: () => when(() => port.end()).thenAnswer((_) async {}),
    build: () => SessionBloc(port),
    seed: () => const SessionState.authenticated(_user),
    act: (b) => b.add(const SessionEnded()),
    expect: () => [const SessionState.unauthenticated()],
    verify: (_) => verify(() => port.end()).called(1),
  );

  blocTest<SessionBloc, SessionState>(
    'Ended still signs out locally when the port throws',
    setUp: () => when(() => port.end()).thenThrow(StateError('storage')),
    build: () => SessionBloc(port),
    seed: () => const SessionState.authenticated(_user),
    act: (b) => b.add(const SessionEnded()),
    expect: () => [const SessionState.unauthenticated()],
  );
}
