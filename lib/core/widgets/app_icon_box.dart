import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// Rounded square holding an icon on the subtle colour of its [tone] —
/// the leading of list rows and menu cards. [circle] for hero icons.
class AppIconBox extends StatelessWidget {
  const AppIconBox({
    super.key,
    required this.icon,
    this.tone = AppTone.primary,
    this.size,
    this.circle = false,
  });

  final IconData icon;
  final AppTone tone;
  final double? size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? AppSizes.iconBox;
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.toneBackground(tone),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : AppRadius.brMd,
      ),
      child: Icon(icon, size: size * .5, color: c.toneForeground(tone)),
    );
  }
}
