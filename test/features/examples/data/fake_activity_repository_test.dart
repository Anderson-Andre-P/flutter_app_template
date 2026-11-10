import 'package:flutter_app_template/features/examples/data/fake_activity_repository.dart';
import 'package:flutter_app_template/features/examples/domain/entities/transfer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 3, 12, 18, 42);
  late FakeActivityRepository repo;

  setUp(() => repo = FakeActivityRepository(now: () => now));

  test('lists activities newest first, with income and expenses', () async {
    final items = await repo.list();
    expect(items, isNotEmpty);
    for (var i = 1; i < items.length; i++) {
      expect(
        items[i - 1].date.isAfter(items[i].date) ||
            items[i - 1].date == items[i].date,
        isTrue,
      );
    }
    expect(items.any((a) => a.isIncome), isTrue);
    expect(items.any((a) => !a.isIncome), isTrue);
  });

  test('byId finds an activity, or returns null', () async {
    final first = (await repo.list()).first;
    expect(await repo.byId(first.id), first);
    expect(await repo.byId('missing'), isNull);
  });

  test('send issues a receipt stamped with the clock', () async {
    final receipt = await repo.send(
      const TransferRequest(amountCents: 35000, recipient: 'Ana Souza'),
    );
    expect(receipt.amountCents, 35000);
    expect(receipt.recipient, 'Ana Souza');
    expect(receipt.issuedAt, now);
    expect(receipt.protocol, isNotEmpty);
  });
}
