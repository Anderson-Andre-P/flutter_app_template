import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_bar_chart.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/section_overline.dart';
import '../examples_strings.dart';

/// Example dashboard: a goal with progress, a highlighted call to action
/// and a weekly bar chart.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.onStartTransfer});

  final VoidCallback onStartTransfer;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: const AppTopBar(
        title: ExamplesStrings.dashboardTitle,
        showBack: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.x4l,
        ),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionOverline(ExamplesStrings.goalOverline),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  ExamplesStrings.goalValue,
                  style: AppTypography.display.copyWith(color: c.textPrimary),
                ),
                Text(
                  ExamplesStrings.goalCaption,
                  style: AppTypography.caption.copyWith(color: c.textMuted),
                ),
                const SizedBox(height: AppSpacing.lg),
                const AppProgressBar(value: ExamplesStrings.goalProgress),
                const SizedBox(height: AppSpacing.md),
                Text(
                  ExamplesStrings.goalFooter,
                  style: AppTypography.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              color: c.primarySubtle,
              borderRadius: AppRadius.brLg,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ExamplesStrings.highlightOverline.toUpperCase(),
                    style: AppTypography.overline.copyWith(color: c.primary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    ExamplesStrings.highlightTitle,
                    style: AppTypography.heading.copyWith(color: c.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    ExamplesStrings.highlightCaption,
                    style: AppTypography.caption.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: ExamplesStrings.highlightAction,
                    onPressed: onStartTransfer,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x3l),
          Text(
            ExamplesStrings.weekTitle,
            style: AppTypography.section.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: AppBarChart(
              values: ExamplesStrings.weekValues,
              labels: ExamplesStrings.weekLabels,
              highlightIndex: DateTime.now().weekday - 1,
            ),
          ),
        ],
      ),
    );
  }
}
