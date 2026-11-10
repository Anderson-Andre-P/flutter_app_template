import '../entities/activity.dart';
import '../entities/transfer.dart';

/// Source of the example screens' data. Throws `AppException`s.
abstract interface class ActivityRepository {
  /// Newest first.
  Future<List<Activity>> list();

  /// `null` when there is no activity with [id].
  Future<Activity?> byId(String id);

  Future<TransferReceipt> send(TransferRequest request);
}
