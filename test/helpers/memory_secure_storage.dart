import 'package:flutter_app_template/core/error/app_exception.dart';
import 'package:flutter_app_template/core/storage/secure/secure_storage.dart';

/// In-memory [SecureStorage]; [failReads] makes every read throw.
class MemorySecureStorage implements SecureStorage {
  MemorySecureStorage({this.failReads = false});

  final bool failReads;
  final Map<String, String> data = {};

  @override
  Future<String?> read(String key) async {
    if (failReads) throw const StorageException('read failed');
    return data[key];
  }

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<void> delete(String key) async => data.remove(key);
}
