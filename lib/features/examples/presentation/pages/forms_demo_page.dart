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
import '../../../../core/widgets/app_attachment.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_tag_field.dart';
import '../../application/demo_selection_bloc.dart';
import '../../application/demo_tags_bloc.dart';
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
  static const _rangeStart = 'forms-range-start';
  static const _rangeEnd = 'forms-range-end';
  static const _stepsSlider = 'forms-steps';
  static const _photos = 'forms-photos';
  static const _files = 'forms-files';
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
          title: ExamplesStrings.formsFieldVariants,
          caption: ExamplesStrings.formsFieldVariantsCaption,
          child: Column(
            children: [
              const AppTextField(
                label: ExamplesStrings.formsIdLabel,
                prefix: ExamplesStrings.formsIdPrefix,
                initialValue: ExamplesStrings.formsIdValue,
              ),
              gap,
              const AppTextField(
                label: ExamplesStrings.formsCpf,
                initialValue: ExamplesStrings.formsCpfValue,
                validated: true,
              ),
              gap,
              const AppTextField(
                label: ExamplesStrings.formsLocked,
                initialValue: ExamplesStrings.formsLockedValue,
                enabled: false,
              ),
              gap,
              BlocProvider(
                create: (_) => DemoTagsBloc(ExamplesStrings.formsInitialTags),
                child: BlocBuilder<DemoTagsBloc, List<String>>(
                  builder: (context, tags) => AppTagField(
                    label: ExamplesStrings.formsTags,
                    helper: ExamplesStrings.formsTagsHelper,
                    tags: tags,
                    onAdded: (t) =>
                        context.read<DemoTagsBloc>().add(DemoTagAdded(t)),
                    onRemoved: (i) =>
                        context.read<DemoTagsBloc>().add(DemoTagRemoved(i)),
                  ),
                ),
              ),
            ],
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
                gap,
                AppRangeSlider(
                  label: ExamplesStrings.formsDeadlineRange,
                  values: RangeValues(
                    selection.of(_rangeStart, fallback: 7).toDouble(),
                    selection.of(_rangeEnd, fallback: 21).toDouble(),
                  ),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  valueLabel: ExamplesStrings.days,
                  onChanged: (r) {
                    set(_rangeStart, r.start.round());
                    set(_rangeEnd, r.end.round());
                  },
                ),
                gap,
                AppSlider.steps(
                  label: ExamplesStrings.formsStepsSlider,
                  steps: ExamplesStrings.priorities,
                  index: selection.of(_stepsSlider, fallback: 2),
                  onChanged: (i) => set(_stepsSlider, i),
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
        DemoSection(
          title: ExamplesStrings.formsAttachments,
          caption: ExamplesStrings.formsAttachmentsCaption,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppUploadButton(
                label: ExamplesStrings.formsUpload,
                hint: ExamplesStrings.formsUploadHint,
                onPressed: () =>
                    AppSnackbar.info(context, ExamplesStrings.comingSoon),
              ),
              for (final (i, (name, detail))
                  in ExamplesStrings.formsFiles.indexed)
                // Bit i set = file i removed.
                if (selection.of(_files) & (1 << i) == 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppAttachmentTile(
                    name: name,
                    detail: detail,
                    status: AppAttachmentStatus.values[i],
                    progress: .72,
                    onOpen: () => AppSnackbar.info(context, name),
                    onCancel: () =>
                        set(_files, selection.of(_files) | (1 << i)),
                    onRemove: () =>
                        set(_files, selection.of(_files) | (1 << i)),
                  ),
                ],
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.formsPhotos,
          caption: ExamplesStrings.formsPhotosCaption,
          child: AppPhotoGrid(
            photos: List.filled(selection.of(_photos, fallback: 2), null),
            onRemove: (_) =>
                set(_photos, selection.of(_photos, fallback: 2) - 1),
            onCapture: () =>
                set(_photos, selection.of(_photos, fallback: 2) + 1),
          ),
        ),
      ],
    );
  }
}
