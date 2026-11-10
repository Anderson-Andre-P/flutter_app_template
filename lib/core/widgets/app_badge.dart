import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// Compact status marker: 26px pill, dot + label. Status never relies on
/// colour alone — the label always says it.
class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, this.tone = AppTone.neutral});

  final String label;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = c.toneForeground(tone);
    return Container(
      height: AppSizes.pill,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md - 2),
      decoration: BoxDecoration(
        color: c.toneBackground(tone),
        borderRadius: AppRadius.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
