import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Countdown of a timed step — rest, interval, hold (design system,
/// section 37): a ring that empties as time runs out, the time large in the
/// centre, a label in CAPS above it and a [caption] below ("de 1:30").
///
/// [value] goes from 1 (full) to 0 (over); the caller ticks it and formats
/// [time]. Three sizes: [AppSizes.countdownLg] (the step fills the screen),
/// [AppSizes.countdownMd] (inside a card) and [AppSizes.countdownSm]
/// (beside other content — there the icon is left out).
class AppCountdownRing extends StatelessWidget {
  const AppCountdownRing({
    super.key,
    required this.value,
    required this.time,
    this.label,
    this.caption,
    this.icon,
    this.size,
  });

  final double value;
  final String time;
  final String? label;
  final String? caption;
  final IconData? icon;
  final double? size;

  /// The time's font as a share of the side (64 on 248).
  static const _timeShare = .26;

  /// Tight line height, so the large time hugs the label and caption.
  static const _timeHeight = 1.1;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? AppSizes.countdownLg;
    final c = context.colors;
    final share = value.clamp(0.0, 1.0);
    final compact = size < AppSizes.countdownMd;
    final stroke = size * AppSizes.countdownStrokeShare;
    // Keeps the text off the ring: one stroke of clear space inside it.
    final inset = stroke * 2;
    return Semantics(
      label: label,
      value: caption == null ? time : '$time $caption',
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _CountdownPainter(share, c.primary, c.border, stroke),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(inset),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null && !compact) ...[
                        Icon(icon, size: AppSizes.icon, color: c.primary),
                        SizedBox(height: AppSpacing.xs),
                      ],
                      if (label != null)
                        Text(
                          label!.toUpperCase(),
                          style:
                              (compact
                                      ? AppTypography.overlineRegular
                                      : AppTypography.overline)
                                  .copyWith(color: c.textMuted),
                        ),
                      Text(
                        time,
                        style: AppTypography.display.copyWith(
                          fontSize: size * _timeShare,
                          height: _timeHeight,
                          color: c.textPrimary,
                        ),
                      ),
                      if (caption != null)
                        Text(
                          caption!,
                          style:
                              (compact
                                      ? AppTypography.micro
                                      : AppTypography.body)
                                  .copyWith(color: c.textMuted),
                        ),
                    ],
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

class _CountdownPainter extends CustomPainter {
  _CountdownPainter(this.share, this.color, this.track, this.stroke);

  final double share;
  final Color color;
  final Color track;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: min(size.width, size.height) / 2 - stroke / 2,
    );
    Paint paint(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * pi, false, paint(track));
    if (share > 0) {
      canvas.drawArc(rect, -pi / 2, 2 * pi * share, false, paint(color));
    }
  }

  @override
  bool shouldRepaint(_CountdownPainter old) =>
      old.share != share ||
      old.color != color ||
      old.track != track ||
      old.stroke != stroke;
}
