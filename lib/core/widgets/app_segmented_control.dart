import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// Picks one of a few mutually exclusive values (design system, section
/// 09: Baixa / Média / Alta / Crítica). Segments share the width; the
/// selected one is a raised surface on the primary tint. For more than
/// four options use a select instead.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final List<({T value, String label})> segments;
  final T selected;

  /// `null` disables the control.
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onChanged != null;
    return Container(
      height: AppSizes.buttonMd,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: enabled ? c.primarySubtle : c.sunken,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _Segment(
                label: segment.label,
                selected: segment.value == selected,
                onTap: enabled ? () => onChanged!(segment.value) : null,
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      enabled: enabled,
      child: AppInteractive(
        onTap: onTap,
        borderRadius: AppRadius.brSm,
        surface: (state) => (
          color: selected
              ? c.raised
              : state.pressed
              ? c.card.withValues(alpha: .5)
              : Colors.transparent,
          border: null,
          shadows: selected ? context.shadows.elev1 : const <BoxShadow>[],
        ),
        builder: (context, state) => Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium.copyWith(
              color: !enabled
                  ? c.textDisabled
                  : selected
                  ? c.primary
                  : c.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
