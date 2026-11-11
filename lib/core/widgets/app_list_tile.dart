import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// List row: optional leading, title + subtitle, optional trailing.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSizes.listTileMin),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: AppTypography.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.md),
              // At most half the row, so large text wraps the trailing
              // value instead of pushing the row off screen.
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width / 2,
                ),
                child: trailing,
              ),
            ],
          ],
        ),
      ),
    );
    if (onTap == null) return row;
    // Pressed tints the row; the focus ring stays inside, since rows sit in
    // clipped cards.
    return AppInteractive(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      ringInside: true,
      surface: (state) => (
        color: state.pressed ? c.primarySubtle : Colors.transparent,
        border: null,
        shadows: const <BoxShadow>[],
      ),
      builder: (_, _) => row,
    );
  }
}
