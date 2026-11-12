import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] inside a themed [MaterialApp] + [Scaffold].
Future<void> pumpApp(WidgetTester tester, Widget child, {bool dark = false}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: dark ? AppTheme.dark() : AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      ),
    );

/// Runs [body] once per theme mode.
void testBothThemes(
  String description,
  Future<void> Function(WidgetTester tester, bool dark) body,
) {
  for (final dark in [false, true]) {
    testWidgets(
      '$description (${dark ? 'dark' : 'light'})',
      (t) => body(t, dark),
    );
  }
}
