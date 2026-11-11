import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// On/off switch of the design system (section 09): a 46x26 track with a
/// 20px knob, inside a 44px touch target. [label], when given, sits to the
/// right and is part of the target. [onChanged] `null` disables it.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  static const trackKey = ValueKey('app-switch-track');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onChanged != null;
    return MergeSemantics(
      child: Semantics(
        toggled: value,
        enabled: enabled,
        child: AppInteractive(
          onTap: enabled ? () => onChanged!(!value) : null,
          borderRadius: AppRadius.brSm,
          surface: (_) => (
            color: Colors.transparent,
            border: null,
            shadows: const <BoxShadow>[],
          ),
          builder: (context, state) {
            final track = !enabled
                ? c.sunken
                : !value
                ? c.borderStrong
                : state.pressed
                ? c.primaryHover
                : c.primary;
            return ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
                minWidth: AppSizes.minTouchTarget,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    key: trackKey,
                    duration: AppDurations.toggle,
                    width: AppSizes.switchWidth,
                    height: AppSizes.switchHeight,
                    padding: const EdgeInsets.all(AppSizes.switchInset),
                    decoration: BoxDecoration(
                      color: track,
                      borderRadius: AppRadius.brFull,
                    ),
                    child: AnimatedAlign(
                      duration: AppDurations.toggle,
                      alignment: value
                          ? AlignmentDirectional.centerEnd
                          : AlignmentDirectional.centerStart,
                      child: Container(
                        width: AppSizes.switchKnob,
                        height: AppSizes.switchKnob,
                        decoration: BoxDecoration(
                          color: c.card,
                          shape: BoxShape.circle,
                          boxShadow: context.shadows.elev1,
                        ),
                      ),
                    ),
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
        ),
      ),
    );
  }
}
