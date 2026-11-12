import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Continuous or stepped slider of the design system (section 27): the
/// current value always visible next to the label, the limits below, a
/// ringed handle with a 44px touch target and a halo while pressed.
/// [divisions] makes it snap to steps. [onChanged] `null` disables it.
class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.valueLabel,
    required this.onChanged,
    this.min = 0,
    this.divisions,
    this.showLimits = true,
    this.stepLabels,
  });

  /// Named steps (design system, section 27: Baixa / Média / Alta /
  /// Crítica): snaps to each one and labels every mark below the track.
  factory AppSlider.steps({
    Key? key,
    required String label,
    required List<String> steps,
    required int index,
    required ValueChanged<int>? onChanged,
  }) => AppSlider(
    key: key,
    label: label,
    value: index.toDouble(),
    max: (steps.length - 1).toDouble(),
    divisions: steps.length - 1,
    valueLabel: (v) => steps[v.round().clamp(0, steps.length - 1)],
    onChanged: onChanged == null ? null : (v) => onChanged(v.round()),
    showLimits: false,
    stepLabels: steps,
  );

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;

  /// Formats the value, and the limits: `(v) => '${v.round()}%'`.
  final String Function(double value) valueLabel;
  final ValueChanged<double>? onChanged;
  final bool showLimits;
  final List<String>? stepLabels;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onChanged != null;
    final caption = AppTypography.caption.copyWith(color: c.textMuted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: enabled ? c.textSecondary : c.textDisabled,
                ),
              ),
            ),
            Text(
              valueLabel(value),
              style: AppTypography.label.copyWith(
                color: enabled ? c.textPrimary : c.textDisabled,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: sliderTheme(context, enabled: enabled),
          child: SizedBox(
            height: AppSizes.minTouchTarget,
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              label: valueLabel(value),
              onChanged: onChanged,
            ),
          ),
        ),
        if (stepLabels case final steps?)
          Row(
            children: [
              for (final (i, s) in steps.indexed)
                Expanded(
                  child: Text(
                    s,
                    style: caption,
                    textAlign: i == 0
                        ? TextAlign.start
                        : i == steps.length - 1
                        ? TextAlign.end
                        : TextAlign.center,
                  ),
                ),
            ],
          )
        else if (showLimits)
          Row(
            children: [
              Text(valueLabel(min), style: caption),
              const Spacer(),
              Text(valueLabel(max), style: caption),
            ],
          ),
      ],
    );
  }
}

/// Track, ticks and halo shared by [AppSlider] and [AppRangeSlider].
SliderThemeData sliderTheme(BuildContext context, {required bool enabled}) {
  final c = context.colors;
  final ring = enabled ? c.primary : c.textDisabled;
  return SliderThemeData(
    trackHeight: AppSizes.sliderTrack,
    activeTrackColor: c.primary,
    inactiveTrackColor: c.sunken,
    disabledActiveTrackColor: c.textDisabled,
    disabledInactiveTrackColor: c.sunken,
    thumbColor: c.card,
    disabledThumbColor: c.card,
    overlayColor: c.primary.withValues(alpha: .16),
    activeTickMarkColor: c.onPrimary,
    inactiveTickMarkColor: c.borderStrong,
    disabledActiveTickMarkColor: c.card,
    disabledInactiveTickMarkColor: c.borderStrong,
    thumbShape: _RingThumb(ring),
    rangeThumbShape: _RingRangeThumb(ring),
    overlayShape: const RoundSliderOverlayShape(
      overlayRadius: AppSizes.minTouchTarget / 2,
    ),
    trackShape: const RoundedRectSliderTrackShape(),
    rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
    showValueIndicator: ShowValueIndicator.never,
    padding: EdgeInsets.zero,
  );
}

/// A range between two handles (design system, section 27: "Prazo (dias)
/// 7 – 21"): both ends next to the label, the track filled between them.
class AppRangeSlider extends StatelessWidget {
  const AppRangeSlider({
    super.key,
    required this.label,
    required this.values,
    required this.max,
    required this.valueLabel,
    required this.onChanged,
    this.min = 0,
    this.divisions,
  });

  final String label;
  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double value) valueLabel;
  final ValueChanged<RangeValues>? onChanged;

  static String rangeLabel(String from, String to) =>
      CommonStrings.range(from, to);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onChanged != null;
    final caption = AppTypography.caption.copyWith(color: c.textMuted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: enabled ? c.textSecondary : c.textDisabled,
                ),
              ),
            ),
            Text(
              rangeLabel(valueLabel(values.start), valueLabel(values.end)),
              style: AppTypography.label.copyWith(
                color: enabled ? c.textPrimary : c.textDisabled,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: sliderTheme(context, enabled: enabled),
          child: SizedBox(
            height: AppSizes.minTouchTarget,
            child: RangeSlider(
              values: values,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
        Row(
          children: [
            Text(valueLabel(min), style: caption),
            const Spacer(),
            Text(valueLabel(max), style: caption),
          ],
        ),
      ],
    );
  }
}

/// The handle: a card-coloured disc with a ring in the active colour.
class _RingThumb extends SliderComponentShape {
  const _RingThumb(this.ring);

  final Color ring;

  static double get _ringWidth => AppSizes.sliderRing;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.square(AppSizes.sliderThumb);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final radius = AppSizes.sliderThumb / 2;
    context.canvas
      ..drawCircle(center, radius, Paint()..color = sliderTheme.thumbColor!)
      ..drawCircle(
        center,
        radius - _ringWidth / 2,
        Paint()
          ..color = ring
          ..style = PaintingStyle.stroke
          ..strokeWidth = _ringWidth,
      );
  }
}

class _RingRangeThumb extends RangeSliderThumbShape {
  const _RingRangeThumb(this.ring);

  final Color ring;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.square(AppSizes.sliderThumb);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final radius = AppSizes.sliderThumb / 2;
    context.canvas
      ..drawCircle(center, radius, Paint()..color = sliderTheme.thumbColor!)
      ..drawCircle(
        center,
        radius - _RingThumb._ringWidth / 2,
        Paint()
          ..color = ring
          ..style = PaintingStyle.stroke
          ..strokeWidth = _RingThumb._ringWidth,
      );
  }
}
