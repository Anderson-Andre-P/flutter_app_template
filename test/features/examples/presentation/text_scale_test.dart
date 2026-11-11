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

/// Design system, section 23: text scales up to 200% without being cut or
/// overlapping. Each component catalogue is laid out at phone width (390)
/// on a tall screen with the system text size doubled; a layout overflow is
/// a test failure.
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
    testWidgets('$name: text at 200% fits', (tester) async {
      tester.view.physicalSize = const Size(390, 20000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: BlocProvider(create: (_) => DemoSelectionBloc(), child: page),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}
