import 'package:flutter/material.dart';

import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// The three screen states every list or detail needs.
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
            retryLabel: CommonStrings.retry,
            onRetry: () => AppSnackbar.info(context, CommonStrings.retry),
          ),
        ),
      ),
    ],
  );
}
