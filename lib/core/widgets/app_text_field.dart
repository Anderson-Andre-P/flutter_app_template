import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Text input with its label always visible above (never a placeholder as
/// label) and the validation message below. [required] adds ` *`.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.errorText,
    this.obscure = false,
    this.required = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
  });

  final String label;
  final TextEditingController? controller;

  /// Starting text when no [controller] is given (e.g. a read-only value).
  final String? initialValue;
  final String? hint;
  final String? errorText;
  final bool obscure;
  final bool required;
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  /// Owned only when the caller gave no controller.
  late final TextEditingController? _own = widget.controller == null
      ? TextEditingController(text: widget.initialValue)
      : null;

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.required ? '${widget.label} *' : widget.label,
          style: AppTypography.label.copyWith(color: c.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: widget.controller ?? _own,
          obscureText: _hidden,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          autofillHints: widget.autofillHints,
          style: AppTypography.body.copyWith(
            color: widget.enabled ? c.textPrimary : c.textDisabled,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            // Disabled: the neutral fill (design system, section 22).
            fillColor: !widget.enabled
                ? c.sunken
                : widget.errorText != null
                ? c.dangerSubtle
                : widget.readOnly
                ? c.primarySubtle
                : null,
            constraints: const BoxConstraints(minHeight: AppSizes.field),
            suffixIcon: widget.obscure
                ? IconButton(
                    tooltip: _hidden
                        ? CommonStrings.showPassword
                        : CommonStrings.hidePassword,
                    icon: Icon(
                      _hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: AppSizes.iconField,
                      color: c.textMuted,
                    ),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : widget.readOnly
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.md,
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        CommonStrings.readOnlySeal,
                        style: AppTypography.micro.copyWith(color: c.textMuted),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
