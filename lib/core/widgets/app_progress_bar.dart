import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';

/// Horizontal progress from 0 to 1 (values outside are clamped).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value, this.color});

  /// Key of the filled part, for tests.
  static const fillKey = ValueKey('app-progress-fill');

  final double value;

  /// Defaults to `primary`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: AppRadius.brFull,
      child: SizedBox(
        height: AppSizes.progressBar,
        child: ColoredBox(
          color: c.sunken,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              key: fillKey,
              widthFactor: value.clamp(0, 1).toDouble(),
              heightFactor: 1,
              child: ColoredBox(color: color ?? c.primary),
            ),
          ),
        ),
      ),
    );
  }
}
