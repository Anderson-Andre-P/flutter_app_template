import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// Initials on the primary tint (design system, section 28: two letters,
/// no photo). [status] adds a dot in that tone on the corner; give
/// [statusLabel] too, since the dot alone says nothing ("Disponível").
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.initials,
    this.size,
    this.status,
    this.statusLabel,
    this.ring,
  }) : assert(status == null || statusLabel != null, 'Name the status');

  final String initials;
  final double? size;
  final AppTone? status;
  final String? statusLabel;

  /// Outline in this colour — separates overlapping avatars in a group.
  final Color? ring;

  static const statusKey = ValueKey('app-avatar-status');

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? AppSizes.avatarLg;
    final c = context.colors;
    final face = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.primarySubtle,
        shape: BoxShape.circle,
        border: ring == null
            ? null
            : Border.all(color: ring!, width: AppSizes.focusRing),
      ),
      child: Text(
        initials,
        style: AppTypography.label.copyWith(
          color: c.primary,
          fontSize: size * .36,
        ),
      ),
    );
    final tone = status;
    if (tone == null) return face;
    return Semantics(
      label: '$initials, $statusLabel',
      child: ExcludeSemantics(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            face,
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                key: statusKey,
                width: AppSizes.avatarStatus,
                height: AppSizes.avatarStatus,
                decoration: BoxDecoration(
                  color: c.toneForeground(tone),
                  shape: BoxShape.circle,
                  border: Border.all(color: c.card, width: AppSizes.focusRing),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Overlapping avatars of the people on something (design system, section
/// 28): the first [max] and a `+N` for the rest.
class AppAvatarGroup extends StatelessWidget {
  const AppAvatarGroup({
    super.key,
    required this.initials,
    this.max = 3,
    this.size,
  });

  final List<String> initials;
  final int max;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? AppSizes.avatarMd;
    final c = context.colors;
    final shown = initials.take(max).toList();
    final rest = initials.length - shown.length;
    final step = size * .75;
    final count = shown.length + (rest > 0 ? 1 : 0);
    return SizedBox(
      width: step * (count - 1) + size,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: step * i,
              child: AppAvatar(initials: shown[i], size: size, ring: c.card),
            ),
          if (rest > 0)
            Positioned(
              left: step * shown.length,
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.sunken,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.card, width: AppSizes.focusRing),
                ),
                child: Text(
                  '+$rest',
                  style: AppTypography.captionBold.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
