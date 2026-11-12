import 'package:bloc_test/bloc_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/features/examples/application/activity_detail_bloc.dart';
import 'package:flutter_app_template/features/examples/application/activity_list_bloc.dart';
import 'package:flutter_app_template/features/examples/application/transfer_bloc.dart';
import 'package:flutter_app_template/features/examples/application/view_status.dart';
import 'package:flutter_app_template/features/examples/domain/entities/activity.dart';
import 'package:flutter_app_template/features/examples/domain/entities/transfer.dart';
import 'package:flutter_app_template/features/examples/domain/usecases/send_transfer.dart';
import 'package:flutter_app_template/features/examples/presentation/examples_strings.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/activity_detail_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/activity_list_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/dashboard_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/transfer_page.dart';
import 'package:flutter_app_template/features/examples/presentation/pages/transfer_success_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockListBloc extends MockBloc<ActivityListEvent, ActivityListState>
    implements ActivityListBloc {}

class _MockDetailBloc extends MockBloc<ActivityDetailEvent, ActivityDetailState>
    implements ActivityDetailBloc {}

class _MockTransferBloc extends MockBloc<TransferEvent, TransferState>
    implements TransferBloc {}

final _now = DateTime.now();

Activity _a(String id, String title, int cents, {int daysAgo = 0}) => Activity(
  id: id,
  title: title,
  method: 'Cartão',
  category: 'Mercado',
  amountCents: cents,
  date: DateTime(_now.year, _now.month, _now.day - daysAgo, 10),
  protocol: 'A92-7741-0083',
);

final _market = _a('m', 'Mercado Bela', -18640);
final _salary = _a('s', 'Salário', 680000, daysAgo: 1);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
  List<BlocProvider> providers = const [],
}) => tester.pumpWidget(
  MaterialApp(
    theme: dark ? AppTheme.dark() : AppTheme.light(),
    home: providers.isEmpty
        ? child
        : MultiBlocProvider(providers: providers, child: child),
  ),
);

