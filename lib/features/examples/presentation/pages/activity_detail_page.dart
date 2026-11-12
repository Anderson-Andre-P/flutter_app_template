import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_info_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../application/activity_detail_bloc.dart';
import '../../application/view_status.dart';
import '../../domain/entities/activity.dart';
import '../examples_strings.dart';

/// Example detail: hero icon, title, amount, status and an info card.
class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const AppTopBar(title: ExamplesStrings.detailTitle, showBack: true),
    body: BlocBuilder<ActivityDetailBloc, ActivityDetailState>(
      builder: (context, state) => switch (state.status) {
        ViewStatus.initial || ViewStatus.loading => const AppLoadingView(),
        ViewStatus.failure => AppEmptyView(
          icon: Icons.search_off,
          title: ExamplesStrings.emptyTitle,
          message: state.errorMessage ?? '',
        ),
        ViewStatus.ready => _Body(activity: state.activity!),
      },
    ),
  );
}

class _Body extends StatelessWidget {
  const _Body({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    void soon() => AppSnackbar.info(context, ExamplesStrings.comingSoon);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.x2l,
        AppSpacing.xl,
        AppSpacing.x4l,
      ),
      children: [
        Center(
          child: AppIconBox(
            icon: activity.isIncome
                ? Icons.south_west
                : Icons.shopping_bag_outlined,
            tone: activity.isIncome ? AppTone.success : AppTone.primary,
            size: AppSizes.heroIcon,
            circle: true,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          activity.title,
          textAlign: TextAlign.center,
          style: AppTypography.section.copyWith(color: c.textPrimary),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          formatCents(activity.amountCents, signed: true),
          textAlign: TextAlign.center,
          style: AppTypography.display.copyWith(color: c.textPrimary),
        ),
        SizedBox(height: AppSpacing.md),
        const Center(
          child: AppBadge(
            label: ExamplesStrings.statusDone,
            tone: AppTone.success,
          ),
        ),
        SizedBox(height: AppSpacing.x2l),
        AppInfoCard(
          title: ExamplesStrings.infoTitle,
          rows: [
            (ExamplesStrings.rowDate, formatDateTime(activity.date)),
            (ExamplesStrings.rowMethod, activity.method),
            (ExamplesStrings.rowCategory, activity.category),
            (ExamplesStrings.rowProtocol, activity.protocol),
          ],
        ),
        SizedBox(height: AppSpacing.x2l),
        AppButton(
          label: ExamplesStrings.shareReceipt,
          variant: AppButtonVariant.secondary,
          onPressed: soon,
        ),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: ExamplesStrings.dispute,
          variant: AppButtonVariant.ghost,
          onPressed: soon,
        ),
      ],
    );
  }
}
