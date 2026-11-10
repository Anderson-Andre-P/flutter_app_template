import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Every snackbar tone, plus one with an action and one with long text.
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
                ),
              ),
              trigger(
                ExamplesStrings.toastWarning,
                () => AppSnackbar.warning(
                  context,
                  ExamplesStrings.toastWarningMessage,
                ),
              ),
              trigger(
                ExamplesStrings.toastError,
                () => AppSnackbar.error(
                  context,
                  ExamplesStrings.toastErrorMessage,
                ),
              ),
              trigger(
                ExamplesStrings.toastInfo,
                () =>
                    AppSnackbar.info(context, ExamplesStrings.toastInfoMessage),
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
                  actionLabel: ExamplesStrings.toastActionLabel,
                  onAction: () =>
                      AppSnackbar.success(context, ExamplesStrings.toastUndone),
                ),
              ),
              trigger(
                ExamplesStrings.toastLong,
                () =>
                    AppSnackbar.info(context, ExamplesStrings.toastLongMessage),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