void main() {
  setUpAll(() {
    registerFallbackValue(const ActivityListStarted());
    registerFallbackValue(const ActivityDetailRequested(''));
    registerFallbackValue(const TransferSubmitted());
  });

  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';

    testWidgets('dashboard shows goal, highlight and chart ($mode)', (
      tester,
    ) async {
      var starts = 0;
      await _pump(
        tester,
        DashboardPage(onStartTransfer: () => starts++),
        dark: dark,
      );
      expect(find.text(ExamplesStrings.dashboardTitle), findsOneWidget);
      expect(find.text(ExamplesStrings.goalValue), findsOneWidget);
      await tester.ensureVisible(find.text(ExamplesStrings.highlightAction));
      await tester.tap(find.text(ExamplesStrings.highlightAction));
      expect(starts, 1);
    });

    testWidgets('statement groups items by day ($mode)', (tester) async {
      final bloc = _MockListBloc();
      when(() => bloc.state).thenReturn(
        ActivityListState(status: ViewStatus.ready, items: [_market, _salary]),
      );
      await _pump(
        tester,
        ActivityListPage(onOpen: (_) {}),
        dark: dark,
        providers: [BlocProvider<ActivityListBloc>.value(value: bloc)],
      );
      expect(find.text('Hoje'), findsOneWidget);
      expect(find.text('Ontem'), findsOneWidget);
      expect(find.text('– R\$ 186,40'), findsOneWidget);
      expect(find.text('+ R\$ 6.800,00'), findsOneWidget);
    });

    testWidgets('detail shows the amount and its info ($mode)', (tester) async {
      final bloc = _MockDetailBloc();
      when(() => bloc.state).thenReturn(
        ActivityDetailState(status: ViewStatus.ready, activity: _market),
      );
      await _pump(
        tester,
        const ActivityDetailPage(),
        dark: dark,
        providers: [BlocProvider<ActivityDetailBloc>.value(value: bloc)],
      );
      expect(find.text('Mercado Bela'), findsOneWidget);
      expect(find.text('– R\$ 186,40'), findsOneWidget);
      expect(find.text('A92-7741-0083'), findsOneWidget);
      expect(find.text(ExamplesStrings.statusDone), findsOneWidget);
    });

    testWidgets('success shows the receipt and goes home ($mode)', (
      tester,
    ) async {
      var homes = 0;
      await _pump(
        tester,
        TransferSuccessPage(
          receipt: TransferReceipt(
            amountCents: 35000,
            recipient: 'Ana Souza',
            protocol: 'T48-1120-5521',
            issuedAt: DateTime(2026, 3, 12, 18, 42),
          ),
          onHome: () => homes++,
        ),
        dark: dark,
      );
      expect(find.text('R\$ 350,00 para Ana Souza'), findsOneWidget);
      expect(find.text('12 mar 2026, 18:42'), findsOneWidget);
      await tester.tap(find.text(ExamplesStrings.backHome));
      expect(homes, 1);
    });
  }

  group('statement', () {
    testWidgets('typing, filtering and tapping dispatch and navigate', (
      tester,
    ) async {
      final bloc = _MockListBloc();
      when(() => bloc.state).thenReturn(
        ActivityListState(status: ViewStatus.ready, items: [_market]),
      );
      String? opened;
      await _pump(
        tester,
        ActivityListPage(onOpen: (id) => opened = id),
        providers: [BlocProvider<ActivityListBloc>.value(value: bloc)],
      );
      await tester.enterText(find.byType(TextField), 'café');
      verify(() => bloc.add(const ActivityQueryChanged('café'))).called(1);
      await tester.tap(find.text(ExamplesStrings.filterIncome));
      verify(() => bloc.add(const ActivityFilterChanged(ActivityFilter.income)))
          .called(1);
      await tester.tap(find.text('Mercado Bela'));
      expect(opened, 'm');
    });

    testWidgets('no match shows the empty state', (tester) async {
      final bloc = _MockListBloc();
      when(() => bloc.state).thenReturn(
        ActivityListState(
          status: ViewStatus.ready,
          items: [_market],
          query: 'zzz',
        ),
      );
      await _pump(
        tester,
        ActivityListPage(onOpen: (_) {}),
        providers: [BlocProvider<ActivityListBloc>.value(value: bloc)],
      );
      expect(find.text(ExamplesStrings.emptyTitle), findsOneWidget);
    });

    testWidgets('a failure offers a retry that reloads', (tester) async {
      final bloc = _MockListBloc();
      when(() => bloc.state).thenReturn(
        const ActivityListState(status: ViewStatus.failure, errorMessage: 'x'),
      );
      await _pump(
        tester,
        ActivityListPage(onOpen: (_) {}),
        providers: [BlocProvider<ActivityListBloc>.value(value: bloc)],
      );
      await tester.tap(find.text(ExamplesStrings.retry));
      verify(() => bloc.add(const ActivityListStarted())).called(1);
    });
  });

  group('transfer', () {
    testWidgets('presets, fields and Continuar dispatch the form events', (
      tester,
    ) async {
      final bloc = _MockTransferBloc();
      when(() => bloc.state).thenReturn(const TransferState());
      await _pump(
        tester,
        TransferPage(onSent: (_) {}),
        providers: [BlocProvider<TransferBloc>.value(value: bloc)],
      );
      await tester.tap(find.text('R\$ 100'));
      verify(() => bloc.add(const TransferAmountSelected(10000))).called(1);
      await tester.enterText(find.byType(TextField).at(0), 'Ana');
      verify(() => bloc.add(const TransferRecipientChanged('Ana'))).called(1);
      await tester.tap(find.text(ExamplesStrings.transferContinue));
      verify(() => bloc.add(const TransferSubmitted())).called(1);
    });

    testWidgets('field errors from the state are shown', (tester) async {
      final bloc = _MockTransferBloc();
      when(() => bloc.state).thenReturn(const TransferState(submitted: true));
      await _pump(
        tester,
        TransferPage(onSent: (_) {}),
        providers: [BlocProvider<TransferBloc>.value(value: bloc)],
      );
      expect(find.text(SendTransfer.invalidAmount), findsOneWidget);
      expect(find.text(SendTransfer.missingRecipient), findsOneWidget);
    });

    testWidgets('a receipt calls onSent once', (tester) async {
      final bloc = _MockTransferBloc();
      final receipt = TransferReceipt(
        amountCents: 100,
        recipient: 'Ana',
        protocol: 'T1',
        issuedAt: DateTime(2026),
      );
      whenListen(
        bloc,
        Stream.value(TransferState(status: ViewStatus.ready, receipt: receipt)),
        initialState: const TransferState(),
      );
      final sent = <TransferReceipt>[];
      await _pump(
        tester,
        TransferPage(onSent: sent.add),
        providers: [BlocProvider<TransferBloc>.value(value: bloc)],
      );
      await tester.pump();
      expect(sent, [receipt]);
    });
  });
}
