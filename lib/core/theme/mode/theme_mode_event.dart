import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ThemeModeEvent extends Equatable {
  const ThemeModeEvent();

  @override
  List<Object?> get props => const [];
}

/// Restores the mode saved on a previous run.
final class ThemeModeStarted extends ThemeModeEvent {
  const ThemeModeStarted();
}

/// The user picked a mode (system, light or dark).
final class ThemeModeChanged extends ThemeModeEvent {
  const ThemeModeChanged(this.mode);

  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];
}
