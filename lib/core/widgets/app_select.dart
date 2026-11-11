import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import '../utils/search.dart';
import 'app_bottom_sheet.dart';
import 'app_interactive.dart';
import 'app_menu_style.dart';
import 'app_search_field.dart';

/// One choice of an [AppSelect].
class AppSelectOption<T> {
  const AppSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Select of the design system (section 25): the label always above, the
/// value (or "Selecione uma opção") in a 48px box with a caret, the error
/// below. Up to [maxInline] options open as a list right below the field —
/// never covering it — with the current option tinted and marked. More
/// options open a bottom sheet with a search, accent-insensitive.
class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.hint = CommonStrings.selectHint,
    this.errorText,
    this.required = false,
  });

  final String label;
  final List<AppSelectOption<T>> options;
  final T? value;

  /// `null` disables the select.
  final ValueChanged<T>? onChanged;
  final String hint;
  final String? errorText;
  final bool required;

  static const maxInline = 7;
  static const fieldKey = ValueKey('app-select-field');
  static const selectedMarkKey = ValueKey('app-select-selected');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final selected = options.where((o) => o.value == value).firstOrNull;
    Widget box(VoidCallback? onTap) => _SelectBox(
      text: selected?.label ?? hint,
      placeholder: selected == null,
      error: errorText != null,
      onTap: onChanged == null ? null : onTap,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          required ? '$label *' : label,
          style: AppTypography.label.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (options.length > maxInline)
          box(() async {
            final picked = await AppBottomSheet.show<T>(
              context,
              title: label,
              child: BlocProvider(
                create: (_) => _QueryBloc(),
                child: _SearchableOptions<T>(options: options, value: value),
              ),
            );
            if (picked != null) onChanged?.call(picked);
          })
        else
          LayoutBuilder(
            builder: (context, constraints) => MenuAnchor(
              alignmentOffset: const Offset(0, AppSpacing.xs),
              style: AppMenuStyle.menu(context, width: constraints.maxWidth),
              menuChildren: [
                for (final o in options)
                  _OptionItem(
                    label: o.label,
                    selected: o.value == value,
                    onPressed: () => onChanged?.call(o.value),
                  ),
              ],
              builder: (context, menu, _) =>
                  box(() => menu.isOpen ? menu.close() : menu.open()),
            ),
          ),
        if (errorText case final error?) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(error, style: AppTypography.caption.copyWith(color: c.danger)),
        ],
      ],
    );
  }
}

class _SelectBox extends StatelessWidget {
  const _SelectBox({
    required this.text,
    required this.placeholder,
    required this.error,
    required this.onTap,
  });

  final String text;
  final bool placeholder;
  final bool error;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    return Container(
      key: AppSelect.fieldKey,
      height: AppSizes.field,
      foregroundDecoration: error
          ? BoxDecoration(
              borderRadius: AppRadius.brMd,
              border: Border.all(color: c.danger, width: AppSizes.errorBorder),
            )
          : null,
      child: MergeSemantics(
        child: Semantics(
          button: true,
          enabled: enabled,
          child: AppInteractive(
            onTap: onTap,
            borderRadius: AppRadius.brMd,
            surface: (state) => (
              color: !enabled
                  ? c.sunken
                  : error
                  ? c.dangerSubtle
                  : c.field,
              border: enabled ? c.borderStrong : null,
              shadows: const <BoxShadow>[],
            ),
            builder: (context, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body.copyWith(
                        color: !enabled
                            ? c.textDisabled
                            : placeholder
                            ? c.textMuted
                            : c.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: AppSizes.iconTopBar,
                    color: enabled ? c.textMuted : c.textDisabled,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  const _OptionItem({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MenuItemButton(
      onPressed: onPressed,
      style: AppMenuStyle.item(context, selected: selected),
      trailingIcon: selected
          ? Container(
              key: AppSelect.selectedMarkKey,
              width: AppSpacing.sm,
              height: AppSpacing.sm,
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
      child: Text(
        label,
        style: (selected ? AppTypography.label : AppTypography.body).copyWith(
          color: selected ? c.primary : c.textPrimary,
        ),
      ),
    );
  }
}

/// The search text of a long option list — UI-only state.
class _QueryBloc extends Bloc<String, String> {
  _QueryBloc() : super('') {
    on<String>((query, emit) => emit(query));
  }
}

class _SearchableOptions<T> extends StatelessWidget {
  const _SearchableOptions({required this.options, required this.value});

  final List<AppSelectOption<T>> options;
  final T? value;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final query = normalizeForSearch(context.watch<_QueryBloc>().state);
    final shown = [
      for (final o in options)
        if (normalizeForSearch(o.label).contains(query)) o,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchField(
          hint: CommonStrings.searchHint,
          onChanged: context.read<_QueryBloc>().add,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              CommonStrings.noResults,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: c.textMuted),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: AppSizes.listTileMin * 6,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final o in shown)
                  ListTile(
                    title: Text(
                      o.label,
                      style:
                          (o.value == value
                                  ? AppTypography.label
                                  : AppTypography.body)
                              .copyWith(
                                color: o.value == value
                                    ? c.primary
                                    : c.textPrimary,
                              ),
                    ),
                    selected: o.value == value,
                    selectedTileColor: c.primarySubtle,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.brSm,
                    ),
                    onTap: () => Navigator.of(context).pop(o.value),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
