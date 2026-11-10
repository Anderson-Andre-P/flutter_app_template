import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Search input at the top of a list: no label, the hint says what it
/// searches, a leading magnifier.
class AppSearchField extends StatelessWidget {
  const AppSearchField({super.key, required this.hint, this.onChanged});

  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTypography.body.copyWith(color: c.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        constraints: const BoxConstraints(minHeight: AppSizes.field),
        prefixIcon: Icon(
          Icons.search,
          size: AppSizes.iconField,
          color: c.textMuted,
        ),
      ),
    );
  }
}
