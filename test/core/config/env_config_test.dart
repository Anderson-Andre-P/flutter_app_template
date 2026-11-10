import 'package:flutter_app_template/core/config/env_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hasSentry is false when the DSN is empty', () {
    const config = EnvConfig(apiBaseUrl: 'https://x', sentryDsn: '');
    expect(config.hasSentry, isFalse);
  });

  test('hasSentry is true when a DSN is set', () {
    const config = EnvConfig(apiBaseUrl: 'https://x', sentryDsn: 'https://k@s');
    expect(config.hasSentry, isTrue);
  });

  test('fromEnvironment falls back to the defaults', () {
    final config = EnvConfig.fromEnvironment();
    expect(config.apiBaseUrl, 'https://api.example.com');
    expect(config.sentryDsn, '');
  });
}
