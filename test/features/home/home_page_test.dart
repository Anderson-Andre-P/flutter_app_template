import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/features/home/presentation/home_demo.dart';
import 'package:flutter_app_template/features/home/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSessionBloc extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}

void main() {
  late _MockSessionBloc session;

  setUp(() {
    session = _MockSessionBloc();
    when(() => session.state).thenReturn(
      const SessionState.authenticated(
        SessionUser(id: '1', name: 'Ana Souza', email: 'ana@ex.com'),
      ),
    );
  });

  Future<void> pump(
    WidgetTester tester,
    ValueChanged<HomeDemo> onOpen, {
    bool dark = false,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.dark() : AppTheme.light(),
      home: BlocProvider<SessionBloc>.value(
        value: session,
        child: HomePage(onOpenDemo: onOpen),
      ),
    ),
  );

  for (final dark in [false, true]) {
    testWidgets('greets the user and shows one card per demo '
        '(${dark ? 'dark' : 'light'})', (tester) async {
      await pump(tester, (_) {}, dark: dark);
      expect(find.text('Olá, Ana'), findsOneWidget);
      for (final d in HomeDemo.values) {
        await tester.scrollUntilVisible(find.text(d.title), 100);
        expect(find.text(d.title), findsOneWidget);
      }
    });
  }

  testWidgets('cards sit in two columns of equal width', (tester) async {
    await pump(tester, (_) {});
    final first = tester.getRect(find.byKey(ValueKey(HomeDemo.values[0])));
    final second = tester.getRect(find.byKey(ValueKey(HomeDemo.values[1])));
    final third = tester.getRect(find.byKey(ValueKey(HomeDemo.values[2])));
    expect(second.top, first.top);
    expect(second.height, first.height);
    expect(second.width, first.width);
    expect(second.left, greaterThan(first.right));
    expect(third.left, first.left);
    expect(third.top, greaterThan(first.bottom));
  });

  testWidgets('tapping a card opens its demo', (tester) async {
    final opened = <HomeDemo>[];
    await pump(tester, opened.add);
    await tester.tap(find.text(HomeDemo.statement.title));
    expect(opened, [HomeDemo.statement]);
  });
}
