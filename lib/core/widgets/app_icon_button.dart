import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// A button that is only an icon (design system, section 10): a 44px
/// square, outlined like the secondary button. [label] is what a screen
/// reader hears and what a long press shows — required, since the icon
/// alone says nothing to someone who cannot see it.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.bordered = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  /// `false` drops the outline (toolbar, top bar).
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: Tooltip(
          message: label,
          excludeFromSemantics: true,
          child: SizedBox.square(
            dimension: AppSizes.minTouchTarget,
            child: AppInteractive(
              onTap: onPressed,
              borderRadius: AppRadius.brMd,
              surface: (state) => (
                color: !enabled
                    ? (bordered ? c.sunken : Colors.transparent)
                    : state.pressed
                    ? c.primarySubtle
                    : bordered
                    ? c.card
                    : Colors.transparent,
                border: !bordered || !enabled
                    ? null
                    : state.pressed
                    ? c.primary
                    : c.borderStrong,
                shadows: const <BoxShadow>[],
              ),
              builder: (context, state) => Center(
                child: Icon(
                  icon,
                  size: AppSizes.iconTopBar,
                  color: !enabled
                      ? c.textDisabled
                      : state.pressed
                      ? c.primary
                      : c.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
