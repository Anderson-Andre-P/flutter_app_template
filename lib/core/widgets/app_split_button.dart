import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// A default action with a menu of variations (design system, section 10:
/// "Exportar ▾"). The label runs [onPressed]; the chevron runs [onMenu]
/// (open a menu or a bottom sheet) and is read as [menuLabel].
class AppSplitButton extends StatelessWidget {
  const AppSplitButton({
    super.key,
    required this.label,
    required this.menuLabel,
    required this.onPressed,
    required this.onMenu,
  });

  final String label;
  final String menuLabel;
  final VoidCallback? onPressed;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    AppSurface surface(bool enabled, AppInteraction state) => (
      color: !enabled
          ? c.sunken
          : state.pressed
          ? c.primaryHover
          : c.primary,
      border: null,
      shadows: const <BoxShadow>[],
    );
    Color fg(bool enabled) => enabled ? c.onPrimary : c.textDisabled;
    final radius = Radius.circular(AppRadius.md);
    return SizedBox(
      height: AppSizes.buttonMd,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.brMd,
          boxShadow: onPressed == null
              ? const <BoxShadow>[]
              : context.shadows.elev2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              enabled: onPressed != null,
              child: AppInteractive(
                onTap: onPressed,
                borderRadius: BorderRadius.horizontal(left: radius),
                surface: (state) => surface(onPressed != null, state),
                builder: (context, state) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      label,
                      style: AppTypography.label.copyWith(
                        color: fg(onPressed != null),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppSizes.hairline,
              child: ColoredBox(color: c.onPrimary.withValues(alpha: .3)),
            ),
            Semantics(
              button: true,
              enabled: onMenu != null,
              label: menuLabel,
              child: AppInteractive(
                onTap: onMenu,
                borderRadius: BorderRadius.horizontal(right: radius),
                surface: (state) => surface(onMenu != null, state),
                builder: (context, state) => SizedBox(
                  width: AppSizes.minTouchTarget,
                  child: Icon(
                    Icons.expand_more,
                    size: AppSizes.iconTopBar,
                    color: fg(onMenu != null),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
