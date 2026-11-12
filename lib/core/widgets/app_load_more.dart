import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_interactive.dart';

/// End of a long list on a phone (design system, section 20): "Carregar
/// mais 20" instead of numbered pages, with an optional [summary] above
/// ("Mostrando 21–40 de 179"). [loading] shows a spinner and ignores taps.
class AppLoadMore extends StatelessWidget {
  const AppLoadMore({
    super.key,
    required this.label,
    required this.onPressed,
    this.summary,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? summary;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null && !loading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (summary case final summary?) ...[
          Text(
            summary,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: c.textMuted),
          ),
          SizedBox(height: AppSpacing.sm),
        ],
        MergeSemantics(
          child: Semantics(
            button: true,
            enabled: enabled,
            label: loading ? CommonStrings.loading : null,
            child: SizedBox(
              height: AppSizes.buttonMd,
              child: AppInteractive(
                onTap: enabled ? onPressed : null,
                borderRadius: AppRadius.brMd,
                surface: (state) => (
                  color: state.pressed ? c.primarySubtle : c.card,
                  border: c.border,
                  shadows: const <BoxShadow>[],
                ),
                builder: (context, state) => Center(
                  child: loading
                      ? SizedBox.square(
                          dimension: AppSizes.iconField,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.focusRing,
                            color: c.primary,
                          ),
                        )
                      : Text(
                          label,
                          style: AppTypography.label.copyWith(color: c.primary),
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
