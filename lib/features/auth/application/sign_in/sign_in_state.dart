import 'package:equatable/equatable.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in.dart';
import '../form_status.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.email = '',
    this.password = '',
    this.status = FormStatus.initial,
    this.submitted = false,
    this.errorMessage,
    this.user,
  });

  final String email;
  final String password;
  final FormStatus status;

  /// Field errors show only after the first submit.
  final bool submitted;
  final String? errorMessage;
  final User? user;

  String? get emailError =>
      submitted && !Validators.isValidEmail(email) ? SignIn.invalidEmail : null;

  String? get passwordError =>
      submitted && !Validators.isValidPassword(password)
      ? SignIn.shortPassword
      : null;

  bool get isValid =>
      Validators.isValidEmail(email) && Validators.isValidPassword(password);

  SignInState copyWith({
    String? email,
    String? password,
    FormStatus? status,
    bool? submitted,
    String? Function()? errorMessage,
    User? user,
  }) => SignInState(
    email: email ?? this.email,
    password: password ?? this.password,
    status: status ?? this.status,
    submitted: submitted ?? this.submitted,
    errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    user: user ?? this.user,
  );

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    submitted,
    errorMessage,
    user,
  ];
}
