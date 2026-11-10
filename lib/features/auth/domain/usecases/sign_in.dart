import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

final class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Validates and normalizes the credentials, then signs in.
class SignIn implements UseCase<User, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  static const invalidEmail = 'Informe um e-mail válido';
  static const shortPassword = 'A senha precisa ter pelo menos 8 caracteres';

  @override
  Future<Result<User>> call(SignInParams params) async {
    if (!Validators.isValidEmail(params.email)) {
      return const ResultFailure(ValidationFailure(invalidEmail));
    }
    if (!Validators.isValidPassword(params.password)) {
      return const ResultFailure(ValidationFailure(shortPassword));
    }
    try {
      return Success(
        await _repository.signIn(
          email: Validators.normalizeEmail(params.email),
          password: params.password,
        ),
      );
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}
