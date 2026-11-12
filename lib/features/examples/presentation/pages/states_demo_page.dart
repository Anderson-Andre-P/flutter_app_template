import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_inline_alert.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// The screen states every list or detail needs — loading, empty, error
/// and offline — plus an inline alert and a skeleton list.
class StatesDemoPage extends StatelessWidget {
  const StatesDemoPage({super.key});

  @override
  Widget build(BuildContext context) => DemoScaffold(
    title: ExamplesStrings.statesTitle,
    children: [
      const DemoSection(
        title: ExamplesStrings.stateLoading,
        child: AppCard(child: AppLoadingView()),
      ),
      DemoSection(
        title: ExamplesStrings.stateEmpty,
        child: AppCard(
          child: AppEmptyView(
            icon: Icons.inbox_outlined,
            title: ExamplesStrings.stateEmptyTitle,
            message: ExamplesStrings.stateEmptyMessage,
            actionLabel: ExamplesStrings.stateEmptyAction,
            onAction: () =>
                AppSnackbar.info(context, ExamplesStrings.comingSoon),
          ),
        ),
      ),
      DemoSection(
        title: ExamplesStrings.stateError,
        child: AppCard(
          child: AppErrorView(
            title: ExamplesStrings.stateErrorTitle,
            message: ExamplesStrings.stateErrorMessage,
            code: ExamplesStrings.stateErrorCode,
            retryLabel: CommonStrings.retry,
            onRetry: () => AppSnackbar.info(context, CommonStrings.retry),
            secondaryLabel: ExamplesStrings.stateReport,
            onSecondary: () =>
                AppSnackbar.info(context, ExamplesStrings.comingSoon),
          ),
        ),
      ),
      const DemoSection(
        title: ExamplesStrings.stateOffline,
        child: AppCard(child: AppOfflineView(pending: 3)),
      ),
      const DemoSection(
        title: ExamplesStrings.stateInline,
        child: AppInlineAlert(message: ExamplesStrings.stateInlineMessage),
      ),
      DemoSection(
        title: ExamplesStrings.stateSkeleton,
        caption: ExamplesStrings.stateSkeletonCaption,
        child: AppCard(
          child: AppShimmer(
            child: Column(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      AppSkeleton.circle(size: AppSizes.avatarLg),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppSkeleton.line(),
                            SizedBox(height: AppSpacing.sm),
                            AppSkeleton.line(width: AppSizes.skeletonShortLine),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
