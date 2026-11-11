import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// A card-sized option of a single-choice group — payment method, plan,
/// delivery (design system, section 10). The selected card gets the
/// primary border and the tonal fill, and its round mark is checked.
/// Selected when [value] equals [groupValue].
class AppOptionCard<T> extends StatelessWidget {
  const AppOptionCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final selected = value == groupValue;
    final enabled = onChanged != null;
    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        enabled: enabled,
        child: AppInteractive(
          onTap: enabled ? () => onChanged!(value) : null,
          borderRadius: AppRadius.brMdPlus,
          surface: (state) => (
            color: !enabled
                ? c.sunken
                : selected || state.pressed
                ? c.primarySubtle
                : c.card,
            border: selected ? c.primary : c.border,
            shadows: const <BoxShadow>[],
          ),
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: AppSizes.iconBox,
                  height: AppSizes.iconBox,
                  decoration: BoxDecoration(
                    color: selected ? c.card : c.sunken,
                    borderRadius: AppRadius.brMd,
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconTopBar,
                    color: selected ? c.primary : c.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTypography.labelMedium.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      if (subtitle case final subtitle?) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle,
                          style: AppTypography.caption.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                AnimatedContainer(
                  duration: AppDurations.toggle,
                  width: AppSizes.checkbox,
                  height: AppSizes.checkbox,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? c.primary : c.card,
                    border: selected ? null : Border.all(color: c.borderStrong),
                  ),
                  child: selected
                      ? Icon(
                          Icons.check,
                          size: AppSizes.iconChip,
                          color: c.onPrimary,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
