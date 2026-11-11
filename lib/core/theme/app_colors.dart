import 'package:flutter/material.dart';

/// Semantic colour tokens of the design system, one instance per theme
/// mode. Names describe the role, never the hue: widgets read
/// `context.colors.primary`, so switching light/dark never touches a screen.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryHover,
    required this.primarySubtle,
    required this.onPrimary,
    required this.screen,
    required this.card,
    required this.field,
    required this.raised,
    required this.sunken,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.link,
    required this.border,
    required this.borderStrong,
    required this.focus,
    required this.success,
    required this.successSubtle,
    required this.alert,
    required this.alertSubtle,
    required this.alertText,
    required this.danger,
    required this.dangerSubtle,
    required this.info,
    required this.infoSubtle,
    required this.scrim,
    required this.inverse,
    required this.onInverse,
    required this.inverseLink,
  });

  /// Main action, active tab, link, selection.
  final Color primary;

  /// Pressed / hover state of the main action.
  final Color primaryHover;

  /// Active chip background, highlighted icon, tonal band.
  final Color primarySubtle;

  /// Text and icons on solid primary.
  final Color onPrimary;

  /// Screen background.
  final Color screen;

  /// Cards and any content surface.
  final Color card;

  /// Inputs and editable areas.
  final Color field;

  /// Sheets, modals, popovers, menus.
  final Color raised;

  /// Tracks, progress background, inactive areas.
  final Color sunken;

  /// Titles, numbers, main content.
  final Color textPrimary;

  /// Body text and descriptions.
  final Color textSecondary;

  /// Metadata, captions, overlines.
  final Color textMuted;

  /// Disabled fields only — never real content.
  final Color textDisabled;

  /// Inline links and text actions.
  final Color link;

  /// Card outline and section divider.
  final Color border;

  /// Inputs, secondary buttons, table headers.
  final Color borderStrong;

  /// Focus ring (2px, 2px offset).
  final Color focus;

  /// Done, synced, validated.
  final Color success;

  /// Success band / badge background.
  final Color successSubtle;

  /// Pending, non-blocking warning.
  final Color alert;

  /// Warning band / badge background.
  final Color alertSubtle;

  /// Alert as text or a small glyph: the solid [alert] is too light to
  /// reach AA on a light surface.
  final Color alertText;

  /// Error, overdue, irreversible action.
  final Color danger;

  /// Error band / badge background.
  final Color dangerSubtle;

  /// System information, contextual tip.
  final Color info;

  /// Info band background.
  final Color infoSubtle;

  /// Overlay behind dialogs and sheets (42%).
  final Color scrim;

  /// Dark surface that stands out in both themes: the failure snackbar.
  final Color inverse;

  /// Text and icons on [inverse].
  final Color onInverse;

  /// Text action on [inverse] ("Tentar").
  final Color inverseLink;

  static const light = AppColors(
    primary: Color(0xFF004AC6),
    primaryHover: Color(0xFF00379A),
    primarySubtle: Color(0xFFEDF3FE),
    onPrimary: Color(0xFFFFFFFF),
    screen: Color(0xFFF7F9FB),
    card: Color(0xFFFFFFFF),
    field: Color(0xFFFBFCFE),
    raised: Color(0xFFFFFFFF),
    sunken: Color(0xFFF1F4F9),
    textPrimary: Color(0xFF111C2E),
    textSecondary: Color(0xFF3C4A5E),
    textMuted: Color(0xFF6B7688),
    textDisabled: Color(0xFFB9C6DA),
    link: Color(0xFF004AC6),
    border: Color(0xFFE9EDF3),
    borderStrong: Color(0xFFDDE4EC),
    focus: Color(0xFF004AC6),
    success: Color(0xFF12855B),
    successSubtle: Color(0xFFE4F4EC),
    alert: Color(0xFFE0A008),
    alertSubtle: Color(0xFFFEF4DA),
    alertText: Color(0xFF946200),
    danger: Color(0xFFC81E1E),
    dangerSubtle: Color(0xFFFDE7E7),
    info: Color(0xFF0E7490),
    infoSubtle: Color(0xFFE2F1F5),
    scrim: Color(0x6B0B1628),
    inverse: Color(0xFF22304A),
    onInverse: Color(0xFFFFFFFF),
    inverseLink: Color(0xFF7FA6F2),
  );

  static const dark = AppColors(
    primary: Color(0xFF5B92F0),
    primaryHover: Color(0xFF7BA8F5),
    primarySubtle: Color(0xFF16294A),
    onPrimary: Color(0xFF08122A),
    screen: Color(0xFF0E1626),
    card: Color(0xFF16213A),
    field: Color(0xFF1B2740),
    raised: Color(0xFF22304E),
    sunken: Color(0xFF0A111F),
    textPrimary: Color(0xFFF2F5FA),
    textSecondary: Color(0xFFAEBACD),
    textMuted: Color(0xFF7C8AA3),
    textDisabled: Color(0xFF55627A),
    link: Color(0xFF8FB7F5),
    border: Color(0xFF263450),
    borderStrong: Color(0xFF33456B),
    focus: Color(0xFF5B92F0),
    success: Color(0xFF3FBF8C),
    successSubtle: Color(0xFF12301F),
    alert: Color(0xFFF0B54B),
    alertSubtle: Color(0xFF3A2A12),
    alertText: Color(0xFFF0B54B),
    danger: Color(0xFFF27A7A),
    dangerSubtle: Color(0xFF3A1A1C),
    info: Color(0xFF5FC6DE),
    infoSubtle: Color(0xFF12303A),
    scrim: Color(0x6B0B1628),
    inverse: Color(0xFF1C2432),
    onInverse: Color(0xFFFFFFFF),
    inverseLink: Color(0xFF7FA6F2),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryHover,
    Color? primarySubtle,
    Color? onPrimary,
    Color? screen,
    Color? card,
    Color? field,
    Color? raised,
    Color? sunken,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
    Color? link,
    Color? border,
    Color? borderStrong,
    Color? focus,
    Color? success,
    Color? successSubtle,
    Color? alert,
    Color? alertSubtle,
    Color? alertText,
    Color? danger,
    Color? dangerSubtle,
    Color? info,
    Color? infoSubtle,
    Color? scrim,
    Color? inverse,
    Color? onInverse,
    Color? inverseLink,
  }) => AppColors(
    primary: primary ?? this.primary,
    primaryHover: primaryHover ?? this.primaryHover,
    primarySubtle: primarySubtle ?? this.primarySubtle,
    onPrimary: onPrimary ?? this.onPrimary,
    screen: screen ?? this.screen,
    card: card ?? this.card,
    field: field ?? this.field,
    raised: raised ?? this.raised,
    sunken: sunken ?? this.sunken,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
    textDisabled: textDisabled ?? this.textDisabled,
    link: link ?? this.link,
    border: border ?? this.border,
    borderStrong: borderStrong ?? this.borderStrong,
    focus: focus ?? this.focus,
    success: success ?? this.success,
    successSubtle: successSubtle ?? this.successSubtle,
    alert: alert ?? this.alert,
    alertSubtle: alertSubtle ?? this.alertSubtle,
    alertText: alertText ?? this.alertText,
    danger: danger ?? this.danger,
    dangerSubtle: dangerSubtle ?? this.dangerSubtle,
    info: info ?? this.info,
    infoSubtle: infoSubtle ?? this.infoSubtle,
    scrim: scrim ?? this.scrim,
    inverse: inverse ?? this.inverse,
    onInverse: onInverse ?? this.onInverse,
    inverseLink: inverseLink ?? this.inverseLink,
  );

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      screen: Color.lerp(screen, other.screen, t)!,
      card: Color.lerp(card, other.card, t)!,
      field: Color.lerp(field, other.field, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      sunken: Color.lerp(sunken, other.sunken, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      link: Color.lerp(link, other.link, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSubtle: Color.lerp(successSubtle, other.successSubtle, t)!,
      alert: Color.lerp(alert, other.alert, t)!,
      alertSubtle: Color.lerp(alertSubtle, other.alertSubtle, t)!,
      alertText: Color.lerp(alertText, other.alertText, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSubtle: Color.lerp(dangerSubtle, other.dangerSubtle, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoSubtle: Color.lerp(infoSubtle, other.infoSubtle, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      inverse: Color.lerp(inverse, other.inverse, t)!,
      onInverse: Color.lerp(onInverse, other.onInverse, t)!,
      inverseLink: Color.lerp(inverseLink, other.inverseLink, t)!,
    );
  }
}
