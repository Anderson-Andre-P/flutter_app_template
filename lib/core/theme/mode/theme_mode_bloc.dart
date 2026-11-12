import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/keys/storage_keys.dart';
import '../../storage/prefs/preferences_storage.dart';
import 'theme_mode_event.dart';
import 'theme_mode_state.dart';

export 'theme_mode_event.dart';
export 'theme_mode_state.dart';

/// Holds the app's [ThemeMode]: follows the system by default, can be forced
/// to light or dark, and survives restarts via [PreferencesStorage].
class ThemeModeBloc extends Bloc<ThemeModeEvent, ThemeModeState> {
  ThemeModeBloc(this._prefs) : super(const ThemeModeState(ThemeMode.system)) {
    on<ThemeModeStarted>(_onStarted);
    on<ThemeModeChanged>(_onChanged);
  }

  final PreferencesStorage _prefs;

  void _onStarted(ThemeModeStarted event, Emitter<ThemeModeState> emit) {
    final saved = _prefs.getString(StorageKeys.themeMode);
    final mode = ThemeMode.values.where((m) => m.name == saved).firstOrNull;
    if (mode != null) emit(ThemeModeState(mode));
  }

  Future<void> _onChanged(
    ThemeModeChanged event,
    Emitter<ThemeModeState> emit,
  ) async {
    emit(ThemeModeState(event.mode));
    await _prefs.setString(StorageKeys.themeMode, event.mode.name);
  }
}
