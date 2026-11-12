import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_icon_button.dart';

/// Search input at the top of a list: no label, the hint says what it
/// searches, a leading magnifier and, once there is text, a button that
/// clears it.
class AppSearchField extends StatefulWidget {
  const AppSearchField({super.key, required this.hint, this.onChanged});

  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

/// Owns only the text being typed.
class _AppSearchFieldState extends State<AppSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changed(String text) {
    setState(() {});
    widget.onChanged?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextField(
      controller: _controller,
      onChanged: _changed,
      textInputAction: TextInputAction.search,
      style: AppTypography.body.copyWith(color: c.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hint,
        constraints: BoxConstraints(minHeight: AppSizes.field),
        prefixIcon: Icon(
          Icons.search,
          size: AppSizes.iconField,
          color: c.textMuted,
        ),
        suffixIcon: _controller.text.isEmpty
            ? null
            : AppIconButton(
                icon: Icons.close,
                label: CommonStrings.clearSearch,
                bordered: false,
                onPressed: () {
                  _controller.clear();
                  _changed('');
                },
              ),
      ),
    );
  }
}
