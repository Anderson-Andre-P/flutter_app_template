import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';

/// Placeholder in the shape of the content that is loading (design
/// system, section 18): a circle for an avatar, lines for text, a block for
/// media. Wrap the shapes in one [AppShimmer]. Never a generic spinner in a
/// list.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton.line({super.key, this.width, this.height})
    : _shape = _Shape.line;

  const AppSkeleton.block({super.key, this.width, required double this.height})
    : _shape = _Shape.block;

  const AppSkeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      _shape = _Shape.circle;

  /// `null` fills the width.
  final double? width;

  /// A line defaults to [AppSpacing.md].
  final double? height;
  final _Shape _shape;

  @override
  Widget build(BuildContext context) => Container(
    width: width ?? double.infinity,
    height: height ?? AppSpacing.md,
    decoration: BoxDecoration(
      color: context.colors.sunken,
      shape: _shape == _Shape.circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: switch (_shape) {
        _Shape.line => AppRadius.brXs,
        _Shape.block => AppRadius.brMd,
        _Shape.circle => null,
      },
    ),
  );
}

enum _Shape { line, block, circle }

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
