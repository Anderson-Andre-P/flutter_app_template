import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_number_stepper.dart';
import '../../../../core/widgets/app_select.dart';
import '../../../../core/widgets/app_slider.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_time_field.dart';
import '../../application/demo_selection_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Catalogue of the form inputs (design system, sections 14, 25 to 27):
/// text area, select, date and time, slider and numeric stepper. Values
/// live in the screen's [DemoSelectionBloc] as ints (a date as
/// milliseconds, a time as minutes of the day).
class FormsDemoPage extends StatelessWidget {
  const FormsDemoPage({super.key});

  static const _priority = 'forms-priority';
  static const _city = 'forms-city';
  static const _deadline = 'forms-deadline';
  static const _time = 'forms-time';
  static const _volume = 'forms-volume';
  static const _tolerance = 'forms-tolerance';
  static const _quantity = 'forms-quantity';
  static const _none = -1;

  @override
  Widget build(BuildContext context) {
    final selection = context.watch<DemoSelectionBloc>().state;
    void set(String key, int value) =>
        context.read<DemoSelectionBloc>().add(DemoSelected(key, value));
    int? read(String key) {
      final v = selection.of(key, fallback: _none);
      return v == _none ? null : v;
    }

    final today = DateUtils.dateOnly(DateTime.now());
    final deadlineMs = read(_deadline);
    final deadline = deadlineMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(deadlineMs);
    final minutes = read(_time);
    const gap = SizedBox(height: AppSpacing.lg);

    return DemoScaffold(
      title: ExamplesStrings.formsTitle,
      children: [
        const DemoSection(
          title: ExamplesStrings.formsText,
          caption: ExamplesStrings.formsTextCaption,
          child: AppTextField(
            label: ExamplesStrings.formsDescription,
            hint: ExamplesStrings.formsDescriptionHint,
            minLines: 3,
            maxLength: 400,
          ),
        ),
        DemoSection(
          title: ExamplesStrings.formsSelect,
          caption: ExamplesStrings.formsSelectCaption,
          child: Column(
            children: [
              AppSelect<int>(
                label: ExamplesStrings.formsPriority,
                required: true,
                options: [
                  for (final (i, label) in ExamplesStrings.priorities.indexed)
                    AppSelectOption(value: i, label: label),
                ],
                value: read(_priority),
                onChanged: (v) => set(_priority, v),
              ),
              gap,
              AppSelect<int>(
                label: ExamplesStrings.formsCity,
                options: [
                  for (final (i, label) in ExamplesStrings.cities.indexed)
                    AppSelectOption(value: i, label: label),
                ],
                value: read(_city),
                onChanged: (v) => set(_city, v),
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.formsDateTime,
          caption: ExamplesStrings.formsDateTimeCaption,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: AppDateField(
                      label: ExamplesStrings.formsDeadline,
                      required: true,
                      value: deadline,
                      firstDate: today,
                      errorText: deadline != null && deadline.isBefore(today)
                          ? ExamplesStrings.formsDeadlinePast
                          : null,
                      onChanged: (d) =>
                          set(_deadline, d?.millisecondsSinceEpoch ?? _none),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: AppTimeField(
                      label: ExamplesStrings.formsTime,
                      value: minutes == null
                          ? null
                          : (hour: minutes ~/ 60, minute: minutes % 60),
                      onChanged: (t) => set(
                        _time,
                        t == null ? _none : t.hour * 60 + t.minute,
                      ),
                    ),
                  ),
                ],
              ),
              gap,
              AppDateField(
                label: ExamplesStrings.formsSystemDate,
                hint: ExamplesStrings.formsSystemDateHint,
                enabled: false,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.formsSliders,
          caption: ExamplesStrings.formsSlidersCaption,
          child: AppCard(
            child: Column(
              children: [
                AppSlider(
                  label: ExamplesStrings.formsVolume,
                  value: selection.of(_volume, fallback: 60).toDouble(),
                  max: 100,
                  valueLabel: ExamplesStrings.percent0,
                  onChanged: (v) => set(_volume, v.round()),
                ),
                gap,
                AppSlider(
                  label: ExamplesStrings.formsTolerance,
                  value: selection.of(_tolerance, fallback: 12).toDouble(),
                  max: 20,
                  divisions: 20,
                  valueLabel: ExamplesStrings.units,
                  onChanged: (v) => set(_tolerance, v.round()),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.formsStepper,
          caption: ExamplesStrings.formsStepperCaption,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppNumberStepper(
              label: ExamplesStrings.formsQuantity,
              value: selection.of(_quantity, fallback: 3),
              min: 1,
              onChanged: (v) => set(_quantity, v),
            ),
          ),
        ),
      ],
    );
  }
}
