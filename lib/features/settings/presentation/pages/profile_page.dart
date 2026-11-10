import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/session/session_bloc.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/mode/theme_mode_bloc.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/initials.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../../../../core/widgets/section_overline.dart';
import '../settings_strings.dart';

/// Profile and app settings: who is signed in, account menu (placeholders),
/// theme mode, version and sign out.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _modes = [
    (ThemeMode.system, SettingsStrings.themeSystem),
    (ThemeMode.light, SettingsStrings.themeLight),
    (ThemeMode.dark, SettingsStrings.themeDark),
  ];

  static const _menu = [
    (
      Icons.person_outline,
      SettingsStrings.personalData,
      SettingsStrings.personalDataHint,
    ),
    (
      Icons.lock_outline,
      SettingsStrings.security,
      SettingsStrings.securityHint,
    ),
    (
      Icons.notifications_none,
      SettingsStrings.notifications,
      SettingsStrings.notificationsHint,
    ),
    (Icons.help_outline, SettingsStrings.help, SettingsStrings.helpHint),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final user = context.select<SessionBloc, SessionUser?>((b) => b.state.user);
    final mode = context.select<ThemeModeBloc, ThemeMode>((b) => b.state.mode);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.x2l,
            AppSpacing.xl,
            AppSpacing.x4l,
          ),
          children: [
            Text(
              SettingsStrings.title,
              style: AppTypography.display.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: AppSpacing.x2l),
            Row(
              children: [
                AppAvatar(
                  initials: initialsOf(user?.name ?? ''),
                  size: AppSizes.avatarXl,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? '',
                        style: AppTypography.heading.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        user?.email ?? '',
                        style: AppTypography.caption.copyWith(
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2l),
            for (final (icon, title, hint) in _menu) ...[
              AppCard(
                padding: EdgeInsets.zero,
                onTap: () =>
                    AppSnackbar.info(context, SettingsStrings.comingSoon),
                child: AppListTile(
                  title: title,
                  subtitle: hint,
                  leading: AppIconBox(icon: icon),
                  trailing: Icon(Icons.chevron_right, color: c.textMuted),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.x2l - AppSpacing.md),
            const SectionOverline(SettingsStrings.appearance),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (value, label) in _modes)
                  AppChip(
                    label: label,
                    selected: mode == value,
                    onSelected: (_) => context.read<ThemeModeBloc>().add(
                      ThemeModeChanged(value),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2l),
            const SectionOverline(SettingsStrings.about),
            const SizedBox(height: AppSpacing.md),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final info = snapshot.data;
                return Text(
                  info == null
                      ? ''
                      : SettingsStrings.version(info.version, info.buildNumber),
                  style: AppTypography.body.copyWith(color: c.textSecondary),
                );
              },
            ),
            const SizedBox(height: AppSpacing.x3l),
            AppButton(
              label: SettingsStrings.signOut,
              variant: AppButtonVariant.destructiveTonal,
              icon: Icons.logout,
              onPressed: () async {
                final session = context.read<SessionBloc>();
                final confirmed = await AppDialog.confirm(
                  context,
                  title: SettingsStrings.signOutTitle,
                  message: SettingsStrings.signOutMessage,
                  confirmLabel: SettingsStrings.signOutConfirm,
                  destructive: true,
                );
                if (confirmed) session.add(const SessionEnded());
              },
            ),
          ],
        ),
      ),
    );
  }
}
