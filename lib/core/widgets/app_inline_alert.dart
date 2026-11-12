import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// A one-line block inside the screen that explains why something cannot
/// go on yet (design system, section 17: "Bloqueio inline: campo
/// obrigatório ausente"). For more text and a title, use
/// `AppAttentionBand`.
class AppInlineAlert extends StatelessWidget {
  const AppInlineAlert({
    super.key,
    required this.message,
    this.tone = AppTone.danger,
    this.icon = Icons.error_outline,
  });

  final String message;
  final AppTone tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = _text(c);
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: c.toneBackground(tone),
          borderRadius: AppRadius.brMd,
          border: Border.all(
            color: c.toneForeground(tone).withValues(alpha: .2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: AppSizes.iconField, color: fg),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: AppTypography.labelMedium.copyWith(color: fg),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _text(AppColors c) =>
      tone == AppTone.alert ? c.alertText : c.toneForeground(tone);
}
