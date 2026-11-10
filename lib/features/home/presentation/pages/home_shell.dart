import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../home_strings.dart';

/// Signed-in area: the current tab plus the bottom navigation.
class HomeShell extends StatelessWidget {
  const HomeShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabSelected,
  });

  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: child,
    bottomNavigationBar: AppBottomNav(
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: const [
        AppBottomNavItem(icon: Icons.home_outlined, label: HomeStrings.tabHome),
        AppBottomNavItem(
          icon: Icons.settings_outlined,
          label: HomeStrings.tabSettings,
        ),
      ],
    ),
  );
}
