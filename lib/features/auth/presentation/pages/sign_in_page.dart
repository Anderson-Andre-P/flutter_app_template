import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_bloc.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/form_status.dart';
import '../../application/sign_in/sign_in_bloc.dart';
import '../../domain/entities/user_session.dart';
import '../auth_strings.dart';
import '../widgets/auth_scaffold.dart';

/// E-mail + password sign in. Expects a [SignInBloc] and the app's
/// [SessionBloc] above it; navigation is handed in by the router.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == FormStatus.success && state.user != null) {
          context.read<SessionBloc>().add(
            SessionStarted(state.user!.toSessionUser()),
          );
        } else if (state.status == FormStatus.failure &&
            state.errorMessage != null) {
          AppSnackbar.error(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        final bloc = context.read<SignInBloc>();
        void submit() => bloc.add(const SignInSubmitted());
        return AuthScaffold(
          title: AuthStrings.signInTitle,
          subtitle: AuthStrings.signInSubtitle,
          footer: AuthFooterLink(
            question: AuthStrings.noAccount,
            action: AuthStrings.createAccount,
            onTap: onCreateAccount,
          ),
          children: [
            AppTextField(
              label: AuthStrings.email,
              hint: AuthStrings.emailHint,
              errorText: state.emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (v) => bloc.add(SignInEmailChanged(v)),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: AuthStrings.password,
              hint: AuthStrings.passwordHint,
              errorText: state.passwordError,
              obscure: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onChanged: (v) => bloc.add(SignInPasswordChanged(v)),
              onSubmitted: (_) => submit(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => AppSnackbar.info(
                  context,
                  AuthStrings.forgotPasswordUnavailable,
                ),
                child: const Text(AuthStrings.forgotPassword),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            AppButton(
              label: AuthStrings.signIn,
              loading: state.status == FormStatus.loading,
              onPressed: submit,
            ),
          ],
        );
      },
    );
  }
}
