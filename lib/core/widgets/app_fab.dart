import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// Floating action button (design system, section 09): the screen's main
/// creation action. Round (58px, icon only — [label] is read by screen
/// readers) or [extended] (52px high, icon and label: "+ Novo").
class AppFab extends StatelessWidget {
  const AppFab({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.extended = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    final fg = enabled ? c.onPrimary : c.textDisabled;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: extended ? null : label,
        child: SizedBox(
          width: extended ? null : AppSizes.fab,
          height: extended ? AppSizes.fabExtended : AppSizes.fab,
          child: AppInteractive(
            onTap: onPressed,
            borderRadius: AppRadius.brLg,
            surface: (state) => (
              color: !enabled
                  ? c.sunken
                  : state.pressed
                  ? c.primaryHover
                  : c.primary,
              border: null,
              shadows: enabled ? context.shadows.elev2 : const <BoxShadow>[],
            ),
            builder: (context, state) => extended
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.x2l),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: AppSizes.icon, color: fg),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          label,
                          style: AppTypography.label.copyWith(color: fg),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Icon(icon, size: AppSizes.icon, color: fg),
                  ),
          ),
        ),
      ),
    );
  }
}
