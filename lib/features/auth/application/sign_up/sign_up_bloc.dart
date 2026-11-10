import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/result.dart';
import '../../domain/usecases/sign_up.dart';
import '../form_status.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

export 'sign_up_event.dart';
export 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._signUp) : super(const SignUpState()) {
    on<SignUpNameChanged>((e, emit) => emit(state.copyWith(name: e.name)));
    on<SignUpEmailChanged>((e, emit) => emit(state.copyWith(email: e.email)));
    on<SignUpPasswordChanged>(
      (e, emit) => emit(state.copyWith(password: e.password)),
    );
    on<SignUpConfirmPasswordChanged>(
      (e, emit) => emit(state.copyWith(confirmPassword: e.confirmPassword)),
    );
    on<SignUpTermsChanged>(
      (e, emit) => emit(state.copyWith(termsAccepted: e.accepted)),
    );
    on<SignUpSubmitted>(_onSubmitted);
  }

  static const passwordsDontMatch = SignUpState.passwordsDontMatch;
  static const termsRequired = SignUpState.termsRequired;

  final SignUp _signUp;

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.status == FormStatus.loading) return;
    if (!state.isValid) {
      emit(state.copyWith(submitted: true));
      return;
    }
    emit(
      state.copyWith(
        submitted: true,
        status: FormStatus.loading,
        errorMessage: () => null,
      ),
    );
    final result = await _signUp(
      SignUpParams(
        name: state.name,
        email: state.email,
        password: state.password,
      ),
    );
    emit(switch (result) {
      Success(:final value) => state.copyWith(
        status: FormStatus.success,
        user: value,
      ),
      ResultFailure(:final failure) => state.copyWith(
        status: FormStatus.failure,
        errorMessage: () => failure.message,
      ),
    });
  }
}
