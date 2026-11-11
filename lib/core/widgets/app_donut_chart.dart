import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// One slice of [AppDonutChart]. Without a [tone], slices take the chart
/// palette in order.
class AppChartSegment {
  const AppChartSegment({required this.label, required this.value, this.tone});

  final String label;
  final double value;
  final AppTone? tone;
}

/// Donut chart with the total in the centre and a legend below (design
/// system, section 18): a [AppSizes.donutRing] ring of at least three arcs
/// — fewer reads better as a progress bar — and a centre label always
/// present. Colour is never the only cue: every slice is named in the
/// legend.
class AppDonutChart extends StatelessWidget {
  const AppDonutChart({
    super.key,
    required this.segments,
    required this.centerLabel,
    this.centerCaption,
    this.size = AppSizes.chart,
  });

  final List<AppChartSegment> segments;
  final String centerLabel;
  final String? centerCaption;
  final double size;

  static const _palette = [
    AppTone.primary,
    AppTone.success,
    AppTone.alert,
    AppTone.info,
    AppTone.danger,
  ];

  AppTone _toneOf(int i) => segments[i].tone ?? _palette[i % _palette.length];

  @override
  Widget build(BuildContext context) {
    assert(segments.length >= 3, 'A donut needs at least three arcs.');
    final c = context.colors;
    final colors = [
      for (var i = 0; i < segments.length; i++) c.toneForeground(_toneOf(i)),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _DonutPainter(
              [for (final s in segments) s.value],
              colors,
              c.sunken,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    centerLabel,
                    style: AppTypography.title.copyWith(color: c.textPrimary),
                  ),
                  if (centerCaption != null)
                    Text(
                      centerCaption!,
                      style: AppTypography.caption.copyWith(color: c.textMuted),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.sm,
          children: [
            for (var i = 0; i < segments.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSpacing.sm,
                    height: AppSpacing.sm,
                    decoration: BoxDecoration(
                      color: colors[i],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    segments[i].label,
                    style: AppTypography.caption.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.values, this.colors, this.track);

  final List<double> values;
  final List<Color> colors;
  final Color track;

  static const _thickness = AppSizes.donutRing;
  static const _gap = .03;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: min(size.width, size.height) / 2 - _thickness / 2,
    );
    Paint stroke(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _thickness
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, 0, 2 * pi, false, stroke(track));
    final total = values.fold<double>(0, (s, v) => s + max(v, 0));
    if (total == 0) return;
    final visible = values.where((v) => v > 0).length;
    final gap = visible > 1 ? _gap : 0.0;
    var start = -pi / 2;
    for (var i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;
      final sweep = 2 * pi * values[i] / total;
      canvas.drawArc(
        rect,
        start + gap / 2,
        max(sweep - gap, 0),
        false,
        stroke(colors[i]),
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.values != values || old.colors != colors || old.track != track;
}
