import 'package:flutter_app_template/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizeEmail trims and lower-cases', () {
    expect(Validators.normalizeEmail('  Fulano@Exemplo.com '), 'fulano@exemplo.com');
  });

  test('isValidEmail accepts padded mixed-case addresses', () {
    expect(Validators.isValidEmail('  Fulano@Exemplo.com '), isTrue);
  });

  test('isValidEmail rejects incomplete addresses', () {
    expect(Validators.isValidEmail('a@b'), isFalse);
    expect(Validators.isValidEmail(''), isFalse);
    expect(Validators.isValidEmail('sem-arroba.com'), isFalse);
    expect(Validators.isValidEmail('a b@c.com'), isFalse);
  });

  test('isValidPassword needs at least 8 characters', () {
    expect(Validators.minPasswordLength, 8);
    expect(Validators.isValidPassword('1234567'), isFalse);
    expect(Validators.isValidPassword('12345678'), isTrue);
  });

  test('isValidName needs 2+ non-blank characters', () {
    expect(Validators.isValidName(' a '), isFalse);
    expect(Validators.isValidName('Ana'), isTrue);
  });
}
