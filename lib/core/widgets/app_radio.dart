import 'package:flutter/material.dart';

import 'app_check_mark.dart';

/// One option of a single-choice group (design system, section 09): a
/// round 22px mark, checked on the primary colour, inside a 44px touch
/// target. Selected when [value] equals [groupValue]. [onChanged] `null`
/// disables it.
class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        enabled: onChanged != null,
        child: AppCheckMark(
          checked: selected,
          circle: true,
          label: label,
          onTap: onChanged == null ? null : () => onChanged!(value),
        ),
      ),
    );
  }
}
