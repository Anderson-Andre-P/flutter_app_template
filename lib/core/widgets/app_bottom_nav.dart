import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Bottom bar: 64px, shared with the system inset below it (see
/// [AppSizes.bottomNavContent]); the active tab is primary.
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
    final inset = MediaQuery.paddingOf(context).bottom;
    // 64 with no inset; with one, the tabs shrink to 48 and the inset fills
    // the rest, so the bar grows only when the inset is taller than 16.
    final total = max(AppSizes.bottomNav, AppSizes.bottomNavContent + inset);
    final tabsHeight = total - inset;
    return Material(
      color: c.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: SizedBox(
            height: tabsHeight,
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
            Icon(items[i].icon, size: AppSizes.icon, color: color),
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
