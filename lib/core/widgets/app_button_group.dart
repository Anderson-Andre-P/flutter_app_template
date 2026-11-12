import 'package:material_ui/material_ui.dart';

import '../theme/app_tokens.dart';
import 'app_button.dart';

/// Buttons that belong together (design system, section 10).
///
/// - [AppButtonGroup.pair]: secondary on the left, primary on the right,
///   always 50/50.
/// - [AppButtonGroup.triple]: the primary gets more width so the other two
///   never compete with it.
/// - [AppButtonGroup.stacked]: one above the other, the main action on top —
///   required whenever one of the actions is destructive.
class AppButtonGroup extends StatelessWidget {
  AppButtonGroup.pair({
    super.key,
    required AppButton secondary,
    required AppButton primary,
  }) : _buttons = [secondary, primary],
       _flex = const [1, 1],
       _stacked = false;

  AppButtonGroup.triple({
    super.key,
    required AppButton first,
    required AppButton second,
    required AppButton primary,
  }) : _buttons = [first, second, primary],
       _flex = const [3, 3, 4],
       _stacked = false;

  AppButtonGroup.stacked({
    super.key,
    required AppButton primary,
    required AppButton secondary,
  }) : _buttons = [primary, secondary],
       _flex = const [],
       _stacked = true;

  final List<AppButton> _buttons;
  final List<int> _flex;
  final bool _stacked;

  @override
  Widget build(BuildContext context) {
    if (_stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buttons[0],
          SizedBox(height: AppSpacing.sm),
          _buttons[1],
        ],
      );
    }
    return Row(
      children: [
        for (var i = 0; i < _buttons.length; i++) ...[
          if (i > 0) SizedBox(width: AppSpacing.sm),
          Expanded(flex: _flex[i], child: _buttons[i]),
        ],
      ],
    );
  }
}
