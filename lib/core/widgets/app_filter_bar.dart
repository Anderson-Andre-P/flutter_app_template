import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import 'app_counter.dart';
import 'app_icon_button.dart';
import 'app_search_field.dart';

/// Search and refine a list (design system, section 20): the search field,
/// a filters button with how many filters are on, and a sort button.
class AppFilterBar extends StatelessWidget {
  const AppFilterBar({
    super.key,
    required this.searchHint,
    required this.onSearch,
    required this.onFilters,
    this.activeFilters = 0,
    this.onSort,
  });

  final String searchHint;
  final ValueChanged<String> onSearch;
  final VoidCallback onFilters;
  final int activeFilters;

  /// `null` hides the sort button.
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: AppSearchField(hint: searchHint, onChanged: onSearch),
      ),
      SizedBox(width: AppSpacing.sm),
      Stack(
        clipBehavior: Clip.none,
        children: [
          AppIconButton(
            icon: Icons.tune,
            label: CommonStrings.filtersOn(activeFilters),
            onPressed: onFilters,
          ),
          if (activeFilters > 0)
            Positioned(
              top: -AppSpacing.xs,
              right: -AppSpacing.xs,
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: AppCounter(count: activeFilters),
                ),
              ),
            ),
        ],
      ),
      if (onSort case final sort?) ...[
        SizedBox(width: AppSpacing.sm),
        AppIconButton(
          icon: Icons.swap_vert,
          label: CommonStrings.sort,
          onPressed: sort,
        ),
      ],
    ],
  );
}
