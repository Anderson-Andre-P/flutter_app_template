import '../domain/entities/activity.dart';
import '../domain/entities/transfer.dart';
import '../domain/repositories/activity_repository.dart';

/// In-memory data for the example screens — no backend. Dates are relative
/// to [now] so "Hoje" / "Ontem" always read right.
class FakeActivityRepository implements ActivityRepository {
  FakeActivityRepository({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  List<Activity> _items() {
    final now = _now();
    DateTime at(int daysAgo, int hour, int minute) =>
        DateTime(now.year, now.month, now.day - daysAgo, hour, minute);
    return [
      Activity(
        id: 'mercado-bela',
        title: 'Mercado Bela',
        method: 'Cartão',
        category: 'Mercado',
        amountCents: -18640,
        date: at(0, 18, 42),
        protocol: 'A92-7741-0083',
      ),
      Activity(
        id: 'cafe-aurora',
        title: 'Café Aurora',
        method: 'Débito',
        category: 'Alimentação',
        amountCents: -1850,
        date: at(0, 9, 15),
        protocol: 'A92-7738-1102',
      ),
      Activity(
        id: 'salario',
        title: 'Salário',
        method: 'Depósito',
        category: 'Renda',
        amountCents: 680000,
        date: at(1, 8, 0),
        protocol: 'D10-0001-5520',
      ),
      Activity(
        id: 'streaming',
        title: 'Streaming',
        method: 'Débito',
        category: 'Assinaturas',
        amountCents: -3990,
        date: at(1, 7, 30),
        protocol: 'A92-7701-4410',
      ),
      Activity(
        id: 'pix-ana',
        title: 'Pix Ana Souza',
        method: 'Pix',
        category: 'Transferência',
        amountCents: -12000,
        date: at(2, 20, 5),
        protocol: 'T48-1120-5521',
      ),
    ];
  }

  @override
  Future<List<Activity>> list() async => _items();

  @override
  Future<Activity?> byId(String id) async {
    for (final a in _items()) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  Future<TransferReceipt> send(TransferRequest request) async {
    final issuedAt = _now();
    final stamp = issuedAt.millisecondsSinceEpoch.toString().padLeft(8, '0');
    final tail = stamp.substring(stamp.length - 8);
    return TransferReceipt(
      amountCents: request.amountCents,
      recipient: request.recipient,
      protocol:
          'T${tail.substring(0, 2)}-${tail.substring(2, 6)}-'
          '${tail.substring(6)}${request.amountCents % 100}',
      issuedAt: issuedAt,
    );
  }
}
