import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';

/// What a control is going through right now (design system, sections 22
/// and 30). Disabled is not here: it is `onTap == null`, known up front.
@immutable
class AppInteraction {
  const AppInteraction({this.pressed = false, this.focused = false});

  final bool pressed;
  final bool focused;
}

/// How the control's surface looks for an [AppInteraction].
typedef AppSurface = ({Color color, Color? border, List<BoxShadow> shadows});

/// The tappable surface shared by buttons, chips and list rows.
///
/// It tracks the transient pressed and focused states — the same visual-only
/// state an [InkWell] keeps — and lets [surface] and [builder] react to
/// them, instead of the generic ink overlay. While focused from the keyboard
/// it draws the focus ring: [AppSizes.focusRing] thick,
/// [AppSizes.focusRingGap] away from the control ([ringInside] keeps it
/// within the bounds, for rows inside a clipped card).
class AppInteractive extends StatefulWidget {
  const AppInteractive({
    super.key,
    required this.onTap,
    required this.borderRadius,
    required this.surface,
    required this.builder,
    this.ringInside = false,
  });

  /// `null` disables the control.
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final AppSurface Function(AppInteraction state) surface;
  final Widget Function(BuildContext context, AppInteraction state) builder;
  final bool ringInside;

  static const focusRingKey = ValueKey('app-interactive-focus-ring');

  @override
  State<AppInteractive> createState() => _AppInteractiveState();
}

class _AppInteractiveState extends State<AppInteractive> {
  bool _pressed = false;
  bool _focused = false;

  void _setPressed(bool value) {
    if (value != _pressed) setState(() => _pressed = value);
  }

  void _setFocused(bool value) {
    if (value != _focused) setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final state = AppInteraction(
      pressed: enabled && _pressed,
      focused: enabled && _focused,
    );
    final look = widget.surface(state);
    final radius = widget.borderRadius;
    const outside = AppSizes.focusRing + AppSizes.focusRingGap;
    final inset = widget.ringInside ? 0.0 : -outside;
    final ringRadius = widget.ringInside
        ? radius
        : radius + const BorderRadius.all(Radius.circular(outside));
    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: look.shadows,
          ),
          child: Material(
            color: look.color,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: look.border == null
                  ? BorderSide.none
                  : BorderSide(color: look.border!),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: _setPressed,
              onFocusChange: _setFocused,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: widget.builder(context, state),
            ),
          ),
        ),
        if (state.focused)
          Positioned(
            left: inset,
            top: inset,
            right: inset,
            bottom: inset,
            child: IgnorePointer(
              key: AppInteractive.focusRingKey,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: ringRadius,
                  border: Border.all(
                    color: context.colors.focus,
                    width: AppSizes.focusRing,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
