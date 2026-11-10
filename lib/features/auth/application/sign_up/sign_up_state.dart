import 'package:equatable/equatable.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../form_status.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.termsAccepted = false,
    this.status = FormStatus.initial,
    this.submitted = false,
    this.errorMessage,
    this.user,
  });

  static const passwordsDontMatch = 'As senhas não conferem';
  static const termsRequired = 'Aceite os termos para continuar';

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool termsAccepted;
  final FormStatus status;
  final bool submitted;
  final String? errorMessage;
  final User? user;

  String? get nameError =>
      submitted && !Validators.isValidName(name) ? SignUp.invalidName : null;

  String? get emailError =>
      submitted && !Validators.isValidEmail(email) ? SignIn.invalidEmail : null;

  String? get passwordError =>
      submitted && !Validators.isValidPassword(password)
      ? SignIn.shortPassword
      : null;

  String? get confirmPasswordError =>
      submitted && confirmPassword != password ? passwordsDontMatch : null;

  String? get termsError => submitted && !termsAccepted ? termsRequired : null;

  bool get isValid =>
      Validators.isValidName(name) &&
      Validators.isValidEmail(email) &&
      Validators.isValidPassword(password) &&
      confirmPassword == password &&
      termsAccepted;

  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? termsAccepted,
    FormStatus? status,
    bool? submitted,
    String? Function()? errorMessage,
    User? user,
  }) => SignUpState(
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
    termsAccepted: termsAccepted ?? this.termsAccepted,
    status: status ?? this.status,
    submitted: submitted ?? this.submitted,
    errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    user: user ?? this.user,
  );

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    termsAccepted,
    status,
    submitted,
    errorMessage,
    user,
  ];
}
