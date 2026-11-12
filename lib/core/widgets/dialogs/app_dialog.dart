import 'package:material_ui/material_ui.dart';

import '../../constants/strings/common_strings.dart';
import '../../theme/app_tokens.dart';
import '../../theme/app_typography.dart';
import '../../theme/theme_context.dart';
import '../app_button.dart';
import '../app_button_group.dart';
import '../app_icon_button.dart';
import '../app_tone.dart';

/// Modal dialogs of the design system (max 340px wide, radius `xl`).
abstract final class AppDialog {
  /// Asks for confirmation. Resolves `true` only on the confirm button;
  /// cancel or a tap outside resolves `false`.
  ///
  /// [destructive] follows the design system's destructive dialog: an icon
  /// on a danger tint at the top ([icon], a warning by default), then the
  /// destructive action at full width with Cancelar below it. [icon] on a
  /// plain confirm shows it on the brand tint.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool destructive = false,
    IconData? icon,
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
          icon: destructive ? icon ?? Icons.warning_amber_rounded : icon,
          tone: destructive ? AppTone.danger : AppTone.primary,
          actions: destructive
              ? Column(
                  children: [
                    confirmButton,
                    SizedBox(height: AppSpacing.sm),
                    cancelButton,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: cancelButton),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(child: confirmButton),
                  ],
                ),
        );
      },
    );
    return result ?? false;
  }

  /// A decision with context (design system, section 21): the [icon] on
  /// the brand tint beside a title of at most two lines, a × to close, and
  /// Cancelar / [confirmLabel] side by side. Resolves `true` only on the
  /// confirm button.
  static Future<bool> modal(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final c = ctx.colors;
        return Dialog(
          insetPadding: EdgeInsets.all(AppSpacing.x2l),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppSizes.modalMaxWidth),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSizes.dialogIcon,
                        height: AppSizes.dialogIcon,
                        decoration: BoxDecoration(
                          color: c.primarySubtle,
                          borderRadius: AppRadius.brMdPlus,
                        ),
                        child: Icon(
                          icon,
                          size: AppSizes.iconTopBar,
                          color: c.primary,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.section.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Text(
                              message,
                              style: AppTypography.bodySmall.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppIconButton(
                        icon: Icons.close,
                        label: CommonStrings.close,
                        bordered: false,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.x2l),
                  AppButtonGroup.pair(
                    secondary: AppButton(
                      label: cancelLabel ?? CommonStrings.cancel,
                      size: AppButtonSize.md,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.of(ctx).pop(false),
                    ),
                    primary: AppButton(
                      label: confirmLabel,
                      size: AppButtonSize.md,
                      onPressed: () => Navigator.of(ctx).pop(true),
                    ),
                  ),
                ],
              ),
            ),
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
    this.icon,
    this.tone = AppTone.primary,
  });

  final String title;
  final String message;
  final Widget actions;
  final IconData? icon;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Dialog(
      insetPadding: EdgeInsets.all(AppSpacing.x2l),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppSizes.modalMaxWidth),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.x2l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (icon case final icon?) ...[
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    width: AppSizes.dialogIcon,
                    height: AppSizes.dialogIcon,
                    decoration: BoxDecoration(
                      color: c.toneBackground(tone),
                      borderRadius: AppRadius.brMdPlus,
                    ),
                    child: Icon(
                      icon,
                      size: AppSizes.iconTopBar,
                      color: c.toneForeground(tone),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
              ],
              Text(
                title,
                style: AppTypography.section.copyWith(color: c.textPrimary),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
              SizedBox(height: AppSpacing.x2l),
              actions,
            ],
          ),
        ),
      ),
    );
  }
}
