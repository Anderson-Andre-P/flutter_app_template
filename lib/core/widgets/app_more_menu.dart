import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_icon_button.dart';
import 'app_menu_style.dart';

/// One action of an [AppMoreMenu].
class AppMenuAction {
  const AppMenuAction({
    required this.label,
    required this.onSelected,
    this.icon,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onSelected;
  final IconData? icon;

  /// Red, and only ever the last action, after a divider.
  final bool destructive;
}

/// "Mais ações" — the context menu of an item (design system, section 25),
/// anchored to a ⋮ button. Up to [maxActions]; a destructive action goes
/// last, in red, separated by a divider. Arrows move, Enter confirms and
/// Esc closes.
class AppMoreMenu extends StatelessWidget {
  const AppMoreMenu({
    super.key,
    required this.actions,
    this.label = CommonStrings.moreActions,
  });

  final List<AppMenuAction> actions;

  /// What a screen reader hears for the ⋮ button.
  final String label;

  static const maxActions = 6;

  @override
  Widget build(BuildContext context) {
    assert(actions.length <= maxActions, 'At most $maxActions actions.');
    assert(
      actions.indexWhere((a) => a.destructive) == -1 ||
          actions.indexWhere((a) => a.destructive) == actions.length - 1,
      'The destructive action goes last.',
    );
    final c = context.colors;
    return MenuAnchor(
      style: AppMenuStyle.menu(context),
      alignmentOffset: Offset(0, AppSpacing.xs),
      menuChildren: [
        for (final action in actions) ...[
          if (action.destructive && actions.length > 1)
            Divider(height: AppSpacing.sm, color: c.border),
          MenuItemButton(
            style: AppMenuStyle.item(context),
            onPressed: action.onSelected,
            leadingIcon: action.icon == null
                ? null
                : Icon(
                    action.icon,
                    size: AppSizes.iconField,
                    color: action.destructive ? c.danger : c.textSecondary,
                  ),
            child: Text(
              action.label,
              style: AppTypography.body.copyWith(
                color: action.destructive ? c.danger : c.textPrimary,
              ),
            ),
          ),
        ],
      ],
      builder: (context, menu, _) => AppIconButton(
        icon: Icons.more_vert,
        label: label,
        onPressed: () => menu.isOpen ? menu.close() : menu.open(),
      ),
    );
  }
}
