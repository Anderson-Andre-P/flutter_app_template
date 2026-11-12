import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_button.dart';

/// Icon, short title, one sentence with the next step, at most one action.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _StateLayout(
      icon: icon,
      iconColor: c.primary,
      iconBackground: c.primarySubtle,
      title: title,
      message: message,
      action: actionLabel == null
          ? null
          : AppButton(
              label: actionLabel!,
              onPressed: onAction,
              size: AppButtonSize.md,
              expanded: false,
            ),
    );
  }
}

/// Load failure: never blames the user, always offers a retry.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.code,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  /// Error code the user can quote to support ("ERR-503"), appended to the
  /// message.
  final String? code;

  /// A secondary action, shown as a link below the retry ("Reportar
  /// problema").
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _StateLayout(
      icon: Icons.error_outline,
      iconColor: c.danger,
      iconBackground: c.dangerSubtle,
      title: title,
      message: code == null
          ? message
          : '$message ${CommonStrings.errorCode(code!)}',
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: retryLabel,
            onPressed: onRetry,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.md,
            expanded: false,
          ),
          if (secondaryLabel case final label?) ...[
            SizedBox(height: AppSpacing.xs),
            AppButton(
              label: label,
              onPressed: onSecondary,
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.sm,
              expanded: false,
            ),
          ],
        ],
      ),
    );
  }
}

/// No connection (design system, section 24): what was done is safe on the
/// device and syncs later; [pending] says how much is waiting.
class AppOfflineView extends StatelessWidget {
  const AppOfflineView({
    super.key,
    required this.pending,
    this.title = CommonStrings.offlineTitle,
    this.message = CommonStrings.offlineMessage,
  });

  final int pending;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _StateLayout(
      icon: Icons.cloud_off_outlined,
      iconColor: c.alertText,
      iconBackground: c.alertSubtle,
      title: title,
      message: message,
      action: pending == 0
          ? null
          : Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: c.alertSubtle,
                borderRadius: AppRadius.brMd,
              ),
              child: Text(
                CommonStrings.pendingChanges(pending),
                textAlign: TextAlign.center,
                style: AppTypography.label.copyWith(color: c.alertText),
              ),
            ),
    );
  }
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.x2l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.avatarXl,
            height: AppSizes.avatarXl,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: AppSizes.icon + 4),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.section.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: c.textSecondary),
          ),
          if (action != null) ...[SizedBox(height: AppSpacing.x2l), action!],
        ],
      ),
    );
  }
}
