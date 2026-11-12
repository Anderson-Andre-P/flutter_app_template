import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// Load or repetitions of a set (design system, section 34): a card with
/// the label in CAPS, a large value with its unit, an optional hint
/// ("anterior: 40 kg") and two buttons that step the value down and up.
///
/// The caller owns the arithmetic — the step can change with the value
/// (1 kg up to 5 kg, then 5 kg) — so the card only shows [value] and
/// reports the taps. A `null` callback disables its button (at a limit).
class AppLoadStepper extends StatelessWidget {
  const AppLoadStepper({
    super.key,
    required this.label,
    required this.value,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.onDecrease,
    required this.onIncrease,
    this.unit,
    this.hint,
  });

  final String label;
  final String value;
  final String? unit;
  final String? hint;

  /// What each button shows ("−1", "+1").
  final String decreaseLabel;
  final String increaseLabel;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  static const decreaseKey = ValueKey('app-load-stepper-decrease');
  static const increaseKey = ValueKey('app-load-stepper-increase');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: AppSizes.loadStepper,
      // The card padding never goes below 14 (design system, section 12).
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: c.border),
        boxShadow: context.shadows.elev1,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            liveRegion: true,
            label: label,
            value: unit == null ? value : '$value $unit',
            child: ExcludeSemantics(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: AppTypography.overline.copyWith(color: c.textMuted),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text.rich(
                    TextSpan(
                      text: value,
                      style: AppTypography.metricLg.copyWith(
                        color: c.textPrimary,
                      ),
                      children: [
                        if (unit != null)
                          TextSpan(
                            text: ' $unit',
                            style: AppTypography.label.copyWith(
                              color: c.textMuted,
                            ),
                          ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (hint != null) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              hint!,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: c.textMuted),
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StepButton(
                  key: decreaseKey,
                  text: decreaseLabel,
                  semanticLabel: CommonStrings.decrease,
                  onTap: onDecrease,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StepButton(
                  key: increaseKey,
                  text: increaseLabel,
                  semanticLabel: CommonStrings.increase,
                  onTap: onIncrease,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    super.key,
    required this.text,
    required this.semanticLabel,
    required this.onTap,
  });

  final String text;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        label: semanticLabel,
        child: SizedBox(
          height: AppSizes.field,
          child: AppInteractive(
            onTap: onTap,
            borderRadius: AppRadius.brMd,
            surface: (state) => (
              color: state.pressed ? c.primarySubtle : c.screen,
              border: null,
              shadows: const <BoxShadow>[],
            ),
            builder: (context, _) => Center(
              child: ExcludeSemantics(
                child: Text(
                  text,
                  style: AppTypography.section.copyWith(
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
