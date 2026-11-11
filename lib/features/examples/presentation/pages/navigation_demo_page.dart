import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings/common_strings.dart';
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
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_coach_mark.dart';
import '../../../../core/widgets/app_filter_bar.dart';
import '../../../../core/widgets/app_headers.dart';
import '../../../../core/widgets/app_settings_tile.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/app_tooltip.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_drag_handle.dart';
import '../../../../core/widgets/app_timeline.dart';
import '../../application/demo_selection_bloc.dart';
import '../../application/demo_tags_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Catalogue of the navigation pieces (design system, sections 20 and 25):
/// underlined and segmented tabs, accordion, stepper and step progress,
/// context menu and "Carregar mais"; and the tab and section headers and
/// the settings rows of the app components (section 35). State lives in
/// [DemoSelectionBloc].
class NavigationDemoPage extends StatelessWidget {
  const NavigationDemoPage({super.key});

  static const _tab = 'nav-tab';
  static const _period = 'nav-period';
  static const _faq = 'nav-faq';
  static const _step = 'nav-step';
  static const _pages = 'nav-pages';
  static const _coach = 'nav-coach';
  static const _reminders = 'nav-reminders';
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
    final gap = SizedBox(height: AppSpacing.lg);

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
              SizedBox(height: AppSpacing.md),
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
          title: ExamplesStrings.navBars,
          caption: ExamplesStrings.navBarsCaption,
          child: Column(
            children: [
              for (final bar in <PreferredSizeWidget>[
                AppTopBar(
                  title: ExamplesStrings.navBrand,
                  brand: true,
                  actions: [
                    AppNotificationButton(
                      count: 3,
                      onPressed: () => say(ExamplesStrings.navBrand),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: AppSpacing.md),
                      child: AppAvatar(
                        initials: ExamplesStrings.avatarInitials,
                        size: AppSizes.avatarMd,
                      ),
                    ),
                  ],
                ),
                AppTopBar(
                  title: ExamplesStrings.navBarTitle,
                  showBack: true,
                  onBack: () => say(CommonStrings.back),
                  actions: [
                    AppIconButton(
                      icon: Icons.edit_outlined,
                      label: ExamplesStrings.navBarEdit,
                      bordered: false,
                      onPressed: () => say(ExamplesStrings.navBarEdit),
                    ),
                  ],
                ),
                AppTopBar(
                  title: ExamplesStrings.navBrand,
                  brand: true,
                  leading: AppIconButton(
                    icon: Icons.menu,
                    label: ExamplesStrings.navMenuButton,
                    bordered: false,
                    onPressed: () => say(ExamplesStrings.navMenuButton),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: AppSpacing.md),
                      child: const AppBadge(
                        label: ExamplesStrings.navNewBadge,
                        tone: AppTone.primary,
                      ),
                    ),
                  ],
                ),
                AppViewerBar(
                  title: ExamplesStrings.navViewer,
                  position: ExamplesStrings.navViewerPosition,
                  onClose: () => say(CommonStrings.close),
                ),
              ]) ...[
                ClipRRect(
                  borderRadius: AppRadius.brMd,
                  child: SizedBox(height: bar.preferredSize.height, child: bar),
                ),
                SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navFilterBar,
          caption: ExamplesStrings.navFilterBarCaption,
          child: AppFilterBar(
            searchHint: ExamplesStrings.navFilterHint,
            onSearch: (_) {},
            activeFilters: 2,
            onFilters: () => say(ExamplesStrings.sheetFilters),
            onSort: () => say(CommonStrings.sort),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navHints,
          caption: ExamplesStrings.navHintsCaption,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppTooltip(
                  message: ExamplesStrings.navLocked,
                  child: Container(
                    width: AppSizes.minTouchTarget,
                    height: AppSizes.minTouchTarget,
                    decoration: BoxDecoration(
                      color: c.sunken,
                      borderRadius: AppRadius.brMd,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: AppSizes.iconTopBar,
                      color: c.textMuted,
                    ),
                  ),
                ),
              ),
              if (selection.of(_coach) == 0) ...[
                SizedBox(height: AppSpacing.md),
                AppCoachMark(
                  title: ExamplesStrings.navCoachTitle,
                  message: ExamplesStrings.navCoachMessage,
                  onDismiss: () => set(_coach, 1),
                ),
              ],
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navVertical,
          caption: ExamplesStrings.navVerticalCaption,
          child: AppCard(
            child: AppVerticalStepper(
              steps: [
                for (final (title, meta) in ExamplesStrings.navVerticalSteps)
                  AppTimelineEvent(title: title, meta: meta),
              ],
              current: 2,
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.navReorder,
          caption: ExamplesStrings.navReorderCaption,
          child: BlocProvider(
            create: (_) => DemoTagsBloc(ExamplesStrings.navReorderItems),
            child: BlocBuilder<DemoTagsBloc, List<String>>(
              builder: (context, items) => AppCard(
                padding: EdgeInsets.zero,
                child: ReorderableListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorderItem: (from, to) =>
                      context.read<DemoTagsBloc>().add(DemoTagMoved(from, to)),
                  children: [
                    for (final (i, item) in items.indexed)
                      Material(
                        key: ValueKey(item),
                        color: c.card,
                        child: AppListTile(
                          title: item,
                          leading: Text(
                            (i + 1).toString().padLeft(2, '0'),
                            style: AppTypography.caption.copyWith(
                              color: c.textMuted,
                            ),
                          ),
                          subtitle: i.isEven
                              ? ExamplesStrings.navReorderRequired
                              : ExamplesStrings.navReorderAttachment,
                          trailing: ReorderableDragStartListener(
                            index: i,
                            child: const AppDragHandle(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
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
        DemoSection(
          title: ExamplesStrings.tabHeader,
          caption: ExamplesStrings.tabHeaderCaption,
          child: AppTabHeader(
            overline: ExamplesStrings.tabHeaderOverline,
            title: ExamplesStrings.tabHeaderTitle,
            action: AppIconButton(
              icon: Icons.add,
              label: ExamplesStrings.tabHeaderAction,
              onPressed: () => say(ExamplesStrings.tabHeaderAction),
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.sectionHeader,
          caption: ExamplesStrings.sectionHeaderCaption,
          child: AppSectionHeader(
            title: ExamplesStrings.sectionHeaderTitle,
            actionLabel: ExamplesStrings.sectionHeaderAction,
            onAction: () => say(ExamplesStrings.sectionHeaderAction),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.settingsTiles,
          caption: ExamplesStrings.settingsTilesCaption,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppSettingsTile(
                  icon: Icons.palette_outlined,
                  title: ExamplesStrings.settingsTheme,
                  subtitle: ExamplesStrings.settingsThemeSubtitle,
                  detail: ExamplesStrings.settingsThemeDetail,
                  onTap: () => say(ExamplesStrings.settingsTheme),
                ),
                AppSettingsTile.toggle(
                  icon: Icons.notifications_none,
                  title: ExamplesStrings.settingsReminders,
                  subtitle: ExamplesStrings.settingsRemindersSubtitle,
                  checked: selection.of(_reminders, fallback: 1) == 1,
                  onChanged: (v) => set(_reminders, v ? 1 : 0),
                ),
                const AppSettingsTile.toggle(
                  icon: Icons.volume_up_outlined,
                  title: ExamplesStrings.settingsSound,
                  subtitle: ExamplesStrings.settingsSoundSubtitle,
                  detail: ExamplesStrings.settingsSoundDetail,
                  checked: false,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
