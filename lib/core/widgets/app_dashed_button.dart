import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// Adds one more item to a list being built ("+ Adicionar item", design
/// system section 09): a dashed outline, so it reads as an empty slot
/// rather than a committed action.
class AppDashedButton extends StatelessWidget {
  const AppDashedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    final fg = enabled ? c.primary : c.textDisabled;
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: enabled,
        child: SizedBox(
          height: AppSizes.buttonMd,
          width: double.infinity,
          child: CustomPaint(
            foregroundPainter: _DashedBorder(c.borderStrong),
            child: AppInteractive(
              onTap: onPressed,
              borderRadius: AppRadius.brMd,
              surface: (state) => (
                color: state.pressed ? c.primarySubtle : Colors.transparent,
                border: null,
                shadows: const <BoxShadow>[],
              ),
              builder: (context, state) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: AppSizes.iconField, color: fg),
                  SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(color: fg),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorder extends CustomPainter {
  _DashedBorder(this.color);

  final Color color;

  static double get _dash => AppSizes.dash;
  static double get _gap => AppSizes.dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
    final outline = Path()
      ..addRRect(AppRadius.brMd.toRRect(Offset.zero & size).deflate(.5));
    for (final PathMetric metric in outline.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += _dash + _gap) {
        canvas.drawPath(metric.extractPath(d, d + _dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorder old) => old.color != color;
}
