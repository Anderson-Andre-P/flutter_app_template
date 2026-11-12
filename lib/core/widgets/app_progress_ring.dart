import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Determinate progress as a ring with the percentage in the centre
/// (design system, section 18). Use a spinner only when there is no
/// percentage to show. [value] goes from 0 to 1.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    required this.value,
    this.label,
    this.size,
  });

  final double value;

  /// What is progressing, for screen readers ("Envio").
  final String? label;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? AppSizes.progressRing;
    final c = context.colors;
    final share = value.clamp(0.0, 1.0);
    final percent = '${(share * 100).round()}%';
    return Semantics(
      label: label,
      value: percent,
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _RingPainter(share, c.primary, c.sunken),
            child: Center(
              child: Text(
                percent,
                style: AppTypography.captionBold.copyWith(color: c.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.share, this.color, this.track);

  final double share;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = AppSizes.progressRingStroke;
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
  bool shouldRepaint(_RingPainter old) =>
      old.share != share || old.color != color || old.track != track;
}
