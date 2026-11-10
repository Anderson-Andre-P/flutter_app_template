/// Pure input validation shared by usecases and forms.
abstract final class Validators {
  static const int minPasswordLength = 8;

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  /// Trims and lower-cases an e-mail before validating or storing it.
  static String normalizeEmail(String value) => value.trim().toLowerCase();

  static bool isValidEmail(String value) =>
      _email.hasMatch(normalizeEmail(value));

  static bool isValidPassword(String value) =>
      value.length >= minPasswordLength;

  static bool isValidName(String value) => value.trim().length >= 2;
}
