import 'package:flutter/material.dart';

import 'app_check_mark.dart';

/// Checkbox of the design system (section 09): a 22px box, check on the
/// primary colour, inside a 44px touch target. [onChanged] `null` disables
/// it.
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  static const boxKey = ValueKey('app-checkbox-box');

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Semantics(
      checked: value,
      enabled: onChanged != null,
      child: AppCheckMark(
        checked: value,
        circle: false,
        label: label,
        boxKey: boxKey,
        onTap: onChanged == null ? null : () => onChanged!(!value),
      ),
    ),
  );
}
