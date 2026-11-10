import 'package:flutter_app_template/core/constants/keys/storage_keys.dart';
import 'package:flutter_app_template/core/error/app_exception.dart';
import 'package:flutter_app_template/features/auth/data/fake_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/memory_secure_storage.dart';

void main() {
  late MemorySecureStorage storage;
  late FakeAuthRepository repo;

  setUp(() {
    storage = MemorySecureStorage();
    repo = FakeAuthRepository(storage, delay: Duration.zero);
  });

  test('signIn stores a token and the user', () async {
    final user = await repo.signIn(
      email: 'maria.silva@ex.com',
      password: '12345678',
    );
    expect(user.email, 'maria.silva@ex.com');
    expect(user.name, 'Maria Silva');
    expect(storage.data[StorageKeys.authToken], startsWith('fake-token-'));
    expect(storage.data[StorageKeys.authUser], isNotNull);
  });

  test('signIn rejects a short password', () {
    expect(
      repo.signIn(email: 'a@ex.com', password: '123'),
      throwsA(isA<AppException>()),
    );
  });

  test('signUp keeps the given name', () async {
    final user = await repo.signUp(
      name: 'Ana Souza',
      email: 'a@ex.com',
      password: '12345678',
    );
    expect(user.name, 'Ana Souza');
  });

  test('currentUser returns the signed-in user', () async {
    final user = await repo.signIn(email: 'a@ex.com', password: '12345678');
    expect(await repo.currentUser(), user);
  });

  test('signOut clears the session', () async {
    await repo.signIn(email: 'a@ex.com', password: '12345678');
    await repo.signOut();
    expect(storage.data, isEmpty);
    expect(await repo.currentUser(), isNull);
  });
}
