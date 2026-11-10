import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../application/demo_selection_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// The bottom bar alone: its spec and live samples with 3, 4 and 5 tabs.
class BottomNavDemoPage extends StatelessWidget {
  const BottomNavDemoPage({super.key});

  static const _icons = [
    Icons.home_outlined,
    Icons.search,
    Icons.receipt_long_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DemoScaffold(
      title: ExamplesStrings.navTitle,
      children: [
        Text(
          ExamplesStrings.navSpec,
          style: AppTypography.body.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: AppSpacing.x2l),
        for (final count in [3, 4, 5])
          DemoSection(
            title: ExamplesStrings.navTabs(count),
            child: _Sample(count: count, icons: _icons),
          ),
      ],
    );
  }
}

class _Sample extends StatelessWidget {
  const _Sample({required this.count, required this.icons});

  final int count;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final key = 'nav-$count';
    final index = context.select<DemoSelectionBloc, int>(
      (b) => b.state.of(key),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.screen,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.x3l),
        // The sample sits inside a page: no system inset applies to it.
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: AppBottomNav(
            currentIndex: index,
            onTap: (i) =>
                context.read<DemoSelectionBloc>().add(DemoSelected(key, i)),
            items: [
              for (var i = 0; i < count; i++)
                AppBottomNavItem(
                  icon: icons[i],
                  label: ExamplesStrings.navLabels[i],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
