import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// A reading at a glance (design system, section 37): the label in CAPS
/// above a large value with its unit ("DISTÂNCIA · 5,20 km"). No card of
/// its own — put several side by side in one. [centered] for a metric under
/// a ring or alone in a column.
class AppMetric extends StatelessWidget {
  const AppMetric({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.centered = false,
  });

  final String label;
  final String value;
  final String? unit;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: centered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.overline.copyWith(color: c.textMuted),
          ),
          SizedBox(height: AppSpacing.xxs),
          _ValueWithUnit(
            value: value,
            unit: unit,
            style: AppTypography.metric,
            centered: centered,
          ),
        ],
      ),
    );
  }
}

/// A number against the previous period (design system, section 37): an
/// icon and label, the value with its unit, and the [change] below in
/// green when it is good news, red when it is not ([positive]). A card.
class AppKpi extends StatelessWidget {
  const AppKpi({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    required this.positive,
    this.unit,
    this.icon = Icons.trending_up,
  });

  final String label;
  final String value;
  final String? unit;

  /// "+3 vs mês anterior".
  final String change;

  /// Whether [change] is good news — not whether it went up: fewer errors
  /// is positive.
  final bool positive;
  final IconData icon;

  static const changeKey = ValueKey('app-kpi-change');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: c.border),
          boxShadow: context.shadows.elev1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, size: AppSizes.iconChip, color: c.primary),
                SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    label,
                    style: AppTypography.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            _ValueWithUnit(
              value: value,
              unit: unit,
              style: AppTypography.title,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              change,
              key: changeKey,
              style: AppTypography.captionBold.copyWith(
                color: positive ? c.success : c.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueWithUnit extends StatelessWidget {
  const _ValueWithUnit({
    required this.value,
    required this.unit,
    required this.style,
    this.centered = false,
  });

  final String value;
  final String? unit;
  final TextStyle style;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Text.rich(
      TextSpan(
        text: value,
        style: style.copyWith(color: c.textPrimary),
        children: [
          if (unit != null)
            TextSpan(
              text: ' $unit',
              style: AppTypography.label.copyWith(color: c.textMuted),
            ),
        ],
      ),
      textAlign: centered ? TextAlign.center : TextAlign.start,
    );
  }
}
