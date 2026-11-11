import 'package:flutter_app_template/core/theme/app_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

/// Lays the app out on a phone the size of the design frame
/// ([AppScreen.designSize], pixel ratio 1), so screen-scaled tokens are
/// exactly the design-system numbers. Tests that pump the real `App` call
/// it first: the default 800 × 600 test surface is a landscape window, not a
/// phone, and would scale widths and heights differently.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = AppScreen.designSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}
