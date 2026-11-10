import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Button hierarchy of the design system — exactly one [primary] per screen.
enum AppButtonVariant {
  /// Concludes the screen's task.
  primary,

  /// Legitimate alternative to the primary (discard, back).
  secondary,

  /// Same-weight action repeated on the screen.
  outline,

  /// Frequent, low-risk action inside a card.
  tonal,

  /// Tertiary or reversible action.
  ghost,

  /// Irreversible action — always confirmed in a dialog.
  destructive,

  /// Destructive action at the end of a settings list (e.g. sign out):
  /// danger text on the danger-subtle surface, no border.
  destructiveTonal,
}

enum AppButtonSize { sm, md, lg }

/// The design-system button. [onPressed] `null` or [loading] disables it.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.icon,
    this.loading = false,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool loading;

  /// Fills the available width.
  final bool expanded;

  bool get _enabled => onPressed != null && !loading;

  double get _height => switch (size) {
    AppButtonSize.lg => AppSizes.buttonLg,
    AppButtonSize.md => AppSizes.buttonMd,
    AppButtonSize.sm => AppSizes.buttonSm,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (Color bg, Color fg, Color? border) = !_enabled && !loading
        ? (c.sunken, c.textDisabled, null)
        : switch (variant) {
            AppButtonVariant.primary => (c.primary, c.onPrimary, null),
            AppButtonVariant.secondary => (
              c.card,
              c.textPrimary,
              c.borderStrong,
            ),
            AppButtonVariant.outline => (
              Colors.transparent,
              c.primary,
              c.primary,
            ),
            AppButtonVariant.tonal => (c.primarySubtle, c.primary, null),
            AppButtonVariant.ghost => (Colors.transparent, c.link, null),
            AppButtonVariant.destructive => (
              Colors.transparent,
              c.danger,
              c.danger,
            ),
            AppButtonVariant.destructiveTonal => (
              c.dangerSubtle,
              c.danger,
              null,
            ),
          };
    final pressed = variant == AppButtonVariant.primary
        ? c.primaryHover
        : fg.withValues(alpha: .08);
    final shadows = variant == AppButtonVariant.primary && _enabled
        ? context.shadows.elev2
        : const <BoxShadow>[];

    final content = loading
        ? SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconField, color: fg),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(color: fg),
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: _enabled,
      child: SizedBox(
        height: _height,
        width: expanded ? double.infinity : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.brMd,
            boxShadow: shadows,
          ),
          child: Material(
            color: bg,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.brMd,
              side: border == null
                  ? BorderSide.none
                  : BorderSide(color: border),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: _enabled ? onPressed : null,
              highlightColor: pressed,
              splashColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Center(widthFactor: 1, child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
