import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app_template/core/error/failure.dart';
import 'package:flutter_app_template/core/error/result.dart';
import 'package:flutter_app_template/core/usecase/usecase.dart';
import 'package:flutter_app_template/features/examples/application/activity_detail_bloc.dart';
import 'package:flutter_app_template/features/examples/application/activity_list_bloc.dart';
import 'package:flutter_app_template/features/examples/application/transfer_bloc.dart';
import 'package:flutter_app_template/features/examples/application/view_status.dart';
import 'package:flutter_app_template/features/examples/domain/entities/activity.dart';
import 'package:flutter_app_template/features/examples/domain/entities/transfer.dart';
import 'package:flutter_app_template/features/examples/domain/usecases/get_activities.dart';
import 'package:flutter_app_template/features/examples/domain/usecases/get_activity.dart';
import 'package:flutter_app_template/features/examples/domain/usecases/send_transfer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetActivities extends Mock implements GetActivities {}

class _MockGetActivity extends Mock implements GetActivity {}

class _MockSendTransfer extends Mock implements SendTransfer {}

Activity _a(String id, String title, int cents) => Activity(
  id: id,
  title: title,
  method: 'Pix',
  category: 'C',
  amountCents: cents,
  date: DateTime(2026, 3, 12),
  protocol: 'P',
);

final _market = _a('1', 'Mercado Bela', -18640);
final _salary = _a('2', 'Salário', 680000);
final _cafe = _a('3', 'Café Aurora', -1850);

void main() {
  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const TransferRequest(amountCents: 1, recipient: 'x'),
    );
  });

  group('ActivityListBloc', () {
    late _MockGetActivities get;
    setUp(() => get = _MockGetActivities());

    blocTest<ActivityListBloc, ActivityListState>(
      'start loads the items',
      setUp: () => when(
        () => get(any()),
      ).thenAnswer((_) async => Success([_market, _salary, _cafe])),
      build: () => ActivityListBloc(get),
      act: (b) => b.add(const ActivityListStarted()),
      expect: () => [
        const ActivityListState(status: ViewStatus.loading),
        ActivityListState(
          status: ViewStatus.ready,
          items: [_market, _salary, _cafe],
        ),
      ],
    );

    blocTest<ActivityListBloc, ActivityListState>(
      'a failure keeps its message',
      setUp: () => when(
        () => get(any()),
      ).thenAnswer((_) async => const ResultFailure(NetworkFailure())),
      build: () => ActivityListBloc(get),
      act: (b) => b.add(const ActivityListStarted()),
      skip: 1,
      expect: () => [
        ActivityListState(
          status: ViewStatus.failure,
          errorMessage: const NetworkFailure().message,
        ),
      ],
    );

    test('visible applies the filter and a case/accent-insensitive query', () {
      final s = ActivityListState(
        status: ViewStatus.ready,
        items: [_market, _salary, _cafe],
      );
      expect(s.copyWith(filter: ActivityFilter.income).visible, [_salary]);
      expect(s.copyWith(filter: ActivityFilter.expense).visible, [
        _market,
        _cafe,
      ]);
      expect(s.copyWith(query: 'CAFE').visible, [_cafe]);
      expect(s.copyWith(query: 'pix').visible, [_market, _salary, _cafe]);
      expect(
        s.copyWith(query: 'mercado', filter: ActivityFilter.income).visible,
        isEmpty,
      );
    });

    blocTest<ActivityListBloc, ActivityListState>(
      'query and filter events update the state',
      build: () => ActivityListBloc(get),
      act: (b) => b
        ..add(const ActivityQueryChanged('café'))
        ..add(const ActivityFilterChanged(ActivityFilter.expense)),
      expect: () => [
        const ActivityListState(query: 'café'),
        const ActivityListState(query: 'café', filter: ActivityFilter.expense),
      ],
    );
  });

  group('ActivityDetailBloc', () {
    late _MockGetActivity get;
    setUp(() => get = _MockGetActivity());

    blocTest<ActivityDetailBloc, ActivityDetailState>(
      'loads the activity',
      setUp: () =>
          when(() => get('1')).thenAnswer((_) async => Success(_market)),
      build: () => ActivityDetailBloc(get),
      act: (b) => b.add(const ActivityDetailRequested('1')),
      expect: () => [
        const ActivityDetailState(status: ViewStatus.loading),
        ActivityDetailState(status: ViewStatus.ready, activity: _market),
      ],
    );

    blocTest<ActivityDetailBloc, ActivityDetailState>(
      'an unknown id fails with the not-found message',
      setUp: () => when(() => get('x')).thenAnswer(
        (_) async =>
            const ResultFailure(UnexpectedFailure(GetActivity.notFound)),
      ),
      build: () => ActivityDetailBloc(get),
      act: (b) => b.add(const ActivityDetailRequested('x')),
      skip: 1,
      expect: () => [
        const ActivityDetailState(
          status: ViewStatus.failure,
          errorMessage: GetActivity.notFound,
        ),
      ],
    );
  });

  group('TransferBloc', () {
    late _MockSendTransfer send;
    setUp(() => send = _MockSendTransfer());

    final receipt = TransferReceipt(
      amountCents: 35000,
      recipient: 'Ana',
      protocol: 'T1',
      issuedAt: DateTime(2026),
    );

    test('field errors appear only after a submit', () {
      const s = TransferState();
      expect(s.amountError, isNull);
      expect(s.recipientError, isNull);
      final submitted = s.copyWith(submitted: true);
      expect(submitted.amountError, SendTransfer.invalidAmount);
      expect(submitted.recipientError, SendTransfer.missingRecipient);
    });

    blocTest<TransferBloc, TransferState>(
      'an invalid form only marks it submitted',
      build: () => TransferBloc(send),
      act: (b) => b.add(const TransferSubmitted()),
      expect: () => [const TransferState(submitted: true)],
      verify: (_) => verifyNever(() => send(any())),
    );

    blocTest<TransferBloc, TransferState>(
      'a valid form sends and keeps the receipt',
      setUp: () =>
          when(() => send(any())).thenAnswer((_) async => Success(receipt)),
      build: () => TransferBloc(send),
      act: (b) => b
        ..add(const TransferAmountSelected(35000))
        ..add(const TransferRecipientChanged('Ana'))
        ..add(const TransferDescriptionChanged('Aluguel'))
        ..add(const TransferSubmitted()),
      skip: 3,
      expect: () => [
        const TransferState(
          amountCents: 35000,
          recipient: 'Ana',
          description: 'Aluguel',
          submitted: true,
          status: ViewStatus.loading,
        ),
        TransferState(
          amountCents: 35000,
          recipient: 'Ana',
          description: 'Aluguel',
          submitted: true,
          status: ViewStatus.ready,
          receipt: receipt,
        ),
      ],
      verify: (_) => verify(
        () => send(
          const TransferRequest(
            amountCents: 35000,
            recipient: 'Ana',
            description: 'Aluguel',
          ),
        ),
      ).called(1),
    );

    blocTest<TransferBloc, TransferState>(
      'a send failure keeps the message',
      setUp: () => when(
        () => send(any()),
      ).thenAnswer((_) async => const ResultFailure(NetworkFailure())),
      build: () => TransferBloc(send),
      seed: () => const TransferState(amountCents: 100, recipient: 'Ana'),
      act: (b) => b.add(const TransferSubmitted()),
      skip: 1,
      expect: () => [
        TransferState(
          amountCents: 100,
          recipient: 'Ana',
          submitted: true,
          status: ViewStatus.failure,
          errorMessage: const NetworkFailure().message,
        ),
      ],
    );
  });
}
