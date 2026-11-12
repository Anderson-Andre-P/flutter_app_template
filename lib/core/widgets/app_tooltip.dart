import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Short explanation of something that cannot speak for itself — why a
/// control is locked (design system, section 21: "Bloqueado após
/// iniciar"). On a phone it opens with a tap, on a dark ink bubble above.
class AppTooltip extends StatelessWidget {
  const AppTooltip({super.key, required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      preferBelow: false,
      decoration: BoxDecoration(
        // Ink in both themes: the text colour of light, the deepest surface
        // of dark.
        color: dark ? c.raised : c.textPrimary,
        borderRadius: AppRadius.brSm,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      textStyle: AppTypography.caption.copyWith(
        color: dark ? c.textPrimary : c.card,
      ),
      child: child,
    );
  }
}
