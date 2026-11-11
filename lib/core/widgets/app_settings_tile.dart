import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_icon_box.dart';
import 'app_list_tile.dart';
import 'app_switch.dart';

/// Row of a settings list (design system, section 35): an icon box, title,
/// optional subtitle and current [detail] ("Automático"), then a chevron
/// that opens the option — or, with [AppSettingsTile.toggle], a switch that
/// applies at once. The whole row is the touch target.
class AppSettingsTile extends StatelessWidget {
  const AppSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.detail,
  }) : checked = null,
       onChanged = null;

  const AppSettingsTile.toggle({
    super.key,
    required this.icon,
    required this.title,
    required bool this.checked,
    required this.onChanged,
    this.subtitle,
    this.detail,
  }) : onTap = null;

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Current value shown before the chevron or the switch.
  final String? detail;

  final VoidCallback? onTap;

  /// Switch state; `null` on a row that opens an option.
  final bool? checked;

  /// `null` disables the switch.
  final ValueChanged<bool>? onChanged;

  static const chevronKey = ValueKey('app-settings-tile-chevron');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final checked = this.checked;
    final detail = this.detail;
    final leading = AppIconBox(icon: icon, size: AppSizes.settingsIcon);
    final trailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (detail != null)
          Flexible(
            child: Text(
              detail,
              textAlign: TextAlign.end,
              style: AppTypography.bodySmall.copyWith(color: c.textMuted),
            ),
          ),
        if (checked == null) ...[
          if (detail != null) SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.chevron_right,
            key: chevronKey,
            size: AppSizes.iconField,
            color: c.textMuted,
          ),
        ] else ...[
          if (detail != null) SizedBox(width: AppSpacing.sm),
          // The row takes the tap, so the switch only shows the state.
          IgnorePointer(
            child: ExcludeSemantics(
              child: AppSwitch(value: checked, onChanged: onChanged),
            ),
          ),
        ],
      ],
    );
    if (checked == null) {
      return AppListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      );
    }
    final change = onChanged;
    return MergeSemantics(
      child: Semantics(
        toggled: checked,
        enabled: change != null,
        child: AppListTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          onTap: change == null ? null : () => change(!checked),
        ),
      ),
    );
  }
}
