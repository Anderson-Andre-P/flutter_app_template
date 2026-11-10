import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Screen top bar: title on the screen background, optional back and actions.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = false,
    this.onBack,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;

  /// Defaults to `Navigator.maybePop`.
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: showBack ? 0 : AppSpacing.xl,
      leading: showBack
          ? IconButton(
              tooltip: CommonStrings.back,
              icon: Icon(
                Icons.arrow_back,
                size: AppSizes.iconTopBar,
                color: c.textPrimary,
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(
        title,
        style: AppTypography.heading.copyWith(color: c.textPrimary),
      ),
      actions: actions,
    );
  }
}
