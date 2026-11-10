/// Every route path of the app, in one place.
abstract final class AppRoutes {
  static const splash = '/';
  static const signIn = '/entrar';
  static const signUp = '/criar-conta';
  static const home = '/inicio';
  static const profile = '/perfil';

  /// Reachable without a session.
  static const public = {signIn, signUp};
}
