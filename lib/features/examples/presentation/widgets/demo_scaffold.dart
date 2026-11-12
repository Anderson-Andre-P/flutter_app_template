import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/section_overline.dart';

/// Layout shared by the catalogue demos: back + title, a scrolling column.
class DemoScaffold extends StatelessWidget {
  const DemoScaffold({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppTopBar(title: title, showBack: true),
    body: ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.x4l,
      ),
      children: children,
    ),
  );
}

/// A titled block of a demo screen, with the standard gap after it.
class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.child,
    this.caption,
  });

  final String title;
  final String? caption;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: AppSpacing.x3l),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionOverline(title),
        if (caption != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            caption!,
            style: AppTypography.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ],
        SizedBox(height: AppSpacing.md),
        child,
      ],
    ),
  );
}

/// Items in rows of two equal-width cells.
class DemoPairs extends StatelessWidget {
  const DemoPairs({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < children.length; i += 2) ...[
        if (i > 0) SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: children[i]),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: i + 1 < children.length
                  ? children[i + 1]
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    ],
  );
}

/// A tappable card row: title, hint and a chevron — opens one demo.
class DemoTrigger extends StatelessWidget {
  const DemoTrigger({
    super.key,
    required this.title,
    required this.hint,
    required this.onTap,
  });

  final String title;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: c.card,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.brLg,
          side: BorderSide(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: AppSizes.listTileMin),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.label.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          hint,
                          style: AppTypography.caption.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: c.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
