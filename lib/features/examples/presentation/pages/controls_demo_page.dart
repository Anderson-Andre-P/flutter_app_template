import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_attention_band.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_checkbox.dart';
import '../../../../core/widgets/app_dashed_button.dart';
import '../../../../core/widgets/app_fab.dart';
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
/// success and dashed buttons, a read-only field and attention bands.
/// Every value lives in the screen's [DemoSelectionBloc] (0 = off, 1 = on).
class ControlsDemoPage extends StatelessWidget {
  const ControlsDemoPage({super.key});

  static const _notifications = 'controls-notifications';
  static const _location = 'controls-location';
  static const _terms = 'controls-terms';
  static const _news = 'controls-news';
  static const _payment = 'controls-payment';
  static const _priority = 'controls-priority';

  @override
  Widget build(BuildContext context) {
    final selection = context.watch<DemoSelectionBloc>().state;
    bool on(String key, {bool fallback = false}) =>
        selection.of(key, fallback: fallback ? 1 : 0) == 1;
    void set(String key, int value) =>
        context.read<DemoSelectionBloc>().add(DemoSelected(key, value));
    void toggle(String key, bool value) => set(key, value ? 1 : 0);
    void tapped() => AppSnackbar.info(context, ExamplesStrings.tapped);

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
              const SizedBox(width: AppSpacing.lg),
              AppFab(
                icon: Icons.add,
                label: ExamplesStrings.fabNew,
                extended: true,
                onPressed: tapped,
              ),
            ],
          ),
        ),
        const DemoSection(
          title: ExamplesStrings.controlsTiles,
          caption: ExamplesStrings.controlsTilesCaption,
          child: Row(
            children: [
              Expanded(
                child: AppStatusTile(
                  value: ExamplesStrings.tileOpenValue,
                  label: ExamplesStrings.tileOpen,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
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
              const SizedBox(height: AppSpacing.md),
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
        const DemoSection(
          title: ExamplesStrings.controlsBand,
          caption: ExamplesStrings.controlsBandCaption,
          child: Column(
            children: [
              AppAttentionBand(
                title: ExamplesStrings.bandTitle,
                message: ExamplesStrings.bandMessage,
              ),
              SizedBox(height: AppSpacing.md),
              AppAttentionBand(
                title: ExamplesStrings.bandAlertTitle,
                message: ExamplesStrings.bandAlertMessage,
                tone: AppTone.alert,
                icon: Icons.edit_note_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
