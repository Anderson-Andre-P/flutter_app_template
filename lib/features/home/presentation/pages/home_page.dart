import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_bloc.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/section_overline.dart';
import '../home_demo.dart';
import '../home_strings.dart';

/// Home tab: a two-column grid of cards, one per example screen.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onOpenDemo});

  final ValueChanged<HomeDemo> onOpenDemo;

  static const _groups = [
    (HomeDemoGroup.screens, HomeStrings.screensSection),
    (HomeDemoGroup.components, HomeStrings.componentsSection),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final name = context.select<SessionBloc, String>(
      (b) => b.state.user?.name ?? '',
    );
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
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
            SizedBox(height: AppSpacing.xs),
            Text(
              HomeStrings.title,
              style: AppTypography.display.copyWith(color: c.textPrimary),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              HomeStrings.subtitle,
              style: AppTypography.body.copyWith(color: c.textSecondary),
            ),
            SizedBox(height: AppSpacing.x2l),
            for (final (group, title) in _groups) ...[
              SectionOverline(title),
              SizedBox(height: AppSpacing.md),
              _Grid(
                demos: [
                  for (final d in HomeDemo.values)
                    if (d.group == group) d,
                ],
                onOpen: onOpenDemo,
              ),
              SizedBox(height: AppSpacing.x3l),
            ],
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.demos, required this.onOpen});

  final List<HomeDemo> demos;
  final ValueChanged<HomeDemo> onOpen;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < demos.length; i += 2) ...[
        if (i > 0) SizedBox(height: AppSpacing.md),
        // IntrinsicHeight keeps both cards of a row the same height
        // whatever the text scale, without a fixed aspect ratio.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _DemoCard(demos[i], onOpen)),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: i + 1 < demos.length
                    ? _DemoCard(demos[i + 1], onOpen)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    ],
  );
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
          SizedBox(height: AppSpacing.lg),
          Text(
            demo.title,
            style: AppTypography.label.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            demo.hint,
            style: AppTypography.caption.copyWith(color: c.textMuted),
          ),
        ],
      ),
    );
  }
}
