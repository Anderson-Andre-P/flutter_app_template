import '../entities/user.dart';

/// Authentication contract. Implementations throw `AppException`s; the
/// usecases turn them into `Failure`s. The template ships
/// `FakeAuthRepository` — replace it in DI with a real backend.
abstract interface class AuthRepository {
  Future<User> signIn({required String email, required String password});

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  /// The user of the stored session, or `null` when signed out.
  Future<User?> currentUser();
}
