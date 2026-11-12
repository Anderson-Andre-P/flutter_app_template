import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/theme_context.dart';
import 'app_timeline.dart';
import 'app_top_bar.dart';

/// Full-screen viewer of a few pages — photos, document pages (design
/// system, section 18): the dark viewer bar with close and "2 de 4", the
/// pages swiped sideways and dots below.
abstract final class AppViewer {
  static Future<void> open(
    BuildContext context, {
    required String title,
    required List<Widget> pages,
    int initial = 0,
  }) => Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => BlocProvider(
        create: (_) => _PageBloc(initial),
        child: _ViewerPage(title: title, pages: pages, initial: initial),
      ),
    ),
  );
}

/// The page on screen — UI-only state of one viewer.
class _PageBloc extends Bloc<int, int> {
  _PageBloc(super.initial) {
    on<int>((page, emit) => emit(page));
  }
}

class _ViewerPage extends StatefulWidget {
  const _ViewerPage({
    required this.title,
    required this.pages,
    required this.initial,
  });

  final String title;
  final List<Widget> pages;
  final int initial;

  @override
  State<_ViewerPage> createState() => _ViewerPageState();
}

/// Owns only the page controller; the page on screen is in [_PageBloc].
class _ViewerPageState extends State<_ViewerPage> {
  late final _pages = PageController(initialPage: widget.initial);

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final pages = widget.pages;
    final c = context.colors;
    final page = context.watch<_PageBloc>().state;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? c.sunken : c.textPrimary,
      appBar: AppViewerBar(
        title: title,
        position: CommonStrings.pageOf(page + 1, pages.length),
        onClose: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: context.read<_PageBloc>().add,
                children: [
                  for (final p in pages)
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: p),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: AppPageDots(
                count: pages.length,
                current: page,
                color: dark ? c.textPrimary : c.card,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
