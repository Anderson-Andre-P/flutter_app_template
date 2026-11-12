import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Count of items that need attention — unread, pending (design system,
/// section 28). Above [cap] shows `99+`. Show it only when the number asks
/// for action: a static total is noise.
///
/// [ring] makes it the compact counter that sits over an icon: smaller, with
/// a ring of that colour (the surface behind the icon) so the icon stays
/// readable under it.
class AppCounter extends StatelessWidget {
  const AppCounter({super.key, required this.count, this.ring});

  final int count;
  final Color? ring;

  static const cap = 99;

  /// Line height of the number, so it centres in the pill.
  static const _tightLine = 1.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ring = this.ring;
    final size = ring == null ? AppSizes.counter : AppSizes.counterCompact;
    return Container(
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      padding: EdgeInsets.symmetric(
        horizontal: ring == null ? AppSpacing.xs : AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: c.danger,
        borderRadius: AppRadius.brFull,
        border: ring == null
            ? null
            : Border.all(color: ring, width: AppSizes.counterRing),
      ),
      // Hugs the number (a Container with an alignment would fill the
      // space it is given); the min size keeps one digit a circle.
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: Text(
          count > cap ? '$cap+' : '$count',
          style: AppTypography.microBold.copyWith(
            color: c.card,
            // The compact counter takes the smaller micro size, still bold.
            fontSize: ring == null ? null : AppTypography.micro.fontSize,
            height: _tightLine,
          ),
        ),
      ),
    );
  }
}

/// "There is something new" without a number. [label] is what a screen
/// reader hears, since the dot alone says nothing.
class AppNewDot extends StatelessWidget {
  const AppNewDot({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: Container(
      width: AppSizes.newDot,
      height: AppSizes.newDot,
      decoration: BoxDecoration(
        color: context.colors.danger,
        shape: BoxShape.circle,
      ),
    ),
  );
}
