import 'package:flutter/painting.dart';

/// Type scale of the design system (Inter). Styles carry no colour: widgets
/// apply `textPrimary` (or another role) from `context.colors`.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';
  static const String monoFamily = 'monospace';
  static const List<String> monoFallback = ['Menlo', 'Courier'];

  static const TextStyle _base = TextStyle(fontFamily: fontFamily);

  /// Onboarding, splash, welcome.
  static final TextStyle display = _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
  );

  /// Screen and object title.
  static final TextStyle title = _base.copyWith(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
  );

  /// Subtitle inside a long screen.
  static final TextStyle heading = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// Card header.
  static final TextStyle section = _base.copyWith(
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  /// Description, paragraph, list item.
  static final TextStyle body = _base.copyWith(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
  );

  /// Body inside a dense card.
  static final TextStyle bodySmall = _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
  );

  /// Field label, button, link.
  static final TextStyle label = _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
  );

  /// Supporting label, list row.
  static final TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// Metadata, timestamp.
  static final TextStyle caption = _base.copyWith(
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
  );

  /// Highlighted metadata.
  static final TextStyle captionBold = _base.copyWith(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
  );

  /// Section divider — render in CAPS (`SectionOverline` does it).
  static final TextStyle overline = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.9,
  );

  /// Discreet group label — render in CAPS.
  static final TextStyle overlineRegular = _base.copyWith(
    fontSize: 10.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.9,
  );

  /// Small auxiliary text.
  static final TextStyle micro = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle microMedium = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle microBold = _base.copyWith(
    fontSize: 10.5,
    fontWeight: FontWeight.w700,
  );

  /// Codes and identifiers.
  static const TextStyle mono = TextStyle(
    fontFamily: monoFamily,
    fontFamilyFallback: monoFallback,
    fontSize: 11.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle monoBold = TextStyle(
    fontFamily: monoFamily,
    fontFamilyFallback: monoFallback,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
}
