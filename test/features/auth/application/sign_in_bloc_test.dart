import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_template/core/error/failure.dart';
import 'package:flutter_app_template/core/error/result.dart';
import 'package:flutter_app_template/features/auth/application/form_status.dart';
import 'package:flutter_app_template/features/auth/application/sign_in/sign_in_bloc.dart';
import 'package:flutter_app_template/features/auth/domain/entities/user.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignIn extends Mock implements SignIn {}

const _user = User(id: '1', name: 'Ana', email: 'ana@ex.com');
const _params = SignInParams(email: 'ana@ex.com', password: '12345678');

void main() {
  late _MockSignIn signIn;

  setUpAll(() => registerFallbackValue(_params));
  setUp(() => signIn = _MockSignIn());

  SignInBloc filled() => SignInBloc(signIn)
    ..add(const SignInEmailChanged('ana@ex.com'))
    ..add(const SignInPasswordChanged('12345678'));

  blocTest<SignInBloc, SignInState>(
    'valid submit goes loading then success',
    setUp: () => when(
      () => signIn(_params),
    ).thenAnswer((_) async => const Success(_user)),
    build: filled,
    act: (b) => b.add(const SignInSubmitted()),
    skip: 2,
    expect: () => [
      isA<SignInState>().having((s) => s.status, 'status', FormStatus.loading),
      isA<SignInState>()
          .having((s) => s.status, 'status', FormStatus.success)
          .having((s) => s.user, 'user', _user),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'a second submit while loading is ignored',
    setUp: () {
      final pending = Completer<Result<User>>();
      when(() => signIn(any())).thenAnswer((_) => pending.future);
    },
    build: filled,
    act: (b) => b
      ..add(const SignInSubmitted())
      ..add(const SignInSubmitted()),
    verify: (_) => verify(() => signIn(any())).called(1),
  );

  blocTest<SignInBloc, SignInState>(
    'an invalid e-mail shows a field error and skips the usecase',
    build: () => SignInBloc(signIn)
      ..add(const SignInEmailChanged('ana'))
      ..add(const SignInPasswordChanged('12345678')),
    act: (b) => b.add(const SignInSubmitted()),
    skip: 2,
    expect: () => [
      isA<SignInState>()
          .having((s) => s.emailError, 'emailError', SignIn.invalidEmail)
          .having((s) => s.status, 'status', FormStatus.initial),
    ],
    verify: (_) => verifyNever(() => signIn(any())),
  );

  blocTest<SignInBloc, SignInState>(
    'field errors appear only after the first submit',
    build: () => SignInBloc(signIn),
    act: (b) => b.add(const SignInEmailChanged('a')),
    expect: () => [
      isA<SignInState>().having((s) => s.emailError, 'emailError', isNull),
    ],
  );

  blocTest<SignInBloc, SignInState>(
    'a usecase failure exposes its message',
    setUp: () => when(
      () => signIn(any()),
    ).thenAnswer((_) async => const ResultFailure(NetworkFailure())),
    build: filled,
    act: (b) => b.add(const SignInSubmitted()),
    skip: 3,
    expect: () => [
      isA<SignInState>()
          .having((s) => s.status, 'status', FormStatus.failure)
          .having(
            (s) => s.errorMessage,
            'errorMessage',
            const NetworkFailure().message,
          ),
    ],
  );
}
