import 'package:flutter_app_template/core/error/app_exception.dart';
import 'package:flutter_app_template/core/error/failure.dart';
import 'package:flutter_app_template/core/error/result.dart';
import 'package:flutter_app_template/core/logging/app_logger.dart';
import 'package:flutter_app_template/core/usecase/usecase.dart';
import 'package:flutter_app_template/features/auth/domain/entities/user.dart';
import 'package:flutter_app_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/get_current_session.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository {}

class _MockLogger extends Mock implements AppLogger {}

const _user = User(id: '1', name: 'Ana', email: 'ana@ex.com');

void main() {
  late _MockRepo repo;

  setUp(() => repo = _MockRepo());

  group('SignIn', () {
    test('normalizes the e-mail before calling the repository', () async {
      when(() => repo.signIn(email: 'ana@ex.com', password: '12345678'))
          .thenAnswer((_) async => _user);
      final result = await SignIn(repo)(
        const SignInParams(email: '  Ana@Ex.com ', password: '12345678'),
      );
      expect(result, const Success(_user));
    });

    test(
      'a short password fails validation without calling the repository',
      () async {
        final result = await SignIn(repo)(
          const SignInParams(email: 'ana@ex.com', password: '123'),
        );
        expect(result, isA<ResultFailure<User>>());
        expect(
          (result as ResultFailure<User>).failure,
          isA<ValidationFailure>(),
        );
        verifyNever(
          () => repo.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    test('an invalid e-mail fails validation', () async {
      final result = await SignIn(repo)(
        const SignInParams(email: 'ana', password: '12345678'),
      );
      expect((result as ResultFailure<User>).failure, isA<ValidationFailure>());
    });

    test('a repository error becomes a failure, never a throw', () async {
      when(
        () => repo.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const NetworkException('down'));
      final result = await SignIn(repo)(
        const SignInParams(email: 'ana@ex.com', password: '12345678'),
      );
      expect(result, const ResultFailure<User>(NetworkFailure()));
    });
  });

  group('SignUp', () {
    test('rejects a blank name', () async {
      final result = await SignUp(repo)(
        const SignUpParams(
          name: ' ',
          email: 'ana@ex.com',
          password: '12345678',
        ),
      );
      expect((result as ResultFailure<User>).failure, isA<ValidationFailure>());
    });

    test('passes trimmed name and normalized e-mail', () async {
      when(
        () =>
            repo.signUp(name: 'Ana', email: 'ana@ex.com', password: '12345678'),
      ).thenAnswer((_) async => _user);
      final result = await SignUp(repo)(
        const SignUpParams(
          name: ' Ana ',
          email: 'ANA@ex.com',
          password: '12345678',
        ),
      );
      expect(result, const Success(_user));
    });
  });

  test('SignOut calls the repository', () async {
    when(() => repo.signOut()).thenAnswer((_) async {});
    expect(await SignOut(repo)(const NoParams()), const Success<void>(null));
    verify(() => repo.signOut()).called(1);
  });

  group('GetCurrentSession', () {
    test('returns the stored user', () async {
      when(() => repo.currentUser()).thenAnswer((_) async => _user);
      expect(
        await GetCurrentSession(repo, _MockLogger())(const NoParams()),
        const Success<User?>(_user),
      );
    });

    test('a storage error means no session', () async {
      final logger = _MockLogger();
      when(() => repo.currentUser()).thenThrow(const StorageException('x'));
      expect(
        await GetCurrentSession(repo, logger)(const NoParams()),
        const Success<User?>(null),
      );
      verify(() => logger.warning(any(), error: any(named: 'error'))).called(1);
    });
  });
}
