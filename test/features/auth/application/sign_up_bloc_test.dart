import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_template/core/error/result.dart';
import 'package:flutter_app_template/features/auth/application/form_status.dart';
import 'package:flutter_app_template/features/auth/application/sign_up/sign_up_bloc.dart';
import 'package:flutter_app_template/features/auth/domain/entities/user.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignUp extends Mock implements SignUp {}

const _user = User(id: '1', name: 'Ana', email: 'ana@ex.com');

void main() {
  late _MockSignUp signUp;

  setUpAll(
    () => registerFallbackValue(
      const SignUpParams(name: 'n', email: 'e', password: 'p'),
    ),
  );
  setUp(() => signUp = _MockSignUp());

  SignUpBloc filled({String confirm = '12345678', bool terms = true}) =>
      SignUpBloc(signUp)
        ..add(const SignUpNameChanged('Ana'))
        ..add(const SignUpEmailChanged('ana@ex.com'))
        ..add(const SignUpPasswordChanged('12345678'))
        ..add(SignUpConfirmPasswordChanged(confirm))
        ..add(SignUpTermsChanged(accepted: terms));

  blocTest<SignUpBloc, SignUpState>(
    'mismatched passwords block the submit',
    build: () => filled(confirm: '87654321'),
    act: (b) => b.add(const SignUpSubmitted()),
    skip: 5,
    expect: () => [
      isA<SignUpState>().having(
        (s) => s.confirmPasswordError,
        'confirmPasswordError',
        SignUpBloc.passwordsDontMatch,
      ),
    ],
    verify: (_) => verifyNever(() => signUp(any())),
  );

  blocTest<SignUpBloc, SignUpState>(
    'terms must be accepted',
    build: () => filled(terms: false),
    act: (b) => b.add(const SignUpSubmitted()),
    skip: 4, // terms=false equals the initial state, so it emits nothing
    expect: () => [
      isA<SignUpState>().having(
        (s) => s.termsError,
        'termsError',
        SignUpBloc.termsRequired,
      ),
    ],
    verify: (_) => verifyNever(() => signUp(any())),
  );

  blocTest<SignUpBloc, SignUpState>(
    'a complete form signs up',
    setUp: () =>
        when(() => signUp(any())).thenAnswer((_) async => const Success(_user)),
    build: filled,
    act: (b) => b.add(const SignUpSubmitted()),
    skip: 6,
    expect: () => [
      isA<SignUpState>()
          .having((s) => s.status, 'status', FormStatus.success)
          .having((s) => s.user, 'user', _user),
    ],
  );
}
