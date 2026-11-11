import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_button_group.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_icon_box.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/app_list_tile.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../application/demo_selection_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Catalogue of the base widgets in `core/widgets`.
class WidgetsDemoPage extends StatelessWidget {
  const WidgetsDemoPage({super.key});

  static const _variants = [
    (AppButtonVariant.primary, ExamplesStrings.buttonPrimary),
    (AppButtonVariant.secondary, ExamplesStrings.buttonSecondary),
    (AppButtonVariant.outline, ExamplesStrings.buttonOutline),
    (AppButtonVariant.outlineSuccess, ExamplesStrings.buttonOutlineSuccess),
    (AppButtonVariant.tonal, ExamplesStrings.buttonTonal),
    (AppButtonVariant.ghost, ExamplesStrings.buttonGhost),
    (AppButtonVariant.destructive, ExamplesStrings.buttonDestructive),
    (AppButtonVariant.destructiveTonal, ExamplesStrings.buttonDestructiveTonal),
    (AppButtonVariant.success, ExamplesStrings.buttonSuccess2),
  ];

  static const _sizes = [
    (AppButtonSize.xl, ExamplesStrings.sizeXl),
    (AppButtonSize.lg, ExamplesStrings.sizeLg),
    (AppButtonSize.md, ExamplesStrings.sizeMd),
    (AppButtonSize.sm, ExamplesStrings.sizeSm),
    (AppButtonSize.xs, ExamplesStrings.sizeXs),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    void tapped() => AppSnackbar.info(context, ExamplesStrings.tapped);
    const gap = SizedBox(height: AppSpacing.md);

    return DemoScaffold(
      title: ExamplesStrings.widgetsTitle,
      children: [
        DemoSection(
          title: ExamplesStrings.buttons,
          child: Column(
            children: [
              for (final (variant, label) in _variants) ...[
                AppButton(label: label, variant: variant, onPressed: tapped),
                gap,
              ],
              const AppButton(
                label: ExamplesStrings.buttonDisabled,
                onPressed: null,
              ),
              gap,
              AppButton(
                label: ExamplesStrings.buttonLoading,
                loading: true,
                onPressed: tapped,
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.buttonSizes,
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final (size, label) in _sizes)
                AppButton(
                  label: label,
                  size: size,
                  expanded: false,
                  onPressed: tapped,
                ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.buttonIcons,
          caption: ExamplesStrings.buttonIconsCaption,
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(
                label: ExamplesStrings.buttonIconLeft,
                icon: Icons.add,
                size: AppButtonSize.md,
                expanded: false,
                onPressed: tapped,
              ),
              AppButton(
                label: ExamplesStrings.buttonIconRight,
                trailingIcon: Icons.arrow_forward,
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.md,
                expanded: false,
                onPressed: tapped,
              ),
              AppIconButton(
                icon: Icons.edit_outlined,
                label: ExamplesStrings.buttonIconOnly,
                onPressed: tapped,
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.buttonGroups,
          caption: ExamplesStrings.buttonGroupsCaption,
          child: Column(
            children: [
              AppButtonGroup.pair(
                secondary: AppButton(
                  label: ExamplesStrings.groupDiscard,
                  variant: AppButtonVariant.secondary,
                  onPressed: tapped,
                ),
                primary: AppButton(
                  label: ExamplesStrings.groupSave,
                  onPressed: tapped,
                ),
              ),
              gap,
              AppButtonGroup.triple(
                first: AppButton(
                  label: ExamplesStrings.groupBack,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.md,
                  onPressed: tapped,
                ),
                second: AppButton(
                  label: ExamplesStrings.groupSkip,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.md,
                  onPressed: tapped,
                ),
                primary: AppButton(
                  label: ExamplesStrings.groupContinue,
                  size: AppButtonSize.md,
                  onPressed: tapped,
                ),
              ),
              gap,
              AppButtonGroup.stacked(
                primary: AppButton(
                  label: ExamplesStrings.groupDelete,
                  variant: AppButtonVariant.destructive,
                  onPressed: tapped,
                ),
                secondary: AppButton(
                  label: ExamplesStrings.groupKeep,
                  variant: AppButtonVariant.secondary,
                  onPressed: tapped,
                ),
              ),
            ],
          ),
        ),
        const DemoSection(
          title: ExamplesStrings.fields,
          child: Column(
            children: [
              AppTextField(
                label: ExamplesStrings.fieldName,
                hint: ExamplesStrings.fieldNameHint,
                required: true,
              ),
              SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: ExamplesStrings.fieldEmail,
                errorText: ExamplesStrings.fieldEmailError,
              ),
              SizedBox(height: AppSpacing.lg),
              AppTextField(label: ExamplesStrings.fieldPassword, obscure: true),
              SizedBox(height: AppSpacing.lg),
              AppSearchField(hint: ExamplesStrings.fieldSearch),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.chips,
          child: BlocSelector<DemoSelectionBloc, DemoSelectionState, int>(
            selector: (s) => s.of('chips'),
            builder: (context, selected) => Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (var i = 0; i < ExamplesStrings.chipLabels.length; i++)
                  AppChip(
                    label: ExamplesStrings.chipLabels[i],
                    selected: i == selected,
                    onSelected: (_) => context.read<DemoSelectionBloc>().add(
                      DemoSelected('chips', i),
                    ),
                  ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.badges,
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < AppTone.values.length; i++)
                AppBadge(
                  label: ExamplesStrings.badgeLabels[i],
                  tone: AppTone.values[i],
                ),
            ],
          ),
        ),
        const DemoSection(
          title: ExamplesStrings.avatars,
          child: Row(
            children: [
              AppAvatar(
                initials: ExamplesStrings.avatarInitials,
                size: AppSizes.avatarSm,
              ),
              SizedBox(width: AppSpacing.md),
              AppAvatar(
                initials: ExamplesStrings.avatarInitials,
                size: AppSizes.avatarMd,
              ),
              SizedBox(width: AppSpacing.md),
              AppAvatar(initials: ExamplesStrings.avatarInitials),
              SizedBox(width: AppSpacing.md),
              AppAvatar(
                initials: ExamplesStrings.avatarInitials,
                size: AppSizes.avatarXl,
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.icons,
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              for (final tone in AppTone.values)
                AppIconBox(icon: Icons.star_outline, tone: tone),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.lists,
          child: AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (title, subtitle) in ExamplesStrings.listItems)
                  AppListTile(
                    title: title,
                    subtitle: subtitle,
                    leading: const AppIconBox(icon: Icons.tune),
                    trailing: Icon(Icons.chevron_right, color: c.textMuted),
                    onTap: tapped,
                  ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: ExamplesStrings.cards,
          child: AppCard(
            onTap: tapped,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ExamplesStrings.cardTitle,
                  style: AppTypography.section.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  ExamplesStrings.cardBody,
                  style: AppTypography.body.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
