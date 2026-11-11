import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

enum AppMediaKind { image, diagram, attachment }

/// Stands in for media that is not there yet or cannot be shown (design
/// system, section 18): the kind's icon and a short label on the sunken
/// surface. Takes the size its parent gives.
class AppMediaPlaceholder extends StatelessWidget {
  const AppMediaPlaceholder({super.key, required this.kind, this.label});

  final AppMediaKind kind;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      image: true,
      label: label,
      child: Container(
        decoration: BoxDecoration(
          color: c.sunken,
          borderRadius: AppRadius.brMd,
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Stack(
          children: [
            Center(
              child: Icon(switch (kind) {
                AppMediaKind.image => Icons.image_outlined,
                AppMediaKind.diagram => Icons.schema_outlined,
                AppMediaKind.attachment => Icons.attach_file,
              }, color: c.textDisabled),
            ),
            if (label case final l?)
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: ExcludeSemantics(
                  child: Text(
                    l,
                    style: AppTypography.mono.copyWith(color: c.textMuted),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
