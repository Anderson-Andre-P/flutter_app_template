import 'dart:convert';

import '../../../core/constants/keys/storage_keys.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/storage/secure/secure_storage.dart';
import '../../../core/utils/validators.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';
import 'user_model.dart';

/// Local stand-in for a backend: accepts any valid e-mail with a password of
/// at least `Validators.minPasswordLength` characters and keeps a fake
/// session in [SecureStorage]. Swap it for a real implementation in DI.
final class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(
    this._storage, {
    this.delay = const Duration(milliseconds: 600),
  });

  final SecureStorage _storage;

  /// Simulated network latency.
  final Duration delay;

  @override
  Future<User> signIn({required String email, required String password}) async {
    await Future<void>.delayed(delay);
    _check(email, password);
    return _start(User(id: _id(), name: _nameFrom(email), email: email));
  }

  @override
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    _check(email, password);
    return _start(User(id: _id(), name: name, email: email));
  }

  /// Best effort: tries to delete every session key even if one fails, so
  /// a stored user never signs back in on the next launch; then rethrows the
  /// first error.
  @override
  Future<void> signOut() async {
    Object? firstError;
    for (final key in [StorageKeys.authUser, StorageKeys.authToken]) {
      try {
        await _storage.delete(key);
      } catch (e) {
        firstError ??= e;
      }
    }
    if (firstError != null) throw firstError;
  }

  @override
  Future<User?> currentUser() async {
    final raw = await _storage.read(StorageKeys.authUser);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  void _check(String email, String password) {
    if (!Validators.isValidEmail(email) ||
        !Validators.isValidPassword(password)) {
      throw const AppException('Credenciais inválidas');
    }
  }

  Future<User> _start(User user) async {
    await _storage.write(StorageKeys.authToken, 'fake-token-${_id()}');
    await _storage.write(
      StorageKeys.authUser,
      jsonEncode(UserModel.toJson(user)),
    );
    return user;
  }

  String _id() => DateTime.now().millisecondsSinceEpoch.toString();

  /// `maria.silva@x.com` → `Maria Silva`.
  String _nameFrom(String email) => email
      .split('@')
      .first
      .split(RegExp('[._-]+'))
      .where((p) => p.isNotEmpty)
      .map((p) => p[0].toUpperCase() + p.substring(1))
      .join(' ');
}
