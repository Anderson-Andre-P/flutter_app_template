import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_counter.dart';
import 'app_icon_button.dart';

/// Screen top bar (design system, section 20): title on the screen
/// background, optional back and actions. [brand] shows the title as the
/// product name in primary; [leading] replaces the back button (a menu).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = false,
    this.onBack,
    this.brand = false,
    this.leading,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;

  /// Defaults to `Navigator.maybePop`.
  final VoidCallback? onBack;
  final bool brand;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final lead =
        leading ??
        (showBack
            ? IconButton(
                tooltip: CommonStrings.back,
                icon: Icon(
                  Icons.arrow_back,
                  size: AppSizes.iconTopBar,
                  color: c.textPrimary,
                ),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            : null);
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: lead == null ? AppSpacing.xl : 0,
      leading: lead,
      title: Text(
        title,
        style: (brand ? AppTypography.title : AppTypography.heading).copyWith(
          color: brand ? c.primary : c.textPrimary,
        ),
      ),
      actions: actions,
    );
  }
}

/// The bell of a top bar with the unread [count] (hidden at zero); read as
/// "Notificações, 3 novas".
class AppNotificationButton extends StatelessWidget {
  const AppNotificationButton({
    super.key,
    required this.count,
    required this.onPressed,
  });

  final int count;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      AppIconButton(
        icon: Icons.notifications_none,
        label: CommonStrings.notifications(count),
        bordered: false,
        onPressed: onPressed,
      ),
      if (count > 0)
        Positioned(
          top: AppSpacing.xs,
          right: AppSpacing.xs,
          child: IgnorePointer(
            child: ExcludeSemantics(child: AppCounter(count: count)),
          ),
        ),
    ],
  );
}

/// Dark bar over a full-screen viewer (design system, section 20:
/// "× Visualizador 2 de 4"): ink in both themes so the content stands out.
class AppViewerBar extends StatelessWidget implements PreferredSizeWidget {
  const AppViewerBar({
    super.key,
    required this.title,
    required this.onClose,
    this.position,
  });

  final String title;
  final VoidCallback onClose;

  /// "2 de 4".
  final String? position;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? c.sunken : c.textPrimary;
    final fg = dark ? c.textPrimary : c.card;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        tooltip: CommonStrings.close,
        icon: Icon(Icons.close, size: AppSizes.iconTopBar, color: fg),
        onPressed: onClose,
      ),
      title: Text(title, style: AppTypography.section.copyWith(color: fg)),
      actions: [
        if (position case final p?)
          Padding(
            padding: EdgeInsetsDirectional.only(end: AppSpacing.xl),
            child: Center(
              child: Text(
                p,
                style: AppTypography.caption.copyWith(
                  color: fg.withValues(alpha: .7),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
