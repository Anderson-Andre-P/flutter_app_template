import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/widgets/app_top_bar.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  PreferredSizeWidget bar, {
  bool dark = false,
}) => tester.pumpWidget(
  MaterialApp(
    theme: dark ? AppTheme.dark() : AppTheme.light(),
    home: Scaffold(appBar: bar),
  ),
);

void main() {
  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    final c = dark ? AppColors.dark : AppColors.light;

    testWidgets('brand: the name in primary, with a leading widget ($mode)', (
      tester,
    ) async {
      await _pump(
        tester,
        AppTopBar(
          title: 'Triplicate',
          brand: true,
          leading: const Icon(Icons.menu),
          actions: [AppNotificationButton(count: 3, onPressed: () {})],
        ),
        dark: dark,
      );
      expect(
        tester.widget<Text>(find.text('Triplicate')).style!.color,
        c.primary,
      );
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('viewer bar: close, title and position on ink ($mode)', (
      tester,
    ) async {
      var closed = 0;
      await _pump(
        tester,
        AppViewerBar(
          title: 'Visualizador',
          position: '2 de 4',
          onClose: () => closed++,
        ),
        dark: dark,
      );
      expect(find.text('2 de 4'), findsOneWidget);
      await tester.tap(find.byTooltip(CommonStrings.close));
      expect(closed, 1);
    });
  }

  testWidgets('the bell reads the count', (tester) async {
    final handle = tester.ensureSemantics();
    await _pump(
      tester,
      AppTopBar(
        title: 'Início',
        actions: [AppNotificationButton(count: 3, onPressed: () {})],
      ),
    );
    expect(
      find.bySemanticsLabel(CommonStrings.notifications(3)),
      findsOneWidget,
    );
    handle.dispose();
  });
}
