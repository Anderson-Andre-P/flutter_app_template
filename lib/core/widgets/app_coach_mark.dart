import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// First-run hint in context (design system, section 21): shown once —
/// the screen remembers that — and dismissed with a single tap anywhere on
/// it.
class AppCoachMark extends StatelessWidget {
  const AppCoachMark({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
  });

  final String title;
  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      liveRegion: true,
      button: true,
      child: Material(
        color: c.primarySubtle,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: BorderSide(color: c.primary.withValues(alpha: .3)),
        ),
        child: InkWell(
          onTap: onDismiss,
          borderRadius: AppRadius.brMd,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppSizes.iconField,
                  color: c.primary,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.label.copyWith(color: c.primary),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        message,
                        style: AppTypography.caption.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
