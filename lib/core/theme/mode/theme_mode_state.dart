import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';

final class ThemeModeState extends Equatable {
  const ThemeModeState(this.mode);

  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];
}
