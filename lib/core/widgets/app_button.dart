import 'package:material_ui/material_ui.dart';

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

  /// Positive alternative of the same weight (e.g. "Aprovar").
  outlineSuccess,

  /// Frequent, low-risk action inside a card.
  tonal,

  /// Tertiary or reversible action.
  ghost,

  /// Irreversible action — always confirmed in a dialog.
  destructive,

  /// Concludes a task with a positive outcome ("Concluir", "Aprovar").
  success,

  /// Destructive action at the end of a settings list (e.g. sign out):
  /// danger text on the danger-subtle surface, no border.
  destructiveTonal,
}

/// xs: action inside a table row · sm: action chip, filter bar ·
/// md: form default · lg: the screen's primary · xl: isolated call to
/// action, onboarding.
enum AppButtonSize { xs, sm, md, lg, xl }

/// The design-system button. [onPressed] `null` or [loading] disables it.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Before the label.
  final IconData? icon;

  /// After the label, for actions that move forward ("Avançar →").
  final IconData? trailingIcon;
  final bool loading;

  /// Fills the available width.
  final bool expanded;

  bool get _enabled => onPressed != null && !loading;

  double get _height => switch (size) {
    AppButtonSize.xl => AppSizes.buttonXl,
    AppButtonSize.lg => AppSizes.buttonLg,
    AppButtonSize.md => AppSizes.buttonMd,
    AppButtonSize.sm => AppSizes.buttonSm,
    AppButtonSize.xs => AppSizes.buttonXs,
  };

  double get _padding => switch (size) {
    AppButtonSize.xl => AppSpacing.x2l,
    AppButtonSize.xs => AppSpacing.md,
    _ => AppSpacing.lg,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: _enabled,
        // The visual height is the size's; the touch target never goes below
        // 44 (AppInteractive pads the smaller sizes invisibly).
        child: SizedBox(
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
              // A minimum, so large text grows the button instead of being
              // cut.
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: _height),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: _padding),
                  child: Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: loading
                        ? SizedBox.square(
                            dimension: AppSizes.spinner,
                            child: CircularProgressIndicator(
                              strokeWidth: AppSizes.focusRing,
                              color: fg,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (icon != null) ...[
                                Icon(icon, size: AppSizes.iconField, color: fg),
                                SizedBox(width: AppSpacing.sm),
                              ],
                              Flexible(
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.label.copyWith(
                                    color: fg,
                                  ),
                                ),
                              ),
                              if (trailingIcon != null) ...[
                                SizedBox(width: AppSpacing.sm),
                                Icon(
                                  trailingIcon,
                                  size: AppSizes.iconField,
                                  color: fg,
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
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
      AppButtonVariant.outlineSuccess => (
        bg: pressed ? c.successSubtle : Colors.transparent,
        fg: c.success,
        border: c.success,
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
      AppButtonVariant.success => (
        bg: pressed ? _darken(c.success) : c.success,
        fg: c.onPrimary,
        border: null,
      ),
      AppButtonVariant.destructiveTonal => (
        bg: pressed ? darker(c.danger, c.dangerSubtle) : c.dangerSubtle,
        fg: c.danger,
        border: null,
      ),
    };
  }

  /// "Pressed darkens the fill by 8%" (design system, section 22).
  static Color _darken(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - .08).clamp(0, 1)).toColor();
  }
}
