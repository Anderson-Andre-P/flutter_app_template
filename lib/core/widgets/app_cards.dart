import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_avatar.dart';
import 'app_badge.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'app_icon_button.dart';
import 'app_number_stepper.dart';
import 'app_progress_bar.dart';
import 'app_text_field.dart';
import 'section_overline.dart';

// Card anatomies of the design system (section 12). Every one is an
// [AppCard]: radius, 1px border, the light shadow; media bleeds to the edge
// and the inner padding never goes below 14px.

/// Title and a short body, a metadata line at the foot. No action.
class AppBasicCard extends StatelessWidget {
  const AppBasicCard({
    super.key,
    required this.title,
    required this.body,
    this.overline,
    this.footer,
  });

  final String? overline;
  final String title;
  final String body;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Heading(overline: overline, title: title),
          SizedBox(height: AppSpacing.sm),
          _Body(body),
          if (footer case final f?) ...[
            SizedBox(height: AppSpacing.lg),
            Divider(height: AppSizes.hairline, color: c.border),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Container(
                  width: AppSizes.pageDot,
                  height: AppSizes.pageDot,
                  decoration: BoxDecoration(
                    color: c.success,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    f,
                    style: AppTypography.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Media on top, bleeding to the edges, an optional badge over it.
class AppMediaCard extends StatelessWidget {
  const AppMediaCard({
    super.key,
    required this.media,
    required this.title,
    this.overline,
    this.meta,
    this.badge,
    this.badgeTone = AppTone.success,
  });

  final Widget media;
  final String? overline;
  final String title;
  final String? meta;
  final String? badge;
  final AppTone badgeTone;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: AppSizes.cardMedia,
            child: Stack(
              fit: StackFit.expand,
              children: [
                media,
                if (badge case final b?)
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: AppBadge(label: b, tone: badgeTone),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Heading(overline: overline, title: title),
                if (meta case final m?) ...[
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    m,
                    style: AppTypography.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// How far something is, and the action that moves it on.
class AppProgressCard extends StatelessWidget {
  const AppProgressCard({
    super.key,
    required this.title,
    required this.body,
    required this.progress,
    required this.actionLabel,
    required this.onAction,
    this.overline,
  });

  final String? overline;
  final String title;
  final String body;
  final double progress;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Heading(overline: overline, title: title),
        SizedBox(height: AppSpacing.sm),
        _Body(body),
        SizedBox(height: AppSpacing.lg),
        AppProgressBar(value: progress),
        SizedBox(height: AppSpacing.lg),
        AppButton(
          label: actionLabel,
          size: AppButtonSize.md,
          onPressed: onAction,
        ),
      ],
    ),
  );
}

/// Summary with a "Ver tudo →" link to the full content.
class AppLinkCard extends StatelessWidget {
  const AppLinkCard({
    super.key,
    required this.title,
    required this.body,
    required this.linkLabel,
    required this.onLink,
    this.overline,
  });

  final String? overline;
  final String title;
  final String body;
  final String linkLabel;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Heading(overline: overline, title: title),
          SizedBox(height: AppSpacing.sm),
          _Body(body),
          SizedBox(height: AppSpacing.md),
          Divider(height: AppSizes.hairline, color: c.border),
          AppButton(
            label: linkLabel,
            trailingIcon: Icons.arrow_forward,
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.sm,
            expanded: false,
            onPressed: onLink,
          ),
        ],
      ),
    );
  }
}

/// List item with a visual: fixed-width thumbnail on the left, the content
/// on the right with a badge, the owner and a date.
class AppHorizontalCard extends StatelessWidget {
  const AppHorizontalCard({
    super.key,
    required this.thumbnail,
    required this.title,
    this.overline,
    this.badge,
    this.badgeTone = AppTone.alert,
    this.body,
    this.ownerInitials,
    this.ownerLabel,
    this.date,
    this.onTap,
  });

