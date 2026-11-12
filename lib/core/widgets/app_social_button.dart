import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// Sign in with an identity provider (design system, section 10): 48px,
/// the provider's mark in a neutral box on the left, the label always
/// "Continuar com …" and a chevron. Never paint the whole button in the
/// provider's colour. [mark] is the provider's initial; pass [markWidget]
/// for a logo asset instead.
class AppSocialButton extends StatelessWidget {
  const AppSocialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.mark,
    this.markWidget,
  }) : assert(mark != null || markWidget != null, 'Give a mark or a logo');

  final String label;
  final VoidCallback? onPressed;
  final String? mark;
  final Widget? markWidget;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        child: SizedBox(
          height: AppSizes.socialButton,
          child: AppInteractive(
            onTap: onPressed,
            borderRadius: AppRadius.brMd,
            surface: (state) => (
              color: !enabled
                  ? c.sunken
                  : state.pressed
                  ? c.primarySubtle
                  : c.card,
              border: state.pressed ? c.primary : c.borderStrong,
              shadows: const <BoxShadow>[],
            ),
            builder: (context, state) => Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Container(
                      width: AppSizes.avatarSm + AppSpacing.xs,
                      height: AppSizes.avatarSm + AppSpacing.xs,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: c.sunken,
                        borderRadius: AppRadius.brXs,
                        border: Border.all(color: c.border),
                      ),
                      child:
                          markWidget ??
                          Text(
                            mark!,
                            style: AppTypography.labelMedium.copyWith(
                              color: c.textSecondary,
                            ),
                          ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.body.copyWith(
                        color: enabled ? c.textPrimary : c.textDisabled,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: AppSizes.iconTopBar,
                    color: c.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
