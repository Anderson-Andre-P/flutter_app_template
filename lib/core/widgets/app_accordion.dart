import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// One panel of an [AppAccordion].
class AppAccordionItem {
  const AppAccordionItem({required this.title, required this.body, this.icon});

  final String title;
  final String body;
  final IconData? icon;
}

/// Secondary content the user looks for — FAQ, specs, optional details
/// (design system, section 20). One panel open at a time; never hide what
/// everyone needs behind it. [expanded] is the open panel (`null`: none);
/// [onChanged] receives the panel to open, or `null` to close the open one.
class AppAccordion extends StatelessWidget {
  const AppAccordion({
    super.key,
    required this.items,
    required this.expanded,
    required this.onChanged,
  });

  final List<AppAccordionItem> items;
  final int? expanded;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0) SizedBox(height: AppSpacing.sm),
        _Panel(
          item: items[i],
          open: i == expanded,
          onToggle: () => onChanged(i == expanded ? null : i),
        ),
      ],
    ],
  );
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.item,
    required this.open,
    required this.onToggle,
  });

  final AppAccordionItem item;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedContainer(
      duration: AppDurations.accordion,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.brLg,
        border: Border.all(
          color: open ? c.primary.withValues(alpha: .4) : c.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Semantics(
              button: true,
              expanded: open,
              enabled: true,
              child: AppInteractive(
                onTap: onToggle,
                borderRadius: BorderRadius.zero,
                ringInside: true,
                surface: (state) => (
                  color: state.pressed ? c.primarySubtle : Colors.transparent,
                  border: null,
                  shadows: const <BoxShadow>[],
                ),
                builder: (context, state) => ConstrainedBox(
                  constraints: BoxConstraints(minHeight: AppSizes.listTileMin),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        if (item.icon case final icon?) ...[
                          Container(
                            width: AppSizes.avatarMd - AppSpacing.xs,
                            height: AppSizes.avatarMd - AppSpacing.xs,
                            decoration: BoxDecoration(
                              color: c.primarySubtle,
                              borderRadius: AppRadius.brSm,
                            ),
                            child: Icon(
                              icon,
                              size: AppSizes.iconChip,
                              color: c.primary,
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                        ],
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTypography.labelMedium.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: open ? .5 : 0,
                          duration: AppDurations.accordion,
                          child: Icon(
                            Icons.expand_more,
                            size: AppSizes.iconTopBar,
                            color: open ? c.primary : c.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: AppDurations.accordion,
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Text(
                      item.body,
                      style: AppTypography.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
