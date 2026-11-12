import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';

/// The grip of a reorderable item (design system, section 18). Put it in a
/// `ReorderableDragStartListener`; it fills a 44px target.
class AppDragHandle extends StatelessWidget {
  const AppDragHandle({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: CommonStrings.dragToReorder,
    child: SizedBox.square(
      dimension: AppSizes.minTouchTarget,
      child: Icon(
        Icons.drag_indicator,
        size: AppSizes.iconTopBar,
        color: context.colors.textMuted,
      ),
    ),
  );
}
