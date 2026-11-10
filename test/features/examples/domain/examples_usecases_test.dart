import 'package:flutter_app_template/core/error/app_exception.dart';
import 'package:flutter_app_template/core/error/failure.dart';
import 'package:flutter_app_template/core/error/result.dart';
import 'package:flutter_app_template/core/usecase/usecase.dart';
import 'package:flutter_app_template/features/examples/domain/entities/activity.dart';
import 'package:flutter_app_template/features/examples/domain/entities/transfer.dart';
import 'package:flutter_app_template/features/examples/domain/repositories/activity_repository.dart';
import 'package:flutter_app_template/features/examples/domain/usecases/get_activities.dart';
import 'package:flutter_app_template/features/examples/domain/usecases/get_activity.dart';
import 'package:flutter_app_template/features/examples/domain/usecases/send_transfer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ActivityRepository {}

final _activity = Activity(
  id: 'a1',
  title: 'Mercado Bela',
  method: 'Cartão',
  category: 'Mercado',
  amountCents: -18640,
  date: DateTime(2026, 3, 12),
  protocol: 'A92',
);

void main() {
  late _MockRepo repo;

  setUpAll(
    () => registerFallbackValue(
      const TransferRequest(amountCents: 1, recipient: 'x'),
    ),
  );
  setUp(() => repo = _MockRepo());

  group('GetActivities', () {
    test('returns the repository list', () async {
      when(repo.list).thenAnswer((_) async => [_activity]);
      expect(await GetActivities(repo)(const NoParams()), Success([_activity]));
    });

    test('a repository error becomes a failure, never a throw', () async {
      when(repo.list).thenThrow(const NetworkException('offline'));
      expect(
        await GetActivities(repo)(const NoParams()),
        const ResultFailure<List<Activity>>(NetworkFailure()),
      );
    });
  });

  group('GetActivity', () {
    test('returns the activity with that id', () async {
      when(() => repo.byId('a1')).thenAnswer((_) async => _activity);
      expect(await GetActivity(repo)('a1'), Success(_activity));
    });

    test('an unknown id is a not-found failure', () async {
      when(() => repo.byId('x')).thenAnswer((_) async => null);
      expect(
        await GetActivity(repo)('x'),
        const ResultFailure<Activity>(UnexpectedFailure(GetActivity.notFound)),
      );
    });
  });

  group('SendTransfer', () {
    test(
      'a zero amount fails validation without calling the repository',
      () async {
        final result = await SendTransfer(repo)(
          const TransferRequest(amountCents: 0, recipient: 'Ana'),
        );
        expect(
          result,
          const ResultFailure<TransferReceipt>(
            ValidationFailure(SendTransfer.invalidAmount),
          ),
        );
        verifyNever(() => repo.send(any()));
      },
    );

    test('a blank recipient fails validation', () async {
      final result = await SendTransfer(repo)(
        const TransferRequest(amountCents: 100, recipient: '  '),
      );
      expect(
        result,
        const ResultFailure<TransferReceipt>(
          ValidationFailure(SendTransfer.missingRecipient),
        ),
      );
    });

    test('sends the trimmed request and returns the receipt', () async {
      final receipt = TransferReceipt(
        amountCents: 100,
        recipient: 'Ana',
        protocol: 'T1',
        issuedAt: DateTime(2026),
      );
      when(() => repo.send(any())).thenAnswer((_) async => receipt);
      final result = await SendTransfer(repo)(
        const TransferRequest(amountCents: 100, recipient: ' Ana '),
      );
      expect(result, Success(receipt));
      verify(
        () => repo.send(
          const TransferRequest(amountCents: 100, recipient: 'Ana'),
        ),
      ).called(1);
    });
  });
}
