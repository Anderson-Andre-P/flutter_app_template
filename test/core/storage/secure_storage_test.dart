import 'package:flutter/services.dart';
import 'package:flutter_app_template/core/error/app_exception.dart';
import 'package:flutter_app_template/core/storage/secure/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPlugin extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockPlugin plugin;
  late SecureStorage storage;

  setUp(() {
    plugin = _MockPlugin();
    storage = FlutterSecureStorageImpl(plugin);
  });

  test('read returns the stored value', () async {
    when(() => plugin.read(key: 'k')).thenAnswer((_) async => 'v');
    expect(await storage.read('k'), 'v');
  });

  test('write and delete reach the plugin', () async {
    when(() => plugin.write(key: 'k', value: 'v')).thenAnswer((_) async {});
    when(() => plugin.delete(key: 'k')).thenAnswer((_) async {});
    await storage.write('k', 'v');
    await storage.delete('k');
    verify(() => plugin.write(key: 'k', value: 'v')).called(1);
    verify(() => plugin.delete(key: 'k')).called(1);
  });

  test('a plugin error becomes a StorageException', () async {
    when(
      () => plugin.read(key: 'k'),
    ).thenThrow(PlatformException(code: 'BadPadding'));
    expect(() => storage.read('k'), throwsA(isA<StorageException>()));
  });
}
