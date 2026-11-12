import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_colors.dart';
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
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.suffix,
    this.prefix,
    this.validated = false,
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

  /// More than 1 makes a text area that grows with the text.
  final int? minLines;

  /// Limits the text and shows the `0/400` counter below, on the right.
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  /// Trailing widget inside the field (e.g. a calendar button). Ignored when
  /// [obscure] shows the eye button.
  final Widget? suffix;

  /// Fixed text before the value, in its own tinted box ("ID-").
  final String? prefix;

  /// The value was checked and is fine: a green check at the end.
  final bool validated;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  /// Owned only when the caller gave no controller.
  late final TextEditingController? _own = widget.controller == null
      ? TextEditingController(text: widget.initialValue)
      : null;

  /// A check when [AppTextField.validated], a lock when disabled.
  Widget? _statusIcon(AppColors c) {
    final icon = !widget.enabled
        ? Icon(
            Icons.lock_outline,
            size: AppSizes.iconField,
            color: c.textDisabled,
          )
        : widget.validated
        ? Icon(Icons.check, size: AppSizes.iconField, color: c.success)
        : null;
    return icon == null
        ? null
        : Padding(
            padding: EdgeInsetsDirectional.only(end: AppSpacing.md),
            child: icon,
          );
  }

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
        SizedBox(height: AppSpacing.sm),
        TextField(
          controller: widget.controller ?? _own,
          obscureText: _hidden,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          autofillHints: widget.autofillHints,
          minLines: widget.minLines,
          maxLines: (widget.minLines ?? 1) > 1 ? null : 1,
          keyboardType: (widget.minLines ?? 1) > 1
              ? TextInputType.multiline
              : widget.keyboardType,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) => maxLength == null
              ? null
              : Text(
                  CommonStrings.counter(currentLength, maxLength),
                  style: AppTypography.caption.copyWith(color: c.textMuted),
                ),
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
            constraints: BoxConstraints(minHeight: AppSizes.field),
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
                : widget.suffix ??
                      (widget.readOnly
                          ? Padding(
                              padding: EdgeInsetsDirectional.only(
                                end: AppSpacing.md,
                              ),
                              child: Center(
                                widthFactor: 1,
                                child: Text(
                                  CommonStrings.readOnlySeal,
                                  style: AppTypography.micro.copyWith(
                                    color: c.textMuted,
                                  ),
                                ),
                              ),
                            )
                          : _statusIcon(c)),
            prefixIcon: widget.prefix == null
                ? null
                : Container(
                    margin: EdgeInsetsDirectional.only(end: AppSpacing.md),
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.primarySubtle,
                      borderRadius: BorderRadiusDirectional.horizontal(
                        start: Radius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      widget.prefix!,
                      style: AppTypography.body.copyWith(color: c.textMuted),
                    ),
                  ),
            prefixIconConstraints: BoxConstraints(minHeight: AppSizes.field),
          ),
        ),
      ],
    );
  }
}
