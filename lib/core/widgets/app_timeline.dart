import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_tone.dart';

export 'app_tone.dart';

/// One entry of an [AppTimeline] or [AppVerticalStepper].
class AppTimelineEvent {
  const AppTimelineEvent({required this.title, required this.meta});

  final String title;

  /// When and who: "9 ago, 16:30 · Admin".
  final String meta;
}

/// What happened to a record, newest first (design system, section 18):
/// the latest event has the primary dot with a halo, older ones a muted dot,
/// joined by a line. Read-only.
class AppTimeline extends StatelessWidget {
  const AppTimeline({super.key, required this.events});

  final List<AppTimelineEvent> events;

  static const dotKey = ValueKey('app-timeline-dot');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        for (final (i, e) in events.indexed)
          _Row(
            event: e,
            last: i == events.length - 1,
            marker: Container(
              width: AppSizes.timelineHalo,
              height: AppSizes.timelineHalo,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: i == 0 ? c.primarySubtle : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Container(
                key: dotKey,
                width: AppSizes.timelineDot,
                height: AppSizes.timelineDot,
                decoration: BoxDecoration(
                  color: i == 0 ? c.primary : c.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// What has already happened in a flow, oldest first (design system,
/// section 20): done steps checked, [current] ringed, no interaction.
class AppVerticalStepper extends StatelessWidget {
  const AppVerticalStepper({
    super.key,
    required this.steps,
    required this.current,
  });

  final List<AppTimelineEvent> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        for (final (i, e) in steps.indexed)
          _Row(
            event: e,
            last: i == steps.length - 1,
            highlight: i == current,
            marker: Container(
              width: AppSizes.timelineHalo + AppSpacing.xs,
              height: AppSizes.timelineHalo + AppSpacing.xs,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < current ? c.primary : c.card,
                border: i < current
                    ? null
                    : Border.all(
                        color: i == current ? c.primary : c.borderStrong,
                        width: AppSizes.focusRing,
                      ),
              ),
              child: i < current
                  ? Icon(
                      Icons.check,
                      size: AppSizes.iconInline,
                      color: c.onPrimary,
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.event,
    required this.last,
    required this.marker,
    this.highlight = false,
  });

  final AppTimelineEvent event;
  final bool last;
  final Widget marker;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: AppSizes.timelineHalo + AppSpacing.xs,
            child: Column(
              children: [
                marker,
                if (!last)
                  Expanded(
                    child: Container(
                      width: AppSizes.tabIndicator,
                      color: c.border,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTypography.labelMedium.copyWith(
                      color: highlight ? c.primary : c.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    event.meta,
                    style: AppTypography.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One part of an [AppSegmentedBar].
class AppBarSegment {
  const AppBarSegment({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final double value;
  final AppTone tone;
}

/// Shares of a whole in one 8px bar (design system, section 18). Colour is
/// not the only cue: a screen reader hears every part with its share, and
/// the screen should show a legend.
class AppSegmentedBar extends StatelessWidget {
  const AppSegmentedBar({super.key, required this.segments});

  final List<AppBarSegment> segments;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final total = segments.fold<double>(0, (s, e) => s + e.value);
    String percent(AppBarSegment s) => CommonStrings.share(
      s.label,
      total == 0 ? 0 : (s.value / total * 100).round(),
    );
    return Semantics(
      label: segments.map(percent).join(', '),
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: AppRadius.brFull,
          child: SizedBox(
            height: AppSizes.progressBar,
            // Stretch: a ColoredBox without a child is otherwise 0 tall.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, s) in segments.indexed)
                  if (s.value > 0) ...[
                    if (i > 0) const SizedBox(width: AppSizes.barGap),
                    Expanded(
                      flex: (s.value * 100).round(),
                      child: ColoredBox(color: c.toneForeground(s.tone)),
                    ),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Where you are among a few pages: dots, the current one a wider pill.
class AppPageDots extends StatelessWidget {
  const AppPageDots({
    super.key,
    required this.count,
    required this.current,
    this.color,
  });

  final int count;
  final int current;

  /// Defaults to primary.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final on = color ?? c.primary;
    return Semantics(
      label: CommonStrings.pageOf(current + 1, count),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) SizedBox(width: AppSpacing.xs),
              AnimatedContainer(
                duration: AppDurations.toggle,
                width: i == current ? AppSizes.pageDotActive : AppSizes.pageDot,
                height: AppSizes.pageDot,
                decoration: BoxDecoration(
                  color: i == current ? on : on.withValues(alpha: .3),
                  borderRadius: AppRadius.brFull,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
