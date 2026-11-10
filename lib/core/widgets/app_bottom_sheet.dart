import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// One choice of [AppBottomSheet.options].
class AppSheetOption<T> {
  const AppSheetOption({
    required this.value,
    required this.label,
    this.icon,
    this.destructive = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool destructive;
}

/// Modal bottom sheets of the design system: rounded top (`xl`), drag
/// handle, title, optional message, the `sheet` motion token.
abstract final class AppBottomSheet {
  /// Key of the drag handle, for tests.
  static const handleKey = ValueKey('app-sheet-handle');

  /// A sheet with free [child] content. Pop it with a value to return one.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? message,
    required Widget child,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: context.colors.card,
    barrierColor: context.colors.scrim,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXl),
    sheetAnimationStyle: const AnimationStyle(
      duration: AppDurations.sheet,
      curve: AppDurations.sheetCurve,
    ),
    builder: (_) => _Sheet(title: title, message: message, child: child),
  );

  /// A list of [options]; resolves to the tapped value, or `null` when
  /// dismissed. [selected] gets a check mark.
  static Future<T?> options<T>(
    BuildContext context, {
    required String title,
    required List<AppSheetOption<T>> options,
    T? selected,
  }) => show<T>(
    context,
    title: title,
    child: Builder(
      builder: (sheetContext) {
        final c = sheetContext.colors;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final o in options)
              InkWell(
                borderRadius: AppRadius.brMd,
                onTap: () => Navigator.of(sheetContext).pop(o.value),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppSizes.listTileMin,
                  ),
                  child: Row(
                    children: [
                      if (o.icon != null) ...[
                        Icon(
                          o.icon,
                          size: AppSizes.icon,
                          color: o.destructive ? c.danger : c.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      Expanded(
                        child: Text(
                          o.label,
                          style: AppTypography.body.copyWith(
                            color: o.destructive ? c.danger : c.textPrimary,
                          ),
                        ),
                      ),
                      if (o.value == selected)
                        Icon(
                          Icons.check,
                          size: AppSizes.icon,
                          color: c.primary,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.title, required this.child, this.message});

  final String title;
  final String? message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  key: AppBottomSheet.handleKey,
                  width: AppSizes.sheetHandleWidth,
                  height: AppSizes.sheetHandleHeight,
                  decoration: BoxDecoration(
                    color: c.borderStrong,
                    borderRadius: AppRadius.brFull,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: AppTypography.heading.copyWith(color: c.textPrimary),
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message!,
                  style: AppTypography.body.copyWith(color: c.textSecondary),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Flexible(child: SingleChildScrollView(child: child)),
            ],
          ),
        ),
      ),
    );
  }
}
