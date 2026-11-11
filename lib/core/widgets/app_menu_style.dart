import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';

/// Look of every dropdown list and context menu (design system, section
/// 25): a card with a hairline border and the popover elevation — none in
/// dark mode, where depth comes from the surface colour.
abstract final class AppMenuStyle {
  static MenuStyle menu(BuildContext context, {double? width}) {
    final c = context.colors;
    return MenuStyle(
      backgroundColor: WidgetStatePropertyAll(c.card),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: WidgetStatePropertyAll(
        context.shadows.elev3.isEmpty ? 0 : AppSpacing.sm,
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
          side: BorderSide(color: c.border),
        ),
      ),
      padding: WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.xs)),
      minimumSize: width == null
          ? null
          : WidgetStatePropertyAll(Size(width, 0)),
      maximumSize: width == null
          ? null
          : WidgetStatePropertyAll(Size(width, double.infinity)),
    );
  }

  static ButtonStyle item(BuildContext context, {bool selected = false}) {
    final c = context.colors;
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        selected ? c.primarySubtle : Colors.transparent,
      ),
      overlayColor: WidgetStatePropertyAll(c.primarySubtle),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.brSm),
      ),
      minimumSize: const WidgetStatePropertyAll(
        Size.fromHeight(AppSizes.minTouchTarget),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
    );
  }
}
