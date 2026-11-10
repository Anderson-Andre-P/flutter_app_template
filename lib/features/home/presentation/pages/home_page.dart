import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/session_bloc.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/section_overline.dart';
import '../../application/home_filter_bloc.dart';
import '../home_strings.dart';

/// Example home tab built only from `core/widgets` and theme tokens —
/// replace its content with the app's own.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.select<SessionBloc, String>(
      (b) => b.state.user?.name ?? '',
    );
    final firstName = name.split(' ').first;
    return BlocProvider(
      create: (_) => HomeFilterBloc(),
      child: Scaffold(
        appBar: AppTopBar(title: HomeStrings.greeting(firstName)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.x4l,
          ),
          children: [
            const SectionOverline(HomeStrings.summary),
            const SizedBox(height: AppSpacing.md),
            const _SummaryCard(
              title: HomeStrings.weekTitle,
              body: HomeStrings.weekBody,
              badges: [
                AppBadge(label: HomeStrings.onTrack, tone: AppTone.success),
                AppBadge(label: HomeStrings.pending, tone: AppTone.alert),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const _SummaryCard(
              title: HomeStrings.reviewTitle,
              body: HomeStrings.reviewBody,
              badges: [
                AppBadge(label: HomeStrings.scheduled, tone: AppTone.info),
              ],
            ),
            const SizedBox(height: AppSpacing.x3l),
            const SectionOverline(HomeStrings.activity),
            const SizedBox(height: AppSpacing.md),
            const _Filters(),
            const SizedBox(height: AppSpacing.lg),
            const AppCard(
              child: AppEmptyView(
                icon: Icons.inbox_outlined,
                title: HomeStrings.emptyTitle,
                message: HomeStrings.emptyMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.body,
    required this.badges,
  });

  final String title;
  final String body;
  final List<Widget> badges;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.section.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            style: AppTypography.body.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: badges,
          ),
        ],
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) {
    final selected = context.select<HomeFilterBloc, int>(
      (b) => b.state.selected,
    );
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (var i = 0; i < HomeStrings.filters.length; i++)
          AppChip(
            label: HomeStrings.filters[i],
            selected: i == selected,
            onSelected: (_) =>
                context.read<HomeFilterBloc>().add(HomeFilterSelected(i)),
          ),
      ],
    );
  }
}
