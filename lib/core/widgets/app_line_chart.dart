import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Line chart with a soft area fill, scaled from 0 to the largest value.
/// The last point is marked. Optional [labels] go under the line, evenly
/// spaced.
///
/// With [valueLabel], every point is marked and carries its value, formatted
/// by it ("82,4"), as in the design system's line chart (section 37).
/// [startAtZero] `false` fits the scale to the values instead: a weight that
/// moves from 84 to 79 kg would be an almost flat line on a 0 to 84 scale.
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    super.key,
    required this.values,
    this.labels = const [],
    this.height,
    this.valueLabel,
    this.startAtZero = true,
  });

  final List<double> values;
  final List<String> labels;
  final double? height;
  final String Function(double value)? valueLabel;
  final bool startAtZero;

  /// Room left above and below the values when the scale fits them, as a
  /// share of their spread.
  static const _fitMargin = .2;

  /// The bottom and top of the scale for [values].
  static (double, double) range(
    List<double> values, {
    bool startAtZero = true,
  }) {
    if (values.isEmpty) return (0, 0);
    final high = values.reduce((a, b) => a > b ? a : b);
    if (startAtZero) return (0, high < 0 ? 0 : high);
    final low = values.reduce((a, b) => a < b ? a : b);
    // One value, or all equal: centre the line.
    final margin = high == low
        ? (high.abs() + 1) * _fitMargin
        : (high - low) * _fitMargin;
    return (low - margin, high + margin);
  }

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
          child: CustomPaint(
            painter: _LinePainter(
              values,
              range(values, startAtZero: startAtZero),
              c,
              valueLabel,
              AppTypography.microBold.copyWith(color: c.textSecondary),
              MediaQuery.textScalerOf(context),
            ),
          ),
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
  _LinePainter(
    this.values,
    this.range,
    this.colors,
    this.valueLabel,
    this.labelStyle,
    this.textScaler,
  );

  final List<double> values;
  final (double, double) range;
  final AppColors colors;
  final String Function(double value)? valueLabel;
  final TextStyle labelStyle;
  final TextScaler textScaler;

  static double get _stroke => AppSizes.chartStroke;
  static double get _dot => AppSizes.chartDot;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final (low, high) = range;
    final span = high - low;
    final format = valueLabel;
    TextPainter? text(double v) => format == null
        ? null
        : (TextPainter(
            text: TextSpan(text: format(v), style: labelStyle),
            textDirection: TextDirection.ltr,
            textScaler: textScaler,
          )..layout());
    // Room above the points for their values (and as much below, so the
    // line stays centred).
    final room = format == null
        ? 0.0
        : text(values.first)!.height + AppSpacing.xs;
    final top = _dot + _stroke + room;
    final usable = size.height - top * 2;
    // Inset by the marker so the last point is never clipped at the edge.
    final side = _dot + _stroke;
    final width = size.width - side * 2;
    Offset at(int i) => Offset(
      values.length == 1
          ? size.width / 2
          : side + width * i / (values.length - 1),
      top + usable * (1 - (span == 0 ? 0 : (values[i] - low) / span)),
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
    void mark(Offset p) => canvas
      ..drawCircle(p, _dot + _stroke, Paint()..color = colors.card)
      ..drawCircle(p, _dot, Paint()..color = colors.primary);
    mark(at(values.length - 1));
    if (format == null) return;
    final gap = _dot + _stroke + AppSpacing.xxs;
    for (var i = 0; i < values.length; i++) {
      final p = at(i);
      mark(p);
      final painter = text(values[i])!;
      final x = (p.dx - painter.width / 2).clamp(
        0.0,
        size.width - painter.width,
      );
      painter.paint(canvas, Offset(x, p.dy - gap - painter.height));
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.values != values ||
      old.range != range ||
      old.colors != colors ||
      old.valueLabel != valueLabel ||
      old.labelStyle != labelStyle ||
      old.textScaler != textScaler;
}
