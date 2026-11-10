import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_bloc.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../home_demo.dart';
import '../home_strings.dart';

/// Home tab: a two-column grid of cards, one per example screen.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onOpenDemo});

  final ValueChanged<HomeDemo> onOpenDemo;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final name = context.select<SessionBloc, String>(
      (b) => b.state.user?.name ?? '',
    );
    const demos = HomeDemo.values;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.x2l,
            AppSpacing.xl,
            AppSpacing.x4l,
          ),
          children: [
            Text(
              HomeStrings.greeting(name.split(' ').first),
              style: AppTypography.body.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              HomeStrings.title,
              style: AppTypography.display.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              HomeStrings.subtitle,
              style: AppTypography.body.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: AppSpacing.x2l),
            for (var i = 0; i < demos.length; i += 2) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              // IntrinsicHeight keeps both cards of a row the same height
              // whatever the text scale, without a fixed aspect ratio.
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _DemoCard(demos[i], onOpenDemo)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: i + 1 < demos.length
                          ? _DemoCard(demos[i + 1], onOpenDemo)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard(this.demo, this.onOpen);

  final HomeDemo demo;
  final ValueChanged<HomeDemo> onOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      key: ValueKey(demo),
      onTap: () => onOpen(demo),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBox(icon: demo.icon),
          const SizedBox(height: AppSpacing.lg),
          Text(
            demo.title,
            style: AppTypography.label.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            demo.hint,
            style: AppTypography.caption.copyWith(color: c.textMuted),
          ),
        ],
      ),
    );
  }
}
