import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// 56px bottom bar (plus the bottom safe area); the active tab is primary.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppSizes.bottomNav,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(child: _tab(c.primary, c.textMuted, i)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(Color active, Color inactive, int i) {
    final selected = i == currentIndex;
    final color = selected ? active : inactive;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: () => onTap(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(items[i].icon, size: AppSizes.iconNav, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              items[i].label,
              style:
                  (selected
                          ? AppTypography.microBold
                          : AppTypography.microMedium)
                      .copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
