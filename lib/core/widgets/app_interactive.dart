import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';

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
    final control = Stack(
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
    // Every control answers to at least 44 × 44, even when it is drawn
    // smaller (a 32px chip, a 30px button): the extra area is invisible and
    // forwards the touch to the control, and the screen-reader node takes
    // the full size.
    return Semantics(
      container: true,
      child: _TapTarget(
        minSize: const Size.square(AppSizes.minTouchTarget),
        child: control,
      ),
    );
  }
}

/// Lays out [child] at its own size, takes at least [minSize] itself and
/// sends any touch inside that area to the child's centre — the same thing
/// Material's padded tap target does.
class _TapTarget extends SingleChildRenderObjectWidget {
  const _TapTarget({required this.minSize, required super.child});

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTapTarget(minSize);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTapTarget renderObject,
  ) => renderObject.minSize = minSize;
}

class _RenderTapTarget extends RenderShiftedBox {
  _RenderTapTarget(this._minSize) : super(null);

  Size _minSize;
  Size get minSize => _minSize;
  set minSize(Size value) {
    if (value == _minSize) return;
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      math.max(child?.getMinIntrinsicWidth(height) ?? 0, minSize.width);

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(child?.getMinIntrinsicHeight(width) ?? 0, minSize.height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      math.max(child?.getMaxIntrinsicWidth(height) ?? 0, minSize.width);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(child?.getMaxIntrinsicHeight(width) ?? 0, minSize.height);

  Size _sizeFor(BoxConstraints constraints, Size childSize) =>
      constraints.constrain(
        Size(
          math.max(childSize.width, minSize.width),
          math.max(childSize.height, minSize.height),
        ),
      );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) return constraints.constrain(minSize);
    return _sizeFor(constraints, child.getDryLayout(constraints));
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.constrain(minSize);
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    size = _sizeFor(constraints, child.size);
    (child.parentData! as BoxParentData).offset = Alignment.center.alongOffset(
      size - child.size as Offset,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) return true;
    final child = this.child;
    if (child == null || !size.contains(position)) return false;
    final center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) => child.hitTest(result, position: center),
    );
  }
}
