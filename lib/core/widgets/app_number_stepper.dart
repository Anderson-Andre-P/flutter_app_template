import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_icon_button.dart';

/// Small exact quantity (design system, section 27): − value +, each step
/// is one, the button at a limit is disabled. Up to 99 — above that use a
/// numeric field.
class AppNumberStepper extends StatelessWidget {
  const AppNumberStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.compact = false,
  });

  final String label;
  final int value;
  final int min;
  final int max;

  /// `null` disables both buttons.
  final ValueChanged<int>? onChanged;

  /// Hides the label above (it is still read to screen readers) — inside a
  /// card next to the button it controls.
  final bool compact;

  static const maxValue = 99;

  @override
  Widget build(BuildContext context) {
    assert(max <= maxValue, 'Above $maxValue use a numeric field.');
    final c = context.colors;
    final change = onChanged;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!compact) ...[
          Text(
            label,
            style: AppTypography.label.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Container(
          width: AppSizes.numberStepper,
          height: AppSizes.minTouchTarget,
          decoration: BoxDecoration(
            color: c.field,
            borderRadius: AppRadius.brMd,
          ),
          // Over the buttons, so they keep their full 44px.
          foregroundDecoration: BoxDecoration(
            borderRadius: AppRadius.brMd,
            border: Border.all(color: c.borderStrong),
          ),
          child: Row(
            children: [
              AppIconButton(
                icon: Icons.remove,
                label: CommonStrings.decrease,
                bordered: false,
                onPressed: change == null || value <= min
                    ? null
                    : () => change(value - 1),
              ),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  label: label,
                  value: '$value',
                  child: ExcludeSemantics(
                    child: Text(
                      '$value',
                      textAlign: TextAlign.center,
                      style: AppTypography.section.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              AppIconButton(
                icon: Icons.add,
                label: CommonStrings.increase,
                bordered: false,
                onPressed: change == null || value >= max
                    ? null
                    : () => change(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
