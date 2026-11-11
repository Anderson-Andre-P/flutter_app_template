import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// Compact − value + for tables and dense rows (design system, section 34):
/// 32px buttons, each inside a 44px touch target. Each step is one; the
/// button at a limit is disabled. Outside a table, use `AppNumberStepper`.
class AppMiniStepper extends StatelessWidget {
  const AppMiniStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  /// What is counted, for screen readers ("Séries").
  final String label;
  final int value;
  final int min;
  final int max;

  /// `null` disables both buttons.
  final ValueChanged<int>? onChanged;

  static const decreaseKey = ValueKey('app-mini-stepper-decrease');
  static const increaseKey = ValueKey('app-mini-stepper-increase');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final change = onChanged;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniButton(
          key: decreaseKey,
          icon: Icons.remove,
          label: CommonStrings.decrease,
          onTap: change == null || value <= min
              ? null
              : () => change(value - 1),
        ),
        SizedBox(
          width: AppSizes.miniStepperValue,
          child: Semantics(
            liveRegion: true,
            label: label,
            value: '$value',
            child: ExcludeSemantics(
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: AppTypography.label.copyWith(color: c.textPrimary),
              ),
            ),
          ),
        ),
        _MiniButton(
          key: increaseKey,
          icon: Icons.add,
          label: CommonStrings.increase,
          onTap: change == null || value >= max
              ? null
              : () => change(value + 1),
        ),
      ],
    );
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        // The whole 44px square is tappable; only the 32px box is drawn.
        child: SizedBox.square(
          dimension: AppSizes.minTouchTarget,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Center(
              child: SizedBox.square(
                dimension: AppSizes.miniStepperButton,
                child: AppInteractive(
                  onTap: onTap,
                  borderRadius: AppRadius.brSmPlus,
                  surface: (state) => (
                    color: state.pressed ? c.primarySubtle : c.screen,
                    border: null,
                    shadows: const <BoxShadow>[],
                  ),
                  builder: (context, _) => Icon(
                    icon,
                    size: AppSizes.iconField,
                    color: enabled ? c.textPrimary : c.textDisabled,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
