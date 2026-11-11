import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/strings/common_strings.dart';
import 'package:flutter_app_template/core/widgets/app_select.dart';
import 'package:flutter_app_template/core/widgets/app_radio.dart';
import 'package:flutter_app_template/core/widgets/app_segmented_control.dart';
import 'package:flutter_app_template/core/widgets/app_stepper.dart';
import 'package:flutter_app_template/core/widgets/app_switch.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/core/widgets/app_bar_chart.dart';
import 'package:flutter_app_template/core/widgets/app_bottom_nav.dart';
import 'package:flutter_app_template/core/widgets/app_button.dart';
import 'package:flutter_app_template/core/widgets/app_donut_chart.dart';
import 'package:flutter_app_template/core/widgets/app_line_chart.dart';
import 'package:flutter_app_template/core/widgets/app_state_views.dart';
import 'package:flutter_app_template/features/examples/application/demo_selection_bloc.dart';
import 'package:flutter_app_template/features/examples/presentation/examples_strings.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/bottom_nav_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/charts_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/controls_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/forms_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/navigation_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/modals_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/sheets_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/states_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/toasts_demo_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/widgets_demo_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget page, {bool dark = false}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: dark ? AppTheme.dark() : AppTheme.light(),
        home: BlocProvider(create: (_) => DemoSelectionBloc(), child: page),
      ),
    );

/// Several demos show a spinner that never stops, so never settle.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _tapVisible(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(
    find.text(text),
    150,
    // The page's vertical list, not a sideways one inside it (tabs).
    scrollable: find
        .byWidgetPredicate(
          (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
        )
        .first,
  );
  // Built is not on screen: the list builds a little past its edge.
  await tester.ensureVisible(find.text(text));
  await tester.pump();
  await tester.tap(find.text(text));
  await _settle(tester);
}

