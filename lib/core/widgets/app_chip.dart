import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

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
    // Design system, sections 22 and 30: disabled is a neutral fill with no
    // border; pressed tints an unselected chip and darkens a selected one.
    ({Color bg, Color fg, Color? border}) look(bool pressed) => !enabled
        ? (bg: c.sunken, fg: c.textDisabled, border: null)
        : selected
        ? (
            bg: pressed ? c.primaryHover : c.primary,
            fg: c.onPrimary,
            border: pressed ? c.primaryHover : c.primary,
          )
        : (
            bg: pressed ? c.primarySubtle : c.card,
            fg: pressed ? c.primary : c.textPrimary,
            border: pressed ? c.primary : c.borderStrong,
          );
    return MergeSemantics(
      child: Semantics(
        selected: selected,
        button: true,
        child: AppInteractive(
          onTap: enabled ? () => onSelected!(!selected) : null,
          borderRadius: AppRadius.brFull,
          surface: (state) {
            final l = look(state.pressed);
            return (
              color: l.bg,
              border: l.border,
              shadows: const <BoxShadow>[],
            );
          },
          builder: (context, state) => ConstrainedBox(
            constraints: BoxConstraints(minHeight: AppSizes.chip),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: look(state.pressed).fg,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
