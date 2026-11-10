import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'sign_in.dart';

final class SignUpParams extends Equatable {
  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}

/// Validates the form, then creates the account and signs in.
final class SignUp implements UseCase<User, SignUpParams> {
  const SignUp(this._repository);

  final AuthRepository _repository;

  static const invalidName = 'Informe seu nome';

  @override
  Future<Result<User>> call(SignUpParams params) async {
    if (!Validators.isValidName(params.name)) {
      return const ResultFailure(ValidationFailure(invalidName));
    }
    if (!Validators.isValidEmail(params.email)) {
      return const ResultFailure(ValidationFailure(SignIn.invalidEmail));
    }
    if (!Validators.isValidPassword(params.password)) {
      return const ResultFailure(ValidationFailure(SignIn.shortPassword));
    }
    try {
      return Success(
        await _repository.signUp(
          name: params.name.trim(),
          email: Validators.normalizeEmail(params.email),
          password: params.password,
        ),
      );
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}
