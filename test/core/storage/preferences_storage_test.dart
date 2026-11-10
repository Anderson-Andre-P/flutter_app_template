import 'package:flutter_app_template/core/storage/prefs/preferences_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PreferencesStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = SharedPreferencesStorage(await SharedPreferences.getInstance());
  });

  test('getString returns what setString saved', () async {
    await storage.setString('theme_mode', 'dark');
    expect(storage.getString('theme_mode'), 'dark');
  });

  test('remove clears the value', () async {
    await storage.setString('theme_mode', 'dark');
    await storage.remove('theme_mode');
    expect(storage.getString('theme_mode'), isNull);
  });
}
