import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_input_chip.dart';

/// Several values in one field — categories, skills, recipients (design
/// system, section 14). Each is a removable chip; typing and Enter adds
/// one. Use it only for many-to-many: when the rule is "one per record",
/// a single-choice select says so and this field would lie.
class AppTagField extends StatefulWidget {
  const AppTagField({
    super.key,
    required this.label,
    required this.tags,
    required this.onAdded,
    required this.onRemoved,
    this.hint = CommonStrings.addTag,
    this.helper,
  });

  final String label;
  final List<String> tags;

  /// Receives the trimmed text; blank text is ignored.
  final ValueChanged<String> onAdded;

  /// Receives the index of the removed tag.
  final ValueChanged<int> onRemoved;
  final String hint;
  final String? helper;

  @override
  State<AppTagField> createState() => _AppTagFieldState();
}

/// Owns only the text being typed.
class _AppTagFieldState extends State<AppTagField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _add(String text) {
    final tag = text.trim();
    _controller.clear();
    _focus.requestFocus();
    if (tag.isNotEmpty) widget.onAdded(tag);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTypography.label.copyWith(color: c.textPrimary),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
          constraints: BoxConstraints(minHeight: AppSizes.field),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: c.field,
            borderRadius: AppRadius.brMd,
            border: Border.all(color: c.borderStrong),
          ),
          child: Wrap(
            spacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final (i, tag) in widget.tags.indexed)
                AppInputChip(label: tag, onRemoved: () => widget.onRemoved(i)),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: AppSizes.numberStepper),
                child: IntrinsicWidth(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    textInputAction: TextInputAction.done,
                    onSubmitted: _add,
                    style: AppTypography.body.copyWith(color: c.textPrimary),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      filled: false,
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.helper case final helper?) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            helper,
            style: AppTypography.caption.copyWith(color: c.textMuted),
          ),
        ],
      ],
    );
  }
}
