import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/constants/keys/storage_keys.dart';
import 'package:flutter_app_template/core/storage/prefs/preferences_storage.dart';
import 'package:flutter_app_template/core/theme/mode/theme_mode_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPrefs extends Mock implements PreferencesStorage {}

void main() {
  late _MockPrefs prefs;

  setUp(() {
    prefs = _MockPrefs();
    when(() => prefs.setString(any(), any())).thenAnswer((_) async {});
  });

  test('starts on system', () {
    expect(ThemeModeBloc(prefs).state, const ThemeModeState(ThemeMode.system));
  });

  blocTest<ThemeModeBloc, ThemeModeState>(
    'Started restores the saved mode',
    setUp: () =>
        when(() => prefs.getString(StorageKeys.themeMode)).thenReturn('dark'),
    build: () => ThemeModeBloc(prefs),
    act: (b) => b.add(const ThemeModeStarted()),
    expect: () => [const ThemeModeState(ThemeMode.dark)],
  );

  blocTest<ThemeModeBloc, ThemeModeState>(
    'Started keeps system when the saved value is unknown',
    setUp: () =>
        when(() => prefs.getString(StorageKeys.themeMode)).thenReturn('xyz'),
    build: () => ThemeModeBloc(prefs),
    act: (b) => b.add(const ThemeModeStarted()),
    expect: () => <ThemeModeState>[],
  );

  blocTest<ThemeModeBloc, ThemeModeState>(
    'Changed emits and persists the mode',
    build: () => ThemeModeBloc(prefs),
    act: (b) => b.add(const ThemeModeChanged(ThemeMode.light)),
    expect: () => [const ThemeModeState(ThemeMode.light)],
    verify: (_) =>
        verify(() => prefs.setString(StorageKeys.themeMode, 'light')).called(1),
  );
}
