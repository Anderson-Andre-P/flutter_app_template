import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Line chart with a soft area fill, scaled from 0 to the largest value.
/// The last point is marked. Optional [labels] go under the line, evenly
/// spaced.
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    super.key,
    required this.values,
    this.labels = const [],
    this.height,
  });

  final List<double> values;
  final List<String> labels;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final height = this.height ?? AppSizes.chart;
    final c = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: _LinePainter(values, c)),
        ),
        if (labels.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final l in labels)
                Expanded(
                  child: Text(
                    l,
                    textAlign: TextAlign.center,
                    style: AppTypography.micro.copyWith(color: c.textMuted),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.values, this.colors);

  final List<double> values;
  final AppColors colors;

  static double get _stroke => AppSizes.chartStroke;
  static double get _dot => AppSizes.chartDot;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final max = values.fold<double>(0, (m, v) => v > m ? v : m);
    final top = _dot + _stroke;
    final usable = size.height - top * 2;
    // Inset by the marker so the last point is never clipped at the edge.
    final side = _dot + _stroke;
    final width = size.width - side * 2;
    Offset at(int i) => Offset(
      values.length == 1
          ? size.width / 2
          : side + width * i / (values.length - 1),
      top + usable * (1 - (max == 0 ? 0 : values[i] / max)),
    );

    final line = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      line.lineTo(at(i).dx, at(i).dy);
    }
    final area = Path.from(line)
      ..lineTo(at(values.length - 1).dx, size.height)
      ..lineTo(at(0).dx, size.height)
      ..close();

    canvas
      ..drawPath(area, Paint()..color = colors.primarySubtle)
      ..drawPath(
        line,
        Paint()
          ..color = colors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = _stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
    final last = at(values.length - 1);
    canvas
      ..drawCircle(last, _dot + _stroke, Paint()..color = colors.card)
      ..drawCircle(last, _dot, Paint()..color = colors.primary);
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.values != values || old.colors != colors;
}
