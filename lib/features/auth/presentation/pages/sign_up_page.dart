import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_bloc.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/form_status.dart';
import '../../application/sign_up/sign_up_bloc.dart';
import '../../domain/entities/user_session.dart';
import '../auth_strings.dart';
import '../widgets/auth_scaffold.dart';

/// Account creation. Expects a [SignUpBloc] and the app's [SessionBloc]
/// above it; navigation is handed in by the router.
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
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
        final bloc = context.read<SignUpBloc>();
        final c = context.colors;
        void submit() => bloc.add(const SignUpSubmitted());
        return AuthScaffold(
          title: AuthStrings.signUpTitle,
          subtitle: AuthStrings.signUpSubtitle,
          footer: AuthFooterLink(
            question: AuthStrings.haveAccount,
            action: AuthStrings.signIn,
            onTap: onSignIn,
          ),
          children: [
            AppTextField(
              label: AuthStrings.name,
              hint: AuthStrings.nameHint,
              required: true,
              errorText: state.nameError,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              onChanged: (v) => bloc.add(SignUpNameChanged(v)),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: AuthStrings.email,
              hint: AuthStrings.emailHint,
              required: true,
              errorText: state.emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (v) => bloc.add(SignUpEmailChanged(v)),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: AuthStrings.password,
              required: true,
              obscure: true,
              errorText: state.passwordError,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              onChanged: (v) => bloc.add(SignUpPasswordChanged(v)),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: AuthStrings.confirmPassword,
              required: true,
              obscure: true,
              errorText: state.confirmPasswordError,
              textInputAction: TextInputAction.done,
              onChanged: (v) => bloc.add(SignUpConfirmPasswordChanged(v)),
              onSubmitted: (_) => submit(),
            ),
            SizedBox(height: AppSpacing.md),
            InkWell(
              borderRadius: AppRadius.brSm,
              onTap: () =>
                  bloc.add(SignUpTermsChanged(accepted: !state.termsAccepted)),
              child: Row(
                children: [
                  Checkbox(
                    value: state.termsAccepted,
                    onChanged: (v) =>
                        bloc.add(SignUpTermsChanged(accepted: v ?? false)),
                  ),
                  Expanded(
                    child: Text(
                      AuthStrings.acceptTerms,
                      style: AppTypography.body.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.termsError != null)
              Padding(
                padding: EdgeInsets.only(left: AppSpacing.md),
                child: Text(
                  state.termsError!,
                  style: AppTypography.caption.copyWith(color: c.danger),
                ),
              ),
            SizedBox(height: AppSpacing.x2l),
            AppButton(
              label: AuthStrings.createAccount,
              loading: state.status == FormStatus.loading,
              onPressed: submit,
            ),
          ],
        );
      },
    );
  }
}
