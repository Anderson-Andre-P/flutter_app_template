import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Count of items that need attention — unread, pending (design system,
/// section 28). Above [cap] shows `99+`. Show it only when the number asks
/// for action: a static total is noise.
class AppCounter extends StatelessWidget {
  const AppCounter({super.key, required this.count});

  final int count;

  static const cap = 99;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(
        minWidth: AppSizes.counter,
        minHeight: AppSizes.counter,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.danger,
        borderRadius: AppRadius.brFull,
      ),
      child: Text(
        count > cap ? '$cap+' : '$count',
        style: AppTypography.microBold.copyWith(color: c.card),
      ),
    );
  }
}

/// "There is something new" without a number. [label] is what a screen
/// reader hears, since the dot alone says nothing.
class AppNewDot extends StatelessWidget {
  const AppNewDot({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: Container(
      width: AppSizes.newDot,
      height: AppSizes.newDot,
      decoration: BoxDecoration(
        color: context.colors.danger,
        shape: BoxShape.circle,
      ),
    ),
  );
}
