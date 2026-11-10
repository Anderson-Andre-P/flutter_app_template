import 'package:flutter/painting.dart';

import '../theme/app_colors.dart';

/// Semantic tone of a badge, banner or toast.
enum AppTone { neutral, primary, success, alert, danger, info }

/// Foreground (solid) and background (subtle) colours of each [AppTone].
extension AppToneColors on AppColors {
  Color toneForeground(AppTone tone) => switch (tone) {
    AppTone.neutral => textSecondary,
    AppTone.primary => primary,
    AppTone.success => success,
    AppTone.alert => alert,
    AppTone.danger => danger,
    AppTone.info => info,
  };

  Color toneBackground(AppTone tone) => switch (tone) {
    AppTone.neutral => sunken,
    AppTone.primary => primarySubtle,
    AppTone.success => successSubtle,
    AppTone.alert => alertSubtle,
    AppTone.danger => dangerSubtle,
    AppTone.info => infoSubtle,
  };
}
