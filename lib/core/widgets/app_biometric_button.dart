import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// Sign in with the device's biometrics (design system, section 10): a
/// card with the icon on the primary tint above the label ("Touch ID",
/// "Face ID"). Usually two side by side under the "ou" divider.
class AppBiometricButton extends StatelessWidget {
  const AppBiometricButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        child: AppInteractive(
          onTap: onPressed,
          borderRadius: AppRadius.brLg,
          surface: (state) => (
            color: !enabled
                ? c.sunken
                : state.pressed
                ? c.primarySubtle
                : c.card,
            border: state.pressed ? c.primary : c.border,
            shadows: const <BoxShadow>[],
          ),
          builder: (context, state) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSizes.avatarMd + AppSpacing.xs,
                  height: AppSizes.avatarMd + AppSpacing.xs,
                  decoration: BoxDecoration(
                    color: c.primarySubtle,
                    borderRadius: AppRadius.brSm,
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconField,
                    color: enabled ? c.primary : c.textDisabled,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: enabled ? c.textPrimary : c.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
