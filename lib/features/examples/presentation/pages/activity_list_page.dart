import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../application/activity_list_bloc.dart';
import '../../application/view_status.dart';
import '../../domain/entities/activity.dart';
import '../examples_strings.dart';
import '../widgets/activity_tile.dart';

/// Example list: search, filter chips and items grouped by day.
class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key, required this.onOpen});

  /// Receives the tapped activity id.
  final ValueChanged<String> onOpen;

  static const _filters = [
    (ActivityFilter.all, ExamplesStrings.filterAll),
    (ActivityFilter.income, ExamplesStrings.filterIncome),
    (ActivityFilter.expense, ExamplesStrings.filterExpense),
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActivityListBloc>();
    return Scaffold(
      appBar: const AppTopBar(
        title: ExamplesStrings.statementTitle,
        showBack: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSearchField(
                  hint: ExamplesStrings.searchHint,
                  onChanged: (q) => bloc.add(ActivityQueryChanged(q)),
                ),
                SizedBox(height: AppSpacing.md),
                BlocSelector<
                  ActivityListBloc,
                  ActivityListState,
                  ActivityFilter
                >(
                  selector: (s) => s.filter,
                  builder: (context, filter) => Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final (value, label) in _filters)
                        AppChip(
                          label: label,
                          selected: filter == value,
                          onSelected: (_) =>
                              bloc.add(ActivityFilterChanged(value)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ActivityListBloc, ActivityListState>(
              builder: (context, state) => switch (state.status) {
                ViewStatus.initial ||
                ViewStatus.loading => const AppLoadingView(),
                ViewStatus.failure => AppErrorView(
                  title: ExamplesStrings.loadErrorTitle,
                  message: state.errorMessage ?? '',
                  retryLabel: ExamplesStrings.retry,
                  onRetry: () => bloc.add(const ActivityListStarted()),
                ),
                ViewStatus.ready => _List(items: state.visible, onOpen: onOpen),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.items, required this.onOpen});

  final List<Activity> items;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const AppEmptyView(
        icon: Icons.search_off,
        title: ExamplesStrings.emptyTitle,
        message: ExamplesStrings.emptyMessage,
      );
    }
    final c = context.colors;
    final now = DateTime.now();
    final children = <Widget>[];
    String? group;
    for (final a in items) {
      final label = dayLabel(a.date, now: now);
      if (label != group) {
        group = label;
        children.add(
          Padding(
            padding: EdgeInsets.only(
              top: children.isEmpty ? 0 : AppSpacing.lg,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              label,
              style: AppTypography.captionBold.copyWith(color: c.textMuted),
            ),
          ),
        );
      } else {
        children.add(SizedBox(height: AppSpacing.sm));
      }
      children.add(ActivityTile(activity: a, onTap: () => onOpen(a.id)));
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xs,
        AppSpacing.xl,
        AppSpacing.x4l,
      ),
      children: children,
    );
  }
}
