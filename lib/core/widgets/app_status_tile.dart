import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// A count that needs attention at a glance (design system, section 09):
/// a large number, its label below and a bar in the [tone] on the leading
/// edge — the only card that carries a coloured bar.
class AppStatusTile extends StatelessWidget {
  const AppStatusTile({
    super.key,
    required this.value,
    required this.label,
    this.tone = AppTone.primary,
  });

  final String value;
  final String label;
  final AppTone tone;

  static const barKey = ValueKey('app-status-tile-bar');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: AppRadius.brMdPlus,
          border: Border.all(color: c.border),
          boxShadow: context.shadows.elev1,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ColoredBox(
                key: barKey,
                color: c.toneForeground(tone),
                child: SizedBox(width: AppSizes.statusBar),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: AppTypography.title.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        label,
                        style: AppTypography.caption.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
