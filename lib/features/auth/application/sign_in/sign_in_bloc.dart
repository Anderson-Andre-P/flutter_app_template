import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/result.dart';
import '../../domain/usecases/sign_in.dart';
import '../form_status.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

export 'sign_in_event.dart';
export 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this._signIn) : super(const SignInState()) {
    on<SignInEmailChanged>((e, emit) => emit(state.copyWith(email: e.email)));
    on<SignInPasswordChanged>(
      (e, emit) => emit(state.copyWith(password: e.password)),
    );
    on<SignInSubmitted>(_onSubmitted);
  }

  final SignIn _signIn;

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
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
    final result = await _signIn(
      SignInParams(email: state.email, password: state.password),
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
