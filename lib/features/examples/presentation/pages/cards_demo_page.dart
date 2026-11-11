import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_cards.dart';
import '../../../../core/widgets/app_media_placeholder.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/demo_selection_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Catalogue of the card anatomies (design system, section 12). The
/// product's favourite and quantity live in the screen's
/// [DemoSelectionBloc].
class CardsDemoPage extends StatelessWidget {
  const CardsDemoPage({super.key});

  static const _favorite = 'cards-favorite';
  static const _quantity = 'cards-quantity';

  @override
  Widget build(BuildContext context) {
    final selection = context.watch<DemoSelectionBloc>().state;
    void set(String key, int value) =>
        context.read<DemoSelectionBloc>().add(DemoSelected(key, value));
    void say(String text) => AppSnackbar.info(context, text);
    final gap = SizedBox(height: AppSpacing.md);
    const image = AppMediaPlaceholder(kind: AppMediaKind.image);

    return DemoScaffold(
      title: ExamplesStrings.cardsTitle,
      children: [
        DemoSection(
          title: ExamplesStrings.cardsInfo,
          caption: ExamplesStrings.cardsInfoCaption,
          child: Column(
            children: [
              const AppBasicCard(
                overline: ExamplesStrings.cardBasicOverline,
                title: ExamplesStrings.cardBasicTitle,
                body: ExamplesStrings.cardBasicBody,
                footer: ExamplesStrings.cardBasicFooter,
              ),
              gap,
              const AppMediaCard(
                media: image,
                badge: ExamplesStrings.cardMediaBadge,
                overline: ExamplesStrings.cardMediaOverline,
                title: ExamplesStrings.cardMediaTitle,
                meta: ExamplesStrings.cardMediaMeta,
              ),
              gap,
              AppProgressCard(
                overline: ExamplesStrings.cardProgressOverline,
                title: ExamplesStrings.cardProgressTitle,
                body: ExamplesStrings.cardProgressBody,
                progress: .6,
                actionLabel: ExamplesStrings.cardProgressAction,
                onAction: () => say(ExamplesStrings.cardProgressAction),
              ),
              gap,
              AppLinkCard(
                overline: ExamplesStrings.cardLinkOverline,
                title: ExamplesStrings.cardLinkTitle,
                body: ExamplesStrings.cardLinkBody,
                linkLabel: ExamplesStrings.cardLinkLabel,
                onLink: () => say(ExamplesStrings.cardLinkLabel),
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.cardsList,
          caption: ExamplesStrings.cardsListCaption,
          child: Column(
            children: [
              AppHorizontalCard(
                thumbnail: image,
                overline: ExamplesStrings.cardHorizontalOverline,
                badge: ExamplesStrings.cardHorizontalBadge,
                title: ExamplesStrings.cardHorizontalTitle,
                body: ExamplesStrings.cardHorizontalBody,
                ownerInitials: ExamplesStrings.cardHorizontalOwnerInitials,
                ownerLabel: ExamplesStrings.cardHorizontalOwner,
                date: ExamplesStrings.cardHorizontalDate,
                onTap: () => say(ExamplesStrings.cardHorizontalTitle),
              ),
              gap,
              AppFieldCard(
                title: ExamplesStrings.cardFieldTitle,
                fieldLabel: ExamplesStrings.cardFieldLabel,
                unit: ExamplesStrings.cardFieldUnit,
                initialValue: ExamplesStrings.cardFieldValue,
                help: ExamplesStrings.cardFieldHelp,
                actionLabel: ExamplesStrings.cardFieldSave,
                onAction: () => say(ExamplesStrings.cardFieldSave),
                attachmentLabel: ExamplesStrings.cardFieldAttach,
                requiredLabel: ExamplesStrings.cardFieldRequired,
                onAttach: () => say(ExamplesStrings.comingSoon),
              ),
            ],
          ),
        ),
        DemoSection(
          title: ExamplesStrings.cardsCommerce,
          caption: ExamplesStrings.cardsCommerceCaption,
          child: Column(
            children: [
              AppProductCard(
                media: image,
                overline: ExamplesStrings.cardProductOverline,
                title: ExamplesStrings.cardProductTitle,
                discount: ExamplesStrings.cardProductDiscount,
                favorite: selection.of(_favorite) == 1,
                onFavorite: () =>
                    set(_favorite, selection.of(_favorite) == 1 ? 0 : 1),
                rating: ExamplesStrings.cardProductRating,
                ratingLabel: ExamplesStrings.cardProductRatingLabel,
                price: ExamplesStrings.cardProductPrice,
                oldPrice: ExamplesStrings.cardProductOldPrice,
                quantity: selection.of(_quantity, fallback: 2),
                onQuantity: (q) => set(_quantity, q),
                addLabel: ExamplesStrings.cardProductAdd,
                onAdd: () => AppSnackbar.success(
                  context,
                  ExamplesStrings.cardProductAdded,
                ),
              ),
              gap,
              AppCtaCard(
                overline: ExamplesStrings.cardCtaOverline,
                title: ExamplesStrings.cardCtaTitle,
                body: ExamplesStrings.cardCtaBody,
                actionLabel: ExamplesStrings.cardCtaAction,
                onAction: () => say(ExamplesStrings.cardCtaAction),
                linkLabel: ExamplesStrings.cardCtaLink,
                onLink: () => say(ExamplesStrings.cardCtaLink),
              ),
              gap,
              AppPricingCard(
                overline: ExamplesStrings.cardPricingOverline,
                badge: ExamplesStrings.cardPricingBadge,
                title: ExamplesStrings.cardPricingTitle,
                price: ExamplesStrings.cardPricingPrice,
                period: ExamplesStrings.cardPricingPeriod,
                features: ExamplesStrings.cardPricingFeatures,
                actionLabel: ExamplesStrings.cardPricingAction,
                onAction: () => say(ExamplesStrings.cardPricingAction),
                footnote: ExamplesStrings.cardPricingNote,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
