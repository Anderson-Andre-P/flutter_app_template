import 'package:flutter/material.dart';

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
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;

  /// Formats the value, and the limits: `(v) => '${v.round()}%'`.
  final String Function(double value) valueLabel;
  final ValueChanged<double>? onChanged;
  final bool showLimits;

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
          data: SliderThemeData(
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
            thumbShape: _RingThumb(enabled ? c.primary : c.textDisabled),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: AppSizes.minTouchTarget / 2,
            ),
            trackShape: const RoundedRectSliderTrackShape(),
            showValueIndicator: ShowValueIndicator.never,
            padding: EdgeInsets.zero,
          ),
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
        if (showLimits)
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

  static const _ringWidth = 2.5;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.square(AppSizes.sliderThumb);

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
    const radius = AppSizes.sliderThumb / 2;
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
