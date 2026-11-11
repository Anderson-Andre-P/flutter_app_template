import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

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
    return Semantics(
      button: true,
      enabled: _enabled,
      child: SizedBox(
        height: _height,
        width: expanded ? double.infinity : null,
        child: AppInteractive(
          onTap: _enabled ? onPressed : null,
          borderRadius: AppRadius.brMd,
          surface: (state) {
            final look = _look(c, state.pressed);
            return (
              color: look.bg,
              border: look.border,
              shadows: variant == AppButtonVariant.primary && _enabled
                  ? context.shadows.elev2
                  : const <BoxShadow>[],
            );
          },
          builder: (context, state) {
            final fg = _look(c, state.pressed).fg;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Center(
                widthFactor: 1,
                child: loading
                    ? SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: fg,
                        ),
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
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Colours per variant (design system, sections 22 and 30). Pressed: a
  /// filled button darkens; an outlined or text one gains the tint of its
  /// colour (the primary tint, or the danger tint for destructive).
  ({Color bg, Color fg, Color? border}) _look(AppColors c, bool pressed) {
    if (!_enabled && !loading) {
      return (bg: c.sunken, fg: c.textDisabled, border: null);
    }
    Color darker(Color tint, Color base) =>
        Color.alphaBlend(tint.withValues(alpha: .08), base);
    return switch (variant) {
      AppButtonVariant.primary => (
        bg: pressed ? c.primaryHover : c.primary,
        fg: c.onPrimary,
        border: null,
      ),
      AppButtonVariant.secondary => (
        bg: pressed ? c.primarySubtle : c.card,
        fg: pressed ? c.primary : c.textPrimary,
        border: pressed ? c.primary : c.borderStrong,
      ),
      AppButtonVariant.outline => (
        bg: pressed ? c.primarySubtle : Colors.transparent,
        fg: c.primary,
        border: c.primary,
      ),
      AppButtonVariant.tonal => (
        bg: pressed ? darker(c.primary, c.primarySubtle) : c.primarySubtle,
        fg: c.primary,
        border: null,
      ),
      AppButtonVariant.ghost => (
        bg: pressed ? c.primarySubtle : Colors.transparent,
        fg: c.link,
        border: null,
      ),
      AppButtonVariant.destructive => (
        bg: pressed ? c.dangerSubtle : Colors.transparent,
        fg: c.danger,
        border: c.danger,
      ),
      AppButtonVariant.destructiveTonal => (
        bg: pressed ? darker(c.danger, c.dangerSubtle) : c.dangerSubtle,
        fg: c.danger,
        border: null,
      ),
    };
  }
}
