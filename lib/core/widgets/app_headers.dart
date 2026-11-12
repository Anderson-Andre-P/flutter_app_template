import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';
import 'section_overline.dart';

/// Top of a main tab (design system, section 35): an overline in CAPS, a
/// large title and an optional [action] on the right (usually an
/// `AppIconButton`). Each tab of the bottom bar opens with one.
class AppTabHeader extends StatelessWidget {
  const AppTabHeader({
    super.key,
    required this.title,
    this.overline,
    this.action,
  });

  final String title;
  final String? overline;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (overline != null) ...[
                  SectionOverline(overline!),
                  SizedBox(height: AppSpacing.xs),
                ],
                Text(
                  title,
                  style: AppTypography.display.copyWith(color: c.textPrimary),
                ),
              ],
            ),
          ),
        ),
        if (action != null) ...[SizedBox(width: AppSpacing.sm), action!],
      ],
    );
  }
}

/// Section label in CAPS with an optional text action on the right
/// ("SEÇÃO · Ver tudo"), design system, section 35. Without an action it is
/// a `SectionOverline`.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  static const actionKey = ValueKey('app-section-header-action');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final action = actionLabel;
    return Row(
      children: [
        Expanded(child: Semantics(header: true, child: SectionOverline(title))),
        if (action != null)
          MergeSemantics(
            child: Semantics(
              button: true,
              enabled: onAction != null,
              child: AppInteractive(
                key: actionKey,
                onTap: onAction,
                borderRadius: AppRadius.brSm,
                surface: (_) => (
                  color: Colors.transparent,
                  border: null,
                  shadows: const <BoxShadow>[],
                ),
                builder: (context, state) => ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: AppSizes.minTouchTarget,
                    minHeight: AppSizes.minTouchTarget,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        action,
                        style: AppTypography.label.copyWith(
                          color: state.pressed ? c.primaryHover : c.link,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
