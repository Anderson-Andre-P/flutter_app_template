import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Filter chip. Selected = solid primary.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
  });

  final String label;
  final bool selected;

  /// Receives the new selection (`!selected`). `null` disables the chip.
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onSelected != null;
    final fg = !enabled
        ? c.textDisabled
        : selected
        ? c.onPrimary
        : c.textPrimary;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected && enabled ? c.primary : c.card,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brFull,
          side: BorderSide(
            color: selected && enabled ? c.primary : c.borderStrong,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? () => onSelected!(!selected) : null,
          child: Container(
            height: AppSizes.buttonSm,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + 2),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: fg),
            ),
          ),
        ),
      ),
    );
  }
}
