import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';

/// Placeholder in the shape of the content that is loading (design
/// system, section 18): a circle for an avatar, lines for text, a block for
/// media. Wrap the shapes in one [AppShimmer]. Never a generic spinner in a
/// list.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton.line({super.key, this.width, this.height = AppSpacing.md})
    : _circle = false,
      _radius = AppRadius.brXs;

  const AppSkeleton.block({super.key, this.width, required this.height})
    : _circle = false,
      _radius = AppRadius.brMd;

  const AppSkeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      _circle = true,
      _radius = null;

  /// `null` fills the width.
  final double? width;
  final double height;
  final bool _circle;
  final BorderRadius? _radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width ?? double.infinity,
    height: height,
    decoration: BoxDecoration(
      color: context.colors.sunken,
      shape: _circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _radius,
    ),
  );
}

/// Sweeps a highlight across the [AppSkeleton]s below it every
/// [AppDurations.shimmer], looped; still when the system asks for reduced
/// motion. Announced as loading.
class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  static const loadingLabel = CommonStrings.loading;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

/// Owns only the animation of the sweep.
class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final _sweep = AnimationController(
    vsync: this,
    duration: AppDurations.shimmer,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _sweep.stop();
    } else if (!_sweep.isAnimating) {
      _sweep.repeat();
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: AppShimmer.loadingLabel,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _sweep,
          child: widget.child,
          builder: (context, child) {
            final t = _sweep.value;
            return ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment(-1 + 3 * t - 1, 0),
                end: Alignment(-1 + 3 * t, 0),
                colors: [c.sunken, c.card, c.sunken],
              ).createShader(bounds),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
