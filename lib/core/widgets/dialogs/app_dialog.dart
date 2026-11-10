import 'package:flutter/material.dart';

import '../../constants/strings/common_strings.dart';
import '../../theme/app_tokens.dart';
import '../../theme/app_typography.dart';
import '../../theme/theme_context.dart';
import '../app_button.dart';

/// Modal dialogs of the design system (max 340px wide, radius `xl`).
abstract final class AppDialog {
  /// Asks for confirmation. Resolves `true` only on the confirm button;
  /// cancel or a tap outside resolves `false`. [destructive] stacks the
  /// buttons with the destructive action on top.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final confirmButton = AppButton(
          label: confirmLabel,
          size: AppButtonSize.md,
          variant: destructive
              ? AppButtonVariant.destructive
              : AppButtonVariant.primary,
          onPressed: () => Navigator.of(ctx).pop(true),
        );
        final cancelButton = AppButton(
          label: cancelLabel ?? CommonStrings.cancel,
          size: AppButtonSize.md,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(ctx).pop(false),
        );
        return _AppDialogFrame(
          title: title,
          message: message,
          actions: destructive
              ? Column(
                  children: [
                    confirmButton,
                    const SizedBox(height: AppSpacing.sm),
                    cancelButton,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: cancelButton),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: confirmButton),
                  ],
                ),
        );
      },
    );
    return result ?? false;
  }

  /// Informs; a single button closes it.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String? okLabel,
  }) => showDialog<void>(
    context: context,
    builder: (ctx) => _AppDialogFrame(
      title: title,
      message: message,
      actions: AppButton(
        label: okLabel ?? CommonStrings.ok,
        size: AppButtonSize.md,
        onPressed: () => Navigator.of(ctx).pop(),
      ),
    ),
  );
}

class _AppDialogFrame extends StatelessWidget {
  const _AppDialogFrame({
    required this.title,
    required this.message,
    required this.actions,
  });

  final String title;
  final String message;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.x2l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.modalMaxWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x2l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: AppTypography.section.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.x2l),
              actions,
            ],
          ),
        ),
      ),
    );
  }
}
