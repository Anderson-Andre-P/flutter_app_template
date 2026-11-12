import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// One option of an [AppSegmentedControl]. With [iconOnly] only the [icon]
/// shows and the [label] is what a screen reader hears.
class AppSegment<T> {
  const AppSegment({
    required this.value,
    required this.label,
    this.icon,
    this.iconOnly = false,
  }) : assert(!iconOnly || icon != null, 'An icon-only segment needs an icon');

  final T value;
  final String label;
  final IconData? icon;
  final bool iconOnly;
}

/// How an [AppSegmentedControl] looks (design system, sections 09 and 10).
enum AppSegmentedStyle {
  /// A raised segment on the primary tint — picks a value
  /// (Baixa / Média / Alta / Crítica).
  tinted,

  /// Segments joined inside one outline, the active one tinted — switches
  /// a view (Lista / Grade / Mapa / Calendário), also icon-only.
  joined,
}

/// Picks one of a few mutually exclusive values. Segments share the width
/// (icon-only joined segments hug their 44px). For more than four options
/// use a select instead.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.style = AppSegmentedStyle.tinted,
  });

  final List<AppSegment<T>> segments;
  final T selected;

  /// `null` disables the control.
  final ValueChanged<T>? onChanged;
  final AppSegmentedStyle style;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onChanged != null;
    final joined = style == AppSegmentedStyle.joined;
    final hug = joined && segments.every((s) => s.iconOnly);
    final children = <Widget>[
      for (var i = 0; i < segments.length; i++) ...[
        if (joined && i > 0)
          VerticalDivider(
            width: AppSizes.hairline,
            thickness: AppSizes.hairline,
            color: c.border,
          ),
        _wrap(
          hug,
          _Segment(
            segment: segments[i],
            joined: joined,
            selected: segments[i].value == selected,
            onTap: enabled ? () => onChanged!(segments[i].value) : null,
          ),
        ),
      ],
    ];
    // The border is drawn over the segments, not around them, so each
    // segment keeps the full 44px touch height.
    return Container(
      height: AppSizes.buttonMd,
      clipBehavior: joined ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: joined
            ? c.card
            : enabled
            ? c.primarySubtle
            : c.sunken,
        borderRadius: AppRadius.brMd,
      ),
      foregroundDecoration: joined
          ? BoxDecoration(
              borderRadius: AppRadius.brMd,
              border: Border.all(color: c.borderStrong),
            )
          : null,
      child: Row(
        mainAxisSize: hug ? MainAxisSize.min : MainAxisSize.max,
        children: children,
      ),
    );
  }

  static Widget _wrap(bool hug, Widget child) => hug
      ? SizedBox(width: AppSizes.minTouchTarget, child: child)
      : Expanded(child: child);
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.joined,
    required this.selected,
    required this.onTap,
  });

  final AppSegment<T> segment;
  final bool joined;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    final fg = !enabled
        ? c.textDisabled
        : selected
        ? c.primary
        : joined
        ? c.textPrimary
        : c.textMuted;
    final icon = segment.icon;
    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: selected,
        inMutuallyExclusiveGroup: true,
        enabled: enabled,
        label: segment.iconOnly ? segment.label : null,
        child: AppInteractive(
          onTap: onTap,
          borderRadius: joined ? BorderRadius.zero : AppRadius.brMd,
          ringInside: true,
          surface: (state) => (
            color: joined && (selected || state.pressed)
                ? c.primarySubtle
                : Colors.transparent,
            border: null,
            shadows: const <BoxShadow>[],
          ),
          // Tinted: the raised pill is drawn inside the full-height target.
          builder: (context, state) => joined
              ? _content(fg, icon)
              : Padding(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: selected
                          ? c.raised
                          : state.pressed
                          ? c.card.withValues(alpha: .5)
                          : Colors.transparent,
                      borderRadius: AppRadius.brSm,
                      boxShadow: selected
                          ? context.shadows.elev1
                          : const <BoxShadow>[],
                    ),
                    child: _content(fg, icon),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _content(Color fg, IconData? icon) => Center(
    child: segment.iconOnly
        ? Icon(icon, size: AppSizes.iconField, color: fg)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconField, color: fg),
                SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  segment.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium.copyWith(color: fg),
                ),
              ),
            ],
          ),
  );
}
