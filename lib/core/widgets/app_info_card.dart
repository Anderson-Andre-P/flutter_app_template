import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_card.dart';
import 'section_overline.dart';

/// Card of label → value rows under an overline title (receipts, details,
/// summaries). [emphasizeLast] bolds the last row (a total).
class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    required this.title,
    required this.rows,
    this.emphasizeLast = false,
  });

  final String title;
  final List<(String, String)> rows;
  final bool emphasizeLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionOverline(title),
          for (var i = 0; i < rows.length; i++) ...[
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    rows[i].$1,
                    style: _bold(i)
                        ? AppTypography.label.copyWith(color: c.textPrimary)
                        : AppTypography.body.copyWith(color: c.textSecondary),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                // Long values (a protocol, large text) wrap instead of
                // pushing the row off the card.
                Flexible(
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.end,
                    style: _bold(i)
                        ? AppTypography.label.copyWith(color: c.textPrimary)
                        : AppTypography.body.copyWith(color: c.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool _bold(int i) => emphasizeLast && i == rows.length - 1;
}
