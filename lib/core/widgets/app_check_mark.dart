import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// The 22px box shared by [AppCheckbox] and [AppRadio]: a check on the
/// primary colour when [checked], an empty outlined box otherwise, with an
/// optional label to the right inside a 44px touch target.
class AppCheckMark extends StatelessWidget {
  const AppCheckMark({
    super.key,
    required this.checked,
    required this.onTap,
    required this.circle,
    this.label,
    this.boxKey,
  });

  final bool checked;
  final VoidCallback? onTap;
  final bool circle;
  final String? label;
  final Key? boxKey;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    return AppInteractive(
      onTap: onTap,
      borderRadius: AppRadius.brSm,
      surface: (_) => (
        color: Colors.transparent,
        border: null,
        shadows: const <BoxShadow>[],
      ),
      builder: (context, state) {
        final (Color fill, Color? border) = !enabled
            ? (c.sunken, null)
            : checked
            ? (state.pressed ? c.primaryHover : c.primary, null)
            : (state.pressed ? c.primarySubtle : c.card, c.borderStrong);
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSizes.minTouchTarget,
            minWidth: AppSizes.minTouchTarget,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                key: boxKey,
                duration: AppDurations.toggle,
                width: AppSizes.checkbox,
                height: AppSizes.checkbox,
                decoration: BoxDecoration(
                  color: fill,
                  shape: circle ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: circle ? null : AppRadius.brXs,
                  border: border == null ? null : Border.all(color: border),
                ),
                child: checked
                    ? Icon(
                        Icons.check,
                        size: AppSizes.iconChip,
                        color: enabled ? c.onPrimary : c.textDisabled,
                      )
                    : null,
              ),
              if (label case final label?) ...[
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    label,
                    style: AppTypography.labelMedium.copyWith(
                      color: enabled ? c.textPrimary : c.textDisabled,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
