import 'package:flutter/material.dart';

import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../../../../core/widgets/section_overline.dart';
import '../examples_strings.dart';

/// Every feedback pattern of the design system on one screen: the four
/// snackbar tones, both dialogs and the empty / error / loading states.
class FeedbackDemoPage extends StatelessWidget {
  const FeedbackDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget pair(Widget a, Widget b) => Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: b),
      ],
    );
    AppButton small(String label, VoidCallback onPressed) => AppButton(
      label: label,
      size: AppButtonSize.md,
      variant: AppButtonVariant.secondary,
      onPressed: onPressed,
    );

    return Scaffold(
      appBar: const AppTopBar(
        title: ExamplesStrings.feedbackTitle,
        showBack: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.x4l,
        ),
        children: [
          const SectionOverline(ExamplesStrings.toastsTitle),
          const SizedBox(height: AppSpacing.md),
          pair(
            small(
              ExamplesStrings.toastSuccess,
              () => AppSnackbar.success(
                context,
                ExamplesStrings.toastSuccessMessage,
              ),
            ),
            small(
              ExamplesStrings.toastWarning,
              () => AppSnackbar.warning(
                context,
                ExamplesStrings.toastWarningMessage,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          pair(
            small(
              ExamplesStrings.toastError,
              () =>
                  AppSnackbar.error(context, ExamplesStrings.toastErrorMessage),
            ),
            small(
              ExamplesStrings.toastInfo,
              () => AppSnackbar.info(context, ExamplesStrings.toastInfoMessage),
            ),
          ),
          const SizedBox(height: AppSpacing.x3l),
          const SectionOverline(ExamplesStrings.dialogsTitle),
          const SizedBox(height: AppSpacing.md),
          pair(
            small(
              ExamplesStrings.dialogConfirm,
              () => AppDialog.confirm(
                context,
                title: ExamplesStrings.dialogConfirmTitle,
                message: ExamplesStrings.dialogConfirmMessage,
                confirmLabel: ExamplesStrings.dialogConfirmLabel,
                destructive: true,
              ),
            ),
            small(
              ExamplesStrings.dialogAlert,
              () => AppDialog.alert(
                context,
                title: ExamplesStrings.dialogAlertTitle,
                message: ExamplesStrings.dialogAlertMessage,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3l),
          const SectionOverline(ExamplesStrings.statesTitle),
          const SizedBox(height: AppSpacing.md),
          const AppCard(child: AppLoadingView()),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: AppEmptyView(
              icon: Icons.inbox_outlined,
              title: ExamplesStrings.stateEmptyTitle,
              message: ExamplesStrings.stateEmptyMessage,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: AppErrorView(
              title: ExamplesStrings.stateErrorTitle,
              message: ExamplesStrings.stateErrorMessage,
              retryLabel: CommonStrings.retry,
              onRetry: () => AppSnackbar.info(context, CommonStrings.retry),
            ),
          ),
        ],
      ),
    );
  }
}