void main() {
  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';

    testWidgets('bottom nav demo shows 3, 4 and 5 tab bars ($mode)', (
      tester,
    ) async {
      await _pump(tester, const BottomNavDemoPage(), dark: dark);
      expect(find.text(ExamplesStrings.navSpec), findsOneWidget);
      for (final count in [3, 4, 5]) {
        await tester.scrollUntilVisible(
          find.text(ExamplesStrings.navTabs(count).toUpperCase()),
          150,
          scrollable: find.byType(Scrollable).first,
        );
      }
      expect(find.byType(AppBottomNav), findsWidgets);
    });

    testWidgets('widgets demo renders every button variant ($mode)', (
      tester,
    ) async {
      await _pump(tester, const WidgetsDemoPage(), dark: dark);
      expect(
        find.byType(AppButton, skipOffstage: false),
        findsAtLeastNWidgets(AppButtonVariant.values.length),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('charts demo shows the four chart kinds ($mode)', (
      tester,
    ) async {
      await _pump(tester, const ChartsDemoPage(), dark: dark);
      expect(find.byType(AppBarChart), findsOneWidget);
      for (final finder in [
        find.byType(AppLineChart),
        find.byType(AppDonutChart),
        find.text(ExamplesStrings.percent(.62)),
      ]) {
        await tester.scrollUntilVisible(
          finder,
          150,
          scrollable: find.byType(Scrollable).first,
        );
        expect(finder, findsOneWidget);
      }
    });

    testWidgets('states demo shows loading, empty and error ($mode)', (
      tester,
    ) async {
      await _pump(tester, const StatesDemoPage(), dark: dark);
      await _settle(tester);
      expect(find.byType(AppLoadingView), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(AppErrorView),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byType(AppEmptyView), findsOneWidget);
    });
  }

  testWidgets('bottom nav demo: tapping a tab selects it', (tester) async {
    await _pump(tester, const BottomNavDemoPage());
    AppBottomNav first() =>
        tester.widget<AppBottomNav>(find.byType(AppBottomNav).first);
    expect(first().currentIndex, 0);
    await tester.tap(find.text(ExamplesStrings.navLabels[2]).first);
    await tester.pump();
    expect(first().currentIndex, 2);
  });

  testWidgets('toasts demo shows each tone and undoes with the action', (
    tester,
  ) async {
    await _pump(tester, const ToastsDemoPage());
    await _tapVisible(tester, ExamplesStrings.toastSuccess);
    expect(find.text(ExamplesStrings.toastSuccessMessage), findsOneWidget);
    await _tapVisible(tester, ExamplesStrings.toastWithAction);
    expect(find.text(ExamplesStrings.toastActionMessage), findsOneWidget);
    await tester.tap(find.text(ExamplesStrings.toastActionLabel));
    await _settle(tester);
    expect(find.text(ExamplesStrings.toastUndone), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets(
      'controls demo keeps each value in the bloc (${dark ? 'dark' : 'light'})',
      (tester) async {
        await _pump(tester, const ControlsDemoPage(), dark: dark);
        AppSwitch location() => tester.widget<AppSwitch>(
          find.widgetWithText(AppSwitch, ExamplesStrings.toggleLocation),
        );
        expect(location().value, isFalse);
        await _tapVisible(tester, ExamplesStrings.toggleLocation);
        expect(location().value, isTrue);

        final boleto = ExamplesStrings.payments.last;
        await _tapVisible(tester, boleto);
        expect(
          tester
              .widget<AppRadio<int>>(find.widgetWithText(AppRadio<int>, boleto))
              .groupValue,
          ExamplesStrings.payments.length - 1,
        );

        final critical = ExamplesStrings.priorities.last;
        await _tapVisible(tester, critical);
        expect(
          tester
              .widget<AppSegmentedControl<int>>(
                find.byType(AppSegmentedControl<int>),
              )
              .selected,
          ExamplesStrings.priorities.length - 1,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final dark in [false, true]) {
    testWidgets('forms demo picks a priority and flags a past deadline '
        '(${dark ? 'dark' : 'light'})', (tester) async {
      await _pump(tester, const FormsDemoPage(), dark: dark);
      await tester.tap(find.byKey(AppSelect.fieldKey).first);
      await _settle(tester);
      await tester.tap(find.text(ExamplesStrings.priorities.last).last);
      await _settle(tester);
      expect(find.text(ExamplesStrings.priorities.last), findsOneWidget);

      final deadline = find
          .widgetWithText(TextField, CommonStrings.dateHint)
          .first;
      await tester.enterText(deadline, '01012020');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await _settle(tester);
      expect(find.text(ExamplesStrings.formsDeadlinePast), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final dark in [false, true]) {
    testWidgets('navigation demo switches tabs, steps and loads more '
        '(${dark ? 'dark' : 'light'})', (tester) async {
      await _pump(tester, const NavigationDemoPage(), dark: dark);
      await tester.tap(find.text(ExamplesStrings.navTabItems.last.$1));
      await _settle(tester);
      expect(find.text(ExamplesStrings.navTabBodies.last), findsOneWidget);

      await _tapVisible(tester, ExamplesStrings.navStepNext);
      expect(find.text(AppStepProgress.stepLabel(3, 4)), findsOneWidget);

      await _tapVisible(tester, ExamplesStrings.navLoadMoreLabel(20));
      expect(find.text(ExamplesStrings.navShowing(60, 179)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('modals demo reports what was chosen', (tester) async {
    await _pump(tester, const ModalsDemoPage());
    await _tapVisible(tester, ExamplesStrings.modalConfirm);
    expect(find.text(ExamplesStrings.modalConfirmTitle), findsOneWidget);
    await tester.tap(find.text(ExamplesStrings.modalConfirmLabel));
    await _settle(tester);
    expect(find.text(ExamplesStrings.modalConfirmed), findsOneWidget);
  });

  testWidgets('sheets demo: the chosen sort is remembered and checked', (
    tester,
  ) async {
    await _pump(tester, const SheetsDemoPage());
    await _tapVisible(tester, ExamplesStrings.sheetOptions);
    await tester.tap(find.text(ExamplesStrings.sortHighest));
    await _settle(tester);
    expect(
      find.text(ExamplesStrings.sortChosen(ExamplesStrings.sortHighest)),
      findsOneWidget,
    );
    await _tapVisible(tester, ExamplesStrings.sheetOptions);
    final check = tester.getCenter(find.byIcon(Icons.check));
    final row = tester.getCenter(find.text(ExamplesStrings.sortHighest).last);
    expect(check.dy, closeTo(row.dy, 2));
  });

  testWidgets('sheets demo: the content sheet closes with its button', (
    tester,
  ) async {
    await _pump(tester, const SheetsDemoPage());
    await _tapVisible(tester, ExamplesStrings.sheetContent);
    expect(find.text(ExamplesStrings.contentTitle), findsOneWidget);
    await tester.tap(find.text(ExamplesStrings.contentSave));
    await _settle(tester);
    expect(find.text(ExamplesStrings.contentTitle), findsNothing);
  });
}
