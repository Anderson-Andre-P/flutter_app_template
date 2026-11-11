import 'package:flutter/painting.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Type scale of the design system (Inter). Styles carry no colour: widgets
/// apply `textPrimary` (or another role) from `context.colors`. Font sizes
/// follow the screen with `.sp`; the system text size (accessibility) still
/// applies on top, through `MediaQuery.textScaler`.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';
  static const String monoFamily = 'monospace';
  static const List<String> monoFallback = ['Menlo', 'Courier'];

  static const TextStyle _base = TextStyle(fontFamily: fontFamily);

  /// Onboarding, splash, welcome.
  static TextStyle get display => _base.copyWith(
    fontSize: 26.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
  );

  /// The number of a load stepper ("45 kg").
  static TextStyle get metricLg => _base.copyWith(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  /// The number of a metric ("5,20 km").
  static TextStyle get metric => _base.copyWith(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
  );

  /// Screen and object title.
  static TextStyle get title => _base.copyWith(
    fontSize: 23.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
  );

  /// Subtitle inside a long screen.
  static TextStyle get heading => _base.copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// Card header.
  static TextStyle get section => _base.copyWith(
    fontSize: 14.5.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  /// Description, paragraph, list item.
  static TextStyle get body =>
      _base.copyWith(fontSize: 13.5.sp, fontWeight: FontWeight.w400);

  /// Body inside a dense card.
  static TextStyle get bodySmall =>
      _base.copyWith(fontSize: 12.5.sp, fontWeight: FontWeight.w400);

  /// Field label, button, link.
  static TextStyle get label =>
      _base.copyWith(fontSize: 12.5.sp, fontWeight: FontWeight.w700);

  /// Supporting label, list row.
  static TextStyle get labelMedium =>
      _base.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500);

  /// Metadata, timestamp.
  static TextStyle get caption =>
      _base.copyWith(fontSize: 11.5.sp, fontWeight: FontWeight.w400);

  /// Highlighted metadata.
  static TextStyle get captionBold =>
      _base.copyWith(fontSize: 11.5.sp, fontWeight: FontWeight.w700);

  /// Section divider — render in CAPS (`SectionOverline` does it).
  static TextStyle get overline => _base.copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.9,
  );

  /// Discreet group label — render in CAPS.
  static TextStyle get overlineRegular => _base.copyWith(
    fontSize: 10.5.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.9,
  );

  /// Small auxiliary text.
  static TextStyle get micro =>
      _base.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400);

  static TextStyle get microMedium =>
      _base.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w500);

  static TextStyle get microBold =>
      _base.copyWith(fontSize: 10.5.sp, fontWeight: FontWeight.w700);

  /// Codes and identifiers.
  static TextStyle get mono => TextStyle(
    fontFamily: monoFamily,
    fontFamilyFallback: monoFallback,
    fontSize: 11.5.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get monoBold => TextStyle(
    fontFamily: monoFamily,
    fontFamilyFallback: monoFallback,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );
}
