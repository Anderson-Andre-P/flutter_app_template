import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_progress_bar.dart';

/// Horizontal stepper of a 3-to-5-step flow the user can go back in —
/// sign-up, survey (design system, section 20). Done steps are checked,
/// [current] is ringed in primary, the rest are muted. When there is no
/// room for the labels, use [AppStepProgress].
class AppStepper extends StatelessWidget {
  const AppStepper({super.key, required this.steps, required this.current});

  final List<String> steps;

  /// Index of the step in progress.
  final int current;

  static String positionLabel(int step, int total, String label) =>
      CommonStrings.stepPosition(step, total, label);

  @override
  Widget build(BuildContext context) {
    assert(
      steps.length >= 3 && steps.length <= 5,
      'A stepper has three to five steps.',
    );
    final c = context.colors;
    return Semantics(
      label: positionLabel(current + 1, steps.length, steps[current]),
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < steps.length; i++)
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: i == 0
                              ? const SizedBox.shrink()
                              : _Line(done: i <= current),
                        ),
                        _Circle(index: i, current: current),
                        Expanded(
                          child: i == steps.length - 1
                              ? const SizedBox.shrink()
                              : _Line(done: i < current),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      steps[i],
                      textAlign: TextAlign.center,
                      style:
                          (i == current
                                  ? AppTypography.captionBold
                                  : AppTypography.caption)
                              .copyWith(
                                color: i == current
                                    ? c.primary
                                    : i < current
                                    ? c.textSecondary
                                    : c.textMuted,
                              ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) => Container(
    height: AppSizes.tabIndicator,
    color: done ? context.colors.primary : context.colors.border,
  );
}

class _Circle extends StatelessWidget {
  const _Circle({required this.index, required this.current});

  final int index;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final done = index < current;
    final active = index == current;
    return Container(
      width: AppSizes.stepCircle,
      height: AppSizes.stepCircle,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? c.primary : c.card,
        border: done
            ? null
            : Border.all(
                color: active ? c.primary : c.borderStrong,
                width: active ? AppSizes.focusRing : 1,
              ),
      ),
      child: done
          ? Icon(Icons.check, size: AppSizes.iconChip, color: c.onPrimary)
          : Text(
              '${index + 1}',
              style: AppTypography.captionBold.copyWith(
                color: active ? c.primary : c.textMuted,
              ),
            ),
    );
  }
}

/// Compact progress of a multi-step flow when the stepper's labels do not
/// fit (design system, section 20): "Passo 2 de 5", a bar and the share.
class AppStepProgress extends StatelessWidget {
  const AppStepProgress({
    super.key,
    required this.current,
    required this.total,
  });

  /// 1-based step in progress.
  final int current;
  final int total;

  static String stepLabel(int step, int total) =>
      CommonStrings.stepOf(step, total);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final share = total == 0 ? 0.0 : current / total;
    return Row(
      children: [
        Flexible(
          child: Text(
            stepLabel(current, total),
            style: AppTypography.caption.copyWith(color: c.textSecondary),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(child: AppProgressBar(value: share)),
        SizedBox(width: AppSpacing.md),
        Text(
          '${(share * 100).round()}%',
          style: AppTypography.captionBold.copyWith(color: c.primary),
        ),
      ],
    );
  }
}
