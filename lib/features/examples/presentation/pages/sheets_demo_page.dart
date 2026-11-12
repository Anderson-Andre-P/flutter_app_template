import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/demo_selection_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Bottom sheet patterns: pick one option, a list of actions, free content.
class SheetsDemoPage extends StatelessWidget {
  const SheetsDemoPage({super.key});

  static const _sortKey = 'sort';
  static const _sorts = [
    ExamplesStrings.sortRecent,
    ExamplesStrings.sortOldest,
    ExamplesStrings.sortHighest,
  ];

  @override
  Widget build(BuildContext context) {
    final selection = context.read<DemoSelectionBloc>();

    Future<void> sort() async {
      final chosen = await AppBottomSheet.options<int>(
        context,
        title: ExamplesStrings.sortTitle,
        selected: selection.state.of(_sortKey),
        options: [
          for (var i = 0; i < _sorts.length; i++)
            AppSheetOption(value: i, label: _sorts[i]),
        ],
      );
      if (chosen == null || !context.mounted) return;
      selection.add(DemoSelected(_sortKey, chosen));
      AppSnackbar.info(context, ExamplesStrings.sortChosen(_sorts[chosen]));
    }

    Future<void> actions() async {
      const labels = [
        ExamplesStrings.actionEdit,
        ExamplesStrings.actionShare,
        ExamplesStrings.actionDelete,
      ];
      final chosen = await AppBottomSheet.options<int>(
        context,
        title: ExamplesStrings.actionsTitle,
        options: const [
          AppSheetOption(
            value: 0,
            label: ExamplesStrings.actionEdit,
            icon: Icons.edit_outlined,
          ),
          AppSheetOption(
            value: 1,
            label: ExamplesStrings.actionShare,
            icon: Icons.ios_share,
          ),
          AppSheetOption(
            value: 2,
            label: ExamplesStrings.actionDelete,
            icon: Icons.delete_outline,
            destructive: true,
          ),
        ],
      );
      if (chosen == null || !context.mounted) return;
      AppSnackbar.info(context, ExamplesStrings.actionChosen(labels[chosen]));
    }

    void content() => AppBottomSheet.show<void>(
      context,
      title: ExamplesStrings.contentTitle,
      message: ExamplesStrings.contentMessage,
      child: Builder(
        builder: (sheet) => Column(
          children: [
            const AppTextField(
              label: ExamplesStrings.contentField,
              hint: ExamplesStrings.contentFieldHint,
            ),
            SizedBox(height: AppSpacing.x2l),
            AppButton(
              label: ExamplesStrings.contentSave,
              onPressed: () => Navigator.of(sheet).pop(),
            ),
          ],
        ),
      ),
    );

    void filters() => AppBottomSheet.show<void>(
      context,
      title: ExamplesStrings.sheetFilters,
      actionLabel: ExamplesStrings.sheetFiltersClear,
      onAction: () =>
          AppSnackbar.info(context, ExamplesStrings.sheetFiltersCleared),
      child: Builder(
        builder: (sheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final label in ExamplesStrings.sheetFiltersStatus)
                  AppChip(label: label, onSelected: (_) {}),
              ],
            ),
            SizedBox(height: AppSpacing.x2l),
            AppButton(
              label: ExamplesStrings.sheetFiltersApply,
              onPressed: () => Navigator.of(sheet).pop(),
            ),
          ],
        ),
      ),
    );

    return DemoScaffold(
      title: ExamplesStrings.sheetsTitle,
      children: [
        DemoTrigger(
          title: ExamplesStrings.sheetOptions,
          hint: ExamplesStrings.sheetOptionsHint,
          onTap: sort,
        ),
        DemoTrigger(
          title: ExamplesStrings.sheetActions,
          hint: ExamplesStrings.sheetActionsHint,
          onTap: actions,
        ),
        DemoTrigger(
          title: ExamplesStrings.sheetFilters,
          hint: ExamplesStrings.sheetFiltersHint,
          onTap: filters,
        ),
        DemoTrigger(
          title: ExamplesStrings.sheetContent,
          hint: ExamplesStrings.sheetContentHint,
          onTap: content,
        ),
      ],
    );
  }
}
