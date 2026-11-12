import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Every toast tone (title, description and action), a title-only toast,
/// one whose action shows another toast, and two stacked at once.
class ToastsDemoPage extends StatelessWidget {
  const ToastsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppButton trigger(String label, VoidCallback onPressed) => AppButton(
      label: label,
      size: AppButtonSize.md,
      variant: AppButtonVariant.secondary,
      onPressed: onPressed,
    );
    return DemoScaffold(
      title: ExamplesStrings.toastsTitle,
      children: [
        DemoSection(
          title: ExamplesStrings.toastsTones,
          child: DemoPairs(
            children: [
              trigger(
                ExamplesStrings.toastSuccess,
                () => AppSnackbar.success(
                  context,
                  ExamplesStrings.toastSuccessMessage,
                  description: ExamplesStrings.toastSuccessDescription,
                ),
              ),
              trigger(
                ExamplesStrings.toastWarning,
                () => AppSnackbar.warning(
                  context,
                  ExamplesStrings.toastWarningMessage,
                  description: ExamplesStrings.toastWarningDescription,
                ),
              ),
              trigger(
                ExamplesStrings.toastError,
                () => AppSnackbar.error(
                  context,
                  ExamplesStrings.toastErrorMessage,
                  description: ExamplesStrings.toastErrorDescription,
                  actionLabel: ExamplesStrings.toastRetry,
                ),
              ),
              trigger(
                ExamplesStrings.toastInfo,
                () => AppSnackbar.info(
                  context,
                  ExamplesStrings.toastInfoMessage,
                  description: ExamplesStrings.toastInfoDescription,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.toastsVariants,
          child: DemoPairs(
            children: [
              trigger(
                ExamplesStrings.toastWithAction,
                () => AppSnackbar.info(
                  context,
                  ExamplesStrings.toastActionMessage,
                  description: ExamplesStrings.toastActionDescription,
                  actionLabel: ExamplesStrings.toastActionLabel,
                  onAction: () =>
                      AppSnackbar.success(context, ExamplesStrings.toastUndone),
                ),
              ),
              trigger(
                ExamplesStrings.toastTitleOnly,
                () => AppSnackbar.success(
                  context,
                  ExamplesStrings.toastSuccessMessage,
                ),
              ),
              trigger(
                ExamplesStrings.toastNeutral,
                () => AppSnackbar.neutral(
                  context,
                  ExamplesStrings.toastNeutralMessage,
                  actionLabel: ExamplesStrings.toastActionLabel,
                  onAction: () =>
                      AppSnackbar.success(context, ExamplesStrings.toastUndone),
                ),
              ),
              trigger(
                ExamplesStrings.toastFailure,
                () => AppSnackbar.failure(
                  context,
                  ExamplesStrings.toastFailureMessage,
                  description: ExamplesStrings.toastFailureDescription,
                  onRetry: () => AppSnackbar.success(
                    context,
                    ExamplesStrings.toastFailureRetried,
                  ),
                ),
              ),
              trigger(ExamplesStrings.toastStacked, () {
                AppSnackbar.info(
                  context,
                  ExamplesStrings.toastFirst,
                  description: ExamplesStrings.toastStackDescription,
                );
                AppSnackbar.success(
                  context,
                  ExamplesStrings.toastSecond,
                  description: ExamplesStrings.toastStackDescription,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
