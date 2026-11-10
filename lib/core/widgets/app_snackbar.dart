import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

/// Transient, non-blocking feedback in four tones. Only one is visible at a
/// time: a new one replaces the current. Errors stay longer and always
/// carry a dismiss action.
abstract final class AppSnackbar {
  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    AppTone.success,
    Icons.check_circle_outline,
    message,
    actionLabel,
    onAction,
  );

  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    AppTone.danger,
    Icons.error_outline,
    message,
    actionLabel ?? CommonStrings.close,
    onAction,
  );

  static void warning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    AppTone.alert,
    Icons.warning_amber_outlined,
    message,
    actionLabel,
    onAction,
  );

  static void info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    AppTone.info,
    Icons.info_outline,
    message,
    actionLabel,
    onAction,
  );

  static void _show(
    BuildContext context,
    AppTone tone,
    IconData icon,
    String message,
    String? actionLabel,
    VoidCallback? onAction,
  ) {
    final c = context.colors;
    final fg = c.toneForeground(tone);
    final messenger = ScaffoldMessenger.of(context)..removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: tone == AppTone.danger
            ? AppDurations.toastErrorVisible
            : AppDurations.toastVisible,
        backgroundColor: c.toneBackground(tone),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: BorderSide(color: fg.withValues(alpha: .4)),
        ),
        content: Row(
          children: [
            Icon(icon, color: fg, size: AppSizes.iconTopBar),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppTypography.body.copyWith(color: c.textPrimary),
              ),
            ),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: fg,
                onPressed: onAction ?? messenger.hideCurrentSnackBar,
              ),
      ),
    );
  }
}
