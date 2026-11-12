import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_attention_band.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_checkbox.dart';
import '../../../../core/widgets/app_dashed_button.dart';
import '../../../../core/widgets/app_fab.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_load_stepper.dart';
import '../../../../core/widgets/app_mini_stepper.dart';
import '../../../../core/widgets/app_radio.dart';
import '../../../../core/widgets/app_segmented_control.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_status_tile.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/demo_selection_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Catalogue of the selection controls (design system, section 09):
/// switch, checkbox, radio, segmented control, FAB, status tiles, the
/// success and dashed buttons, a read-only field and attention bands; and
/// the load and mini steppers of the app components (section 34).
/// Every value lives in the screen's [DemoSelectionBloc] (0 = off, 1 = on).
class ControlsDemoPage extends StatelessWidget {
  const ControlsDemoPage({super.key});

  static const _notifications = 'controls-notifications';
  static const _location = 'controls-location';
  static const _terms = 'controls-terms';
  static const _news = 'controls-news';
  static const _payment = 'controls-payment';
  static const _priority = 'controls-priority';
  static const _load = 'controls-load';
  static const _sets = 'controls-sets';
  static const _loadStart = 45;
  static const _previousLoad = 40;
  static const _setsStart = 3;

  /// 1 kg up to 5 kg, then 5 kg (design system, section 34).
  static int _stepFrom(int kg) => kg < 5 ? 1 : 5;
  static int _stepBelow(int kg) => kg <= 5 ? 1 : 5;

  @override
  Widget build(BuildContext context) {
    final selection = context.watch<DemoSelectionBloc>().state;
    bool on(String key, {bool fallback = false}) =>
        selection.of(key, fallback: fallback ? 1 : 0) == 1;
    void set(String key, int value) =>
        context.read<DemoSelectionBloc>().add(DemoSelected(key, value));
    void toggle(String key, bool value) => set(key, value ? 1 : 0);
    void tapped() => AppSnackbar.info(context, ExamplesStrings.tapped);
    final load = selection.of(_load, fallback: _loadStart);
    final up = _stepFrom(load);
    final down = _stepBelow(load);

    return DemoScaffold(
      title: ExamplesStrings.controlsTitle,
      children: [
        DemoSection(
          title: ExamplesStrings.controlsToggles,
          caption: ExamplesStrings.controlsTogglesCaption,
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSwitch(
                  label: ExamplesStrings.toggleNotifications,
                  value: on(_notifications, fallback: true),
                  onChanged: (v) => toggle(_notifications, v),
                ),
                AppSwitch(
                  label: ExamplesStrings.toggleLocation,
                  value: on(_location),
                  onChanged: (v) => toggle(_location, v),
                ),
                const AppSwitch(
                  label: ExamplesStrings.toggleDisabled,
                  value: true,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.controlsCheckboxes,
          caption: ExamplesStrings.controlsCheckboxesCaption,
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCheckbox(
                  label: ExamplesStrings.checkTerms,
                  value: on(_terms, fallback: true),
                  onChanged: (v) => toggle(_terms, v),
                ),
                AppCheckbox(
                  label: ExamplesStrings.checkNews,
                  value: on(_news),
                  onChanged: (v) => toggle(_news, v),
                ),
                const AppCheckbox(
                  label: ExamplesStrings.checkDisabled,
                  value: false,
                  onChanged: null,
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.controlsRadios,
          caption: ExamplesStrings.controlsRadiosCaption,
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, label) in ExamplesStrings.payments.indexed)
                  AppRadio<int>(
                    label: label,
                    value: i,
                    groupValue: selection.of(_payment),
                    onChanged: (v) => set(_payment, v),
                  ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.controlsSegmented,
          caption: ExamplesStrings.controlsSegmentedCaption,
          child: AppSegmentedControl<int>(
            segments: [
              for (final (i, label) in ExamplesStrings.priorities.indexed)
                AppSegment(value: i, label: label),
            ],
            selected: selection.of(_priority, fallback: 1),
            onChanged: (v) => set(_priority, v),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.controlsFab,
          caption: ExamplesStrings.controlsFabCaption,
          child: Row(
            children: [
              AppFab(
                icon: Icons.add,
                label: ExamplesStrings.fabNew,
                onPressed: tapped,
              ),
              SizedBox(width: AppSpacing.lg),
              AppFab(
                icon: Icons.add,
                label: ExamplesStrings.fabNew,
                extended: true,
                onPressed: tapped,
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.controlsTiles,
          caption: ExamplesStrings.controlsTilesCaption,
          child: Row(
            children: [
              const Expanded(
                child: AppStatusTile(
                  value: ExamplesStrings.tileOpenValue,
                  label: ExamplesStrings.tileOpen,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              const Expanded(
                child: AppStatusTile(
                  value: ExamplesStrings.tileLateValue,
                  label: ExamplesStrings.tileLate,
                  tone: AppTone.alert,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.controlsMoreButtons,
          caption: ExamplesStrings.controlsMoreButtonsCaption,
          child: Column(
            children: [
              AppButton(
                label: ExamplesStrings.buttonSuccess,
                variant: AppButtonVariant.success,
                onPressed: tapped,
              ),
              SizedBox(height: AppSpacing.md),
              AppDashedButton(
                label: ExamplesStrings.addItem,
                onPressed: tapped,
              ),
            ],
          ),
        ),
        const DemoSection(
          title: ExamplesStrings.controlsReadOnly,
          caption: ExamplesStrings.controlsReadOnlyCaption,
          child: AppTextField(
            label: ExamplesStrings.readOnlyLabel,
            initialValue: ExamplesStrings.readOnlyValue,
            readOnly: true,
          ),
        ),
        DemoSection(
          title: ExamplesStrings.controlsBand,
          caption: ExamplesStrings.controlsBandCaption,
          child: Column(
            children: [
              const AppAttentionBand(
                title: ExamplesStrings.bandTitle,
                message: ExamplesStrings.bandMessage,
              ),
              SizedBox(height: AppSpacing.md),
              const AppAttentionBand(
                title: ExamplesStrings.bandAlertTitle,
                message: ExamplesStrings.bandAlertMessage,
                tone: AppTone.alert,
                icon: Icons.edit_note_outlined,
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.loadStepper,
          caption: ExamplesStrings.loadStepperCaption,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AppLoadStepper(
              label: ExamplesStrings.loadLabel,
              value: '$load',
              unit: ExamplesStrings.loadUnit,
              hint: ExamplesStrings.loadPrevious(_previousLoad),
              decreaseLabel: ExamplesStrings.stepDown(down),
              increaseLabel: ExamplesStrings.stepUp(up),
              onDecrease: load <= 0 ? null : () => set(_load, load - down),
              onIncrease: () => set(_load, load + up),
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.miniStepper,
          caption: ExamplesStrings.miniStepperCaption,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: AppListTile(
              title: ExamplesStrings.miniStepperSets,
              trailing: AppMiniStepper(
                label: ExamplesStrings.miniStepperSets,
                value: selection.of(_sets, fallback: _setsStart),
                min: 1,
                max: 10,
                onChanged: (v) => set(_sets, v),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
