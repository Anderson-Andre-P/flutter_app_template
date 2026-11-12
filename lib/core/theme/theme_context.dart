import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_tokens.dart';

/// Shortcuts to the design-system extensions of the active theme.
extension ThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppShadows get shadows => Theme.of(this).extension<AppShadows>()!;

  TextTheme get text => Theme.of(this).textTheme;
}
