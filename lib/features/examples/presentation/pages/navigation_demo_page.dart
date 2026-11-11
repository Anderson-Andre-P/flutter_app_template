import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_accordion.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_button_group.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_load_more.dart';
import '../../../../core/widgets/app_more_menu.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_stepper.dart';
import '../../../../core/widgets/app_tabs.dart';
import '../../application/demo_selection_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Catalogue of the navigation pieces (design system, sections 20 and 25):
/// underlined and segmented tabs, accordion, stepper and step progress,
/// context menu and "Carregar mais". State lives in [DemoSelectionBloc].
class NavigationDemoPage extends StatelessWidget {
  const NavigationDemoPage({super.key});

  static const _tab = 'nav-tab';
  static const _period = 'nav-period';
  static const _faq = 'nav-faq';
  static const _step = 'nav-step';
  static const _pages = 'nav-pages';
  static const _closed = -1;
  static const _pageSize = 20;
  static const _total = 179;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final selection = context.watch<DemoSelectionBloc>().state;
    void set(String key, int value) =>
        context.read<DemoSelectionBloc>().add(DemoSelected(key, value));
    void say(String text) => AppSnackbar.info(context, text);

    final tab = selection.of(_tab);
    final faq = selection.of(_faq, fallback: 1);
    final step = selection.of(_step, fallback: 1);
    final pages = selection.of(_pages, fallback: 2);
    final shown = (pages * _pageSize).clamp(0, _total);
    const gap = SizedBox(height: AppSpacing.lg);

    return DemoScaffold(
      title: ExamplesStrings.navigationTitle,
      children: [
        DemoSection(
          title: ExamplesStrings.navigationTabs,
          caption: ExamplesStrings.navTabsCaption,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTabs(
                tabs: [
                  for (final (label, count) in ExamplesStrings.navTabItems)
                    AppTab(label: label, count: count),
                ],
                selected: tab,
                onChanged: (i) => set(_tab, i),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                ExamplesStrings.navTabBodies[tab],
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
              gap,
              AppSegmentedControl<int>(
                segments: [
                  for (final (i, label) in ExamplesStrings.navPeriods.indexed)
                    AppSegment(value: i, label: label),
                ],
                selected: selection.of(_period),
                onChanged: (i) => set(_period, i),
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navAccordion,
          caption: ExamplesStrings.navAccordionCaption,
          child: AppAccordion(
            items: [
              for (final (i, (title, body)) in ExamplesStrings.navFaq.indexed)
                AppAccordionItem(
                  title: title,
                  body: body,
                  icon: const [
                    Icons.add_box_outlined,
                    Icons.lock_outline,
                    Icons.wifi_off,
                  ][i],
                ),
            ],
            expanded: faq == _closed ? null : faq,
            onChanged: (i) => set(_faq, i ?? _closed),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navStepper,
          caption: ExamplesStrings.navStepperCaption,
          child: AppCard(
            child: Column(
              children: [
                AppStepper(steps: ExamplesStrings.navSteps, current: step),
                gap,
                AppStepProgress(
                  current: step + 1,
                  total: ExamplesStrings.navSteps.length,
                ),
                gap,
                AppButtonGroup.pair(
                  secondary: AppButton(
                    label: ExamplesStrings.navStepBack,
                    variant: AppButtonVariant.secondary,
                    size: AppButtonSize.md,
                    onPressed: step == 0 ? null : () => set(_step, step - 1),
                  ),
                  primary: AppButton(
                    label: ExamplesStrings.navStepNext,
                    size: AppButtonSize.md,
                    onPressed: step == ExamplesStrings.navSteps.length - 1
                        ? null
                        : () => set(_step, step + 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navMenu,
          caption: ExamplesStrings.navMenuCaption,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              title: ExamplesStrings.navMenuItem,
              trailing: AppMoreMenu(
                actions: [
                  for (final label in ExamplesStrings.navMenuActions)
                    AppMenuAction(label: label, onSelected: () => say(label)),
                  AppMenuAction(
                    label: ExamplesStrings.navMenuDelete,
                    destructive: true,
                    icon: Icons.delete_outline,
                    onSelected: () => say(ExamplesStrings.navMenuDelete),
                  ),
                ],
              ),
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navLoadMore,
          caption: ExamplesStrings.navLoadMoreCaption,
          child: AppLoadMore(
            label: ExamplesStrings.navLoadMoreLabel(_pageSize),
            summary: ExamplesStrings.navShowing(shown, _total),
            onPressed: shown >= _total ? null : () => set(_pages, pages + 1),
          ),
        ),
      ],
    );
  }
}
