import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../error/app_exception.dart';

/// Encrypted key/value storage for secrets (tokens, credentials).
abstract interface class SecureStorage {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

/// [SecureStorage] over `flutter_secure_storage`. Any plugin error (a common
/// one: iOS keychain data left behind by a reinstall) surfaces as a
/// [StorageException], never as a raw platform error.
final class FlutterSecureStorageImpl implements SecureStorage {
  const FlutterSecureStorageImpl(this._plugin);

  final FlutterSecureStorage _plugin;

  @override
  Future<String?> read(String key) =>
      _guard('read', () => _plugin.read(key: key));

  @override
  Future<void> write(String key, String value) =>
      _guard('write', () => _plugin.write(key: key, value: value));

  @override
  Future<void> delete(String key) =>
      _guard('delete', () => _plugin.delete(key: key));

  Future<T> _guard<T>(String op, Future<T> Function() body) async {
    try {
      return await body();
    } catch (e, s) {
      throw StorageException(
        'secure storage $op failed',
        cause: e,
        stackTrace: s,
      );
    }
  }
}
