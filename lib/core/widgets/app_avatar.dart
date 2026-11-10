import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Round avatar with initials. Sizes: `AppSizes.avatarSm…avatarXl`.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.initials,
    this.size = AppSizes.avatarLg,
  });

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.primarySubtle, shape: BoxShape.circle),
      child: Text(
        initials,
        style: AppTypography.label.copyWith(
          color: c.primary,
          fontSize: size * .36,
        ),
      ),
    );
  }
}