  final Widget thumbnail;
  final String? overline;
  final String? badge;
  final AppTone badgeTone;
  final String title;
  final String? body;
  final String? ownerInitials;
  final String? ownerLabel;
  final String? date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: AppSizes.cardThumb, child: thumbnail),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (overline case final o?) ...[
                          Flexible(child: SectionOverline(o)),
                          SizedBox(width: AppSpacing.sm),
                        ],
                        if (badge case final b?)
                          AppBadge(label: b, tone: badgeTone),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      title,
                      style: AppTypography.label.copyWith(color: c.textPrimary),
                    ),
                    if (body case final b?) ...[
                      SizedBox(height: AppSpacing.xs),
                      _Body(b),
                    ],
                    if (ownerLabel != null || date != null) ...[
                      SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          if (ownerInitials case final i?) ...[
                            AppAvatar(initials: i, size: AppSizes.avatarSm),
                            SizedBox(width: AppSpacing.sm),
                          ],
                          if (ownerLabel case final l?)
                            Expanded(
                              child: Text(
                                l,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.caption.copyWith(
                                  color: c.textMuted,
                                ),
                              ),
                            )
                          else
                            const Spacer(),
                          if (date case final d?)
                            Text(
                              d,
                              style: AppTypography.caption.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Record a value on the spot: the field with its unit and the save
/// button, the accepted range below and a required attachment.
class AppFieldCard extends StatelessWidget {
  const AppFieldCard({
    super.key,
    required this.title,
    required this.fieldLabel,
    required this.actionLabel,
    required this.onAction,
    this.unit,
    this.help,
    this.initialValue,
    this.attachmentLabel,
    this.requiredLabel,
    this.onAttach,
  });

  final String title;
  final String fieldLabel;
  final String? unit;
  final String? help;
  final String? initialValue;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? attachmentLabel;
  final String? requiredLabel;
  final VoidCallback? onAttach;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTypography.label.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AppTextField(
                  label: fieldLabel,
                  initialValue: initialValue,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  suffix: unit == null
                      ? null
                      : Padding(
                          padding: EdgeInsetsDirectional.only(
                            end: AppSpacing.md,
                          ),
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              unit!,
                              style: AppTypography.caption.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              AppButton(
                label: actionLabel,
                expanded: false,
                onPressed: onAction,
              ),
            ],
          ),
          if (help case final h?) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppSizes.iconChip,
                  color: c.textMuted,
                ),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    h,
                    style: AppTypography.caption.copyWith(color: c.textMuted),
                  ),
                ),
              ],
            ),
          ],
          if (attachmentLabel case final a?) ...[
            SizedBox(height: AppSpacing.md),
            Divider(height: AppSizes.hairline, color: c.border),
            InkWell(
              onTap: onAttach,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: AppSizes.listTileMin),
                child: Row(
                  children: [
                    Container(
                      width: AppSizes.avatarLg - AppSpacing.xs,
                      height: AppSizes.avatarLg - AppSpacing.xs,
                      decoration: BoxDecoration(
                        color: c.primarySubtle,
                        borderRadius: AppRadius.brSm,
                      ),
                      child: Icon(
                        Icons.photo_camera_outlined,
                        size: AppSizes.iconField,
                        color: c.primary,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        a,
                        style: AppTypography.labelMedium.copyWith(
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    if (requiredLabel case final r?)
                      Flexible(
                        child: AppBadge(label: r, tone: AppTone.alert),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// E-commerce product: discount badge and favourite over the photo, star
/// rating, price with the old one struck through, quantity and add.
class AppProductCard extends StatelessWidget {
  const AppProductCard({
    super.key,
    required this.media,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onQuantity,
    required this.addLabel,
    required this.onAdd,
    this.overline,
    this.discount,
    this.favorite = false,
    this.onFavorite,
    this.rating,
    this.ratingLabel,
    this.oldPrice,
  });

  final Widget media;
  final String? overline;
  final String title;
  final String? discount;
  final bool favorite;
  final VoidCallback? onFavorite;

  /// 0 to 5.
  final double? rating;
  final String? ratingLabel;
  final String price;
  final String? oldPrice;
  final int quantity;
  final ValueChanged<int> onQuantity;
  final String addLabel;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: AppSizes.cardMedia,
            child: Stack(
              fit: StackFit.expand,
              children: [
                media,
                if (discount case final d?)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: c.danger,
                        borderRadius: AppRadius.brXs,
                      ),
                      child: Text(
                        d,
                        style: AppTypography.microBold.copyWith(color: c.card),
                      ),
                    ),
                  ),
                if (onFavorite case final fav?)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: AppIconButton(
                      icon: favorite ? Icons.favorite : Icons.favorite_border,
                      label: CommonStrings.favorite,
                      bordered: false,
                      onPressed: fav,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Heading(overline: overline, title: title),
                if (rating case final r?) ...[
                  SizedBox(height: AppSpacing.xs),
                  Semantics(
                    label: CommonStrings.rating(r),
                    child: ExcludeSemantics(
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          for (var i = 1; i <= 5; i++)
                            Icon(
                              i <= r.round() ? Icons.star : Icons.star_border,
                              size: AppSizes.iconChip,
                              color: c.alert,
                            ),
                          if (ratingLabel case final l?) ...[
                            Text(
                              l,
                              style: AppTypography.caption.copyWith(
                                color: c.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      price,
                      style: AppTypography.heading.copyWith(
                        color: c.textPrimary,
                      ),
                    ),
                    if (oldPrice case final o?) ...[
                      Text(
                        o,
                        style: AppTypography.caption.copyWith(
                          color: c.textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    SizedBox(
                      width: AppSizes.numberStepper,
                      child: AppNumberStepper(
                        label: title,
                        compact: true,
                        value: quantity,
                        min: 1,
                        onChanged: onQuantity,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: addLabel,
                        size: AppButtonSize.md,
                        onPressed: onAdd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Invites the first step when there is nothing yet: the primary surface,
/// a light button and a secondary link.
class AppCtaCard extends StatelessWidget {
  const AppCtaCard({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.overline,
    this.linkLabel,
    this.onLink,
  });

  final String? overline;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? linkLabel;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = c.onPrimary;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.elev2,
      ),
      child: Material(
        color: c.primary,
        borderRadius: AppRadius.brLg,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Decorative disc in the corner, as in the design system.
            Positioned(
              top: -AppSizes.cardMedia / 2,
              right: -AppSizes.cardMedia / 2,
              child: Container(
                width: AppSizes.cardMedia * 1.4,
                height: AppSizes.cardMedia * 1.4,
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: .08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (overline case final o?)
                    Text(
                      o.toUpperCase(),
                      style: AppTypography.overline.copyWith(
                        color: fg.withValues(alpha: .8),
                      ),
                    ),
                  SizedBox(height: AppSpacing.sm),
                  Text(title, style: AppTypography.heading.copyWith(color: fg)),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    body,
                    style: AppTypography.bodySmall.copyWith(
                      color: fg.withValues(alpha: .9),
                    ),
                  ),
                  SizedBox(height: AppSpacing.x2l),
                  Material(
                    color: c.card,
                    borderRadius: AppRadius.brMd,
                    child: InkWell(
                      borderRadius: AppRadius.brMd,
                      onTap: onAction,
                      child: SizedBox(
                        height: AppSizes.buttonMd,
                        child: Center(
                          child: Text(
                            actionLabel,
                            style: AppTypography.label.copyWith(
                              color: c.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (linkLabel case final l?)
                    TextButton(
                      onPressed: onLink,
                      style: TextButton.styleFrom(
                        foregroundColor: fg,
                        minimumSize: const Size.fromHeight(
                          AppSizes.minTouchTarget,
                        ),
                      ),
                      child: Text(l),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A plan: badge, price per period, what is included, the call to action
/// and its fine print. [highlighted] outlines it in primary.
class AppPricingCard extends StatelessWidget {
  const AppPricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.actionLabel,
    required this.onAction,
    this.overline,
    this.badge,
    this.period,
    this.footnote,
    this.highlighted = true,
  });

  final String? overline;
  final String title;
  final String? badge;
  final String price;
  final String? period;
  final List<String> features;
  final String actionLabel;
  final VoidCallback? onAction;
  final String? footnote;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: highlighted ? c.primary : c.border),
        boxShadow: highlighted ? context.shadows.elev3 : context.shadows.elev1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (overline case final o?) SectionOverline(o),
              if (badge case final b?)
                AppBadge(label: b, tone: AppTone.primary),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.heading.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(
                price,
                style: AppTypography.display.copyWith(color: c.textPrimary),
              ),
              if (period case final p?) ...[
                Text(
                  p,
                  style: AppTypography.caption.copyWith(color: c.textMuted),
                ),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Divider(height: AppSizes.hairline, color: c.border),
          SizedBox(height: AppSpacing.lg),
          for (final f in features)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(Icons.check, size: AppSizes.iconChip, color: c.success),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      f,
                      style: AppTypography.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: AppSpacing.md),
          AppButton(label: actionLabel, onPressed: onAction),
          if (footnote case final n?) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              n,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: c.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.overline, required this.title});

  final String? overline;
  final String title;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (overline case final o?) ...[
        SectionOverline(o),
        SizedBox(height: AppSpacing.sm),
      ],
      Text(
        title,
        style: AppTypography.section.copyWith(
          color: context.colors.textPrimary,
        ),
      ),
    ],
  );
}

class _Body extends StatelessWidget {
  const _Body(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTypography.bodySmall.copyWith(color: context.colors.textMuted),
  );
}
