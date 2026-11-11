import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// One tab of [AppTabs]; [count] shows a small counter after the label.
class AppTab {
  const AppTab({required this.label, this.count});

  final String label;
  final int? count;
}

/// Underlined tabs for different content of the same object — Visão geral
/// / Histórico / Documentos (design system, section 20). The active tab is
/// primary with a 2px underline. For slices of the same content (Semana /
/// Mês) use an `AppSegmentedControl`; never both kinds on one screen.
/// Scrolls sideways when the tabs do not fit.
class AppTabs extends StatelessWidget {
  const AppTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onChanged,
  });

  final List<AppTab> tabs;
  final int selected;
  final ValueChanged<int> onChanged;

  static const indicatorKey = ValueKey('app-tabs-indicator');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              _TabItem(
                tab: tabs[i],
                selected: i == selected,
                onTap: () => onChanged(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.primary : c.textMuted;
    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: selected,
        inMutuallyExclusiveGroup: true,
        enabled: true,
        child: AppInteractive(
          onTap: onTap,
          borderRadius: AppRadius.brXs,
          ringInside: true,
          surface: (state) => (
            color: state.pressed ? c.primarySubtle : Colors.transparent,
            border: null,
            shadows: const <BoxShadow>[],
          ),
          builder: (context, state) => SizedBox(
            height: AppSizes.minTouchTarget,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Center(
                    widthFactor: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tab.label,
                          style:
                              (selected
                                      ? AppTypography.label
                                      : AppTypography.labelMedium)
                                  .copyWith(color: fg),
                        ),
                        if (tab.count case final count?) ...[
                          SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? c.primarySubtle : c.sunken,
                              borderRadius: AppRadius.brXs,
                            ),
                            child: Text(
                              '$count',
                              style: AppTypography.micro.copyWith(color: fg),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (selected)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      key: AppTabs.indicatorKey,
                      height: AppSizes.tabIndicator,
                      color: c.primary,
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
