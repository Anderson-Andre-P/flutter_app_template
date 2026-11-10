import 'package:shared_preferences/shared_preferences.dart';

/// Plain key/value storage for non-sensitive preferences (theme, flags).
abstract interface class PreferencesStorage {
  String? getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);
}

/// [PreferencesStorage] over `shared_preferences`.
final class SharedPreferencesStorage implements PreferencesStorage {
  const SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
