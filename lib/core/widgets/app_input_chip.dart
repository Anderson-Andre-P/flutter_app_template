import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// A value the user added and can take back — a tag, a recipient, an
/// applied filter (design system, section 28: "Bomba 02 ×"). The × is a
/// separate button read as "Remover <label>".
class AppInputChip extends StatelessWidget {
  const AppInputChip({super.key, required this.label, required this.onRemoved});

  final String label;

  /// `null` hides the ×.
  final VoidCallback? onRemoved;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: BoxConstraints(minHeight: AppSizes.chip),
      padding: EdgeInsetsDirectional.only(
        start: AppSpacing.md,
        end: onRemoved == null ? AppSpacing.md : 0,
      ),
      decoration: BoxDecoration(
        color: c.primarySubtle,
        borderRadius: AppRadius.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMedium.copyWith(color: c.primary),
            ),
          ),
          if (onRemoved case final remove?)
            Semantics(
              button: true,
              label: CommonStrings.remove(label),
              child: ExcludeSemantics(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: remove,
                    child: SizedBox.square(
                      dimension: AppSizes.chip,
                      child: Icon(
                        Icons.close,
                        size: AppSizes.iconChip,
                        color: c.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
