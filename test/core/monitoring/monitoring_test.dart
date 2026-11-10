import 'package:flutter_app_template/core/config/env_config.dart';
import 'package:flutter_app_template/core/monitoring/monitoring.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('without a DSN runs the app runner exactly once', () async {
    var runs = 0;
    await Monitoring.run(
      const EnvConfig(apiBaseUrl: 'https://x', sentryDsn: ''),
      () async => runs++,
    );
    expect(runs, 1);
  });
}
