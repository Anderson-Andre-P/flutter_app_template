import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/features/examples/application/demo_selection_bloc.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/bottom_nav_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/cards_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/charts_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/chat_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/controls_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/forms_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/modals_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/navigation_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/sheets_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/states_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/toasts_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/widgets_demo_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Design system, section 23: every control answers to at least 44 × 44,
/// even when it is drawn smaller. Each component catalogue is laid out on a
/// tall screen, so nothing is cut by the viewport, and checked in both
/// themes.
void main() {
  const pages = <String, Widget>{
    'widgets': WidgetsDemoPage(),
    'controls': ControlsDemoPage(),
    'forms': FormsDemoPage(),
    'navigation': NavigationDemoPage(),
    'states': StatesDemoPage(),
    'toasts': ToastsDemoPage(),
    'modals': ModalsDemoPage(),
    'sheets': SheetsDemoPage(),
    'bottom nav': BottomNavDemoPage(),
    'charts': ChartsDemoPage(),
    'chat': ChatDemoPage(),
    'cards': CardsDemoPage(),
  };

  for (final MapEntry(key: name, value: page) in pages.entries) {
    for (final dark in [false, true]) {
      testWidgets('$name: tap targets are at least 44px '
          '(${dark ? 'dark' : 'light'})', (tester) async {
        tester.view.physicalSize = const Size(600, 8000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            home: BlocProvider(create: (_) => DemoSelectionBloc(), child: page),
          ),
        );
        await tester.pump();
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        handle.dispose();
      });
    }
  }
}
