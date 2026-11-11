import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// Inline band that asks for action before going on (design system,
/// section 09: "Action required"): an icon and an upper-case title in the
/// [tone], the message below, on the tone's subtle surface.
class AppAttentionBand extends StatelessWidget {
  const AppAttentionBand({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.warning_amber_rounded,
    this.tone = AppTone.danger,
  });

  final String title;
  final String message;
  final IconData icon;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = _text(c);
    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: c.toneBackground(tone),
          borderRadius: AppRadius.brMdPlus,
          border: Border.all(
            color: c.toneForeground(tone).withValues(alpha: .2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppSizes.bandIcon,
                  height: AppSizes.bandIcon,
                  decoration: BoxDecoration(
                    color: c.toneForeground(tone).withValues(alpha: .12),
                    borderRadius: AppRadius.brXs,
                  ),
                  child: Icon(icon, size: AppSizes.iconChip, color: fg),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: AppTypography.overline.copyWith(color: fg),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodySmall.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  /// The solid alert colour is too light for text on its tint.
  Color _text(AppColors c) =>
      tone == AppTone.alert ? c.alertText : c.toneForeground(tone);
}
