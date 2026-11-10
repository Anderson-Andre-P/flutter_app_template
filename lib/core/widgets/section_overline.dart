import 'package:flutter/material.dart';

import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Section divider label, always in CAPS.
class SectionOverline extends StatelessWidget {
  const SectionOverline(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: AppTypography.overline.copyWith(color: context.colors.textMuted),
  );
}
