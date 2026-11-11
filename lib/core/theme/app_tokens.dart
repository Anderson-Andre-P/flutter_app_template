import 'package:flutter/material.dart';

/// Spacing scale: base 4, named by size (not by number) so a step can be
/// tuned without renaming. Screen margin = [xl]; between cards = [md];
/// between sections = [x3l].
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double x2l = 24;
  static const double x3l = 32;
  static const double x4l = 40;

  /// Horizontal margin of every screen.
  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: xl);
}

/// Corner radius grows with the element: badge < chip < field/button < card
/// < sheet/modal. Nested radius = parent radius − parent padding.
abstract final class AppRadius {
  static const double xs = 6;
  static const double sm = 9;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 22;
  static const double full = 999;

  static const BorderRadius brXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));

  /// Toast (design system: 14, between field and card).
  static const BorderRadius brToast = BorderRadius.all(Radius.circular(14));

  /// Top corners only — surfaces anchored to the bottom edge (bottom bar,
  /// bottom sheet).
  static const BorderRadius topXl = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}

/// Fixed component sizes from the design system.
abstract final class AppSizes {
  static const double buttonLg = 48;
  static const double buttonMd = 44;
  static const double buttonSm = 38;
  static const double minTouchTarget = 44;
  static const double field = 48;

  /// Bottom bar without a system inset (design system: 64).
  static const double bottomNav = 64;

  /// Minimum height of the tabs when a system inset (home indicator, Android
  /// gesture/button bar) sits below them: the inset takes the rest of the 64
  /// instead of stacking on top of it.
  static const double bottomNavContent = 48;
  static const double chip = 32;
  static const double progressBar = 8;
  static const double iconBox = 40;
  static const double heroIcon = 80;
  static const double chart = 160;
  static const double sheetHandleWidth = 36;
  static const double sheetHandleHeight = 4;
  static const double pill = 26;
  static const double listTileMin = 56;
  static const double modalMaxWidth = 340;
  static const double focusRing = 2;
  static const double errorBorder = 2;

  /// Round tone icon at the start of a toast.
  static const double toastIcon = 28;

  /// Toasts never grow wider than this on a tablet.
  static const double toastMaxWidth = 500;

  static const double avatarSm = 24;
  static const double avatarMd = 32;
  static const double avatarLg = 40;
  static const double avatarXl = 56;

  static const double iconInline = 12;
  static const double iconChip = 15;
  static const double iconField = 17;
  static const double iconTopBar = 20;
  static const double icon = 22;
}

/// Motion tokens.
abstract final class AppDurations {
  static const Duration sheet = Duration(milliseconds: 220);
  static const Duration dialog = Duration(milliseconds: 200);
  static const Duration toast = Duration(milliseconds: 200);
  static const Duration accordion = Duration(milliseconds: 160);
  static const Duration toggle = Duration(milliseconds: 180);

  /// How long a toast stays on screen. Error toasts stay until dismissed.
  static const Duration toastVisible = Duration(seconds: 4);

  static const Curve sheetCurve = Cubic(.22, .75, .3, 1);
}

/// Elevation tokens. In light mode depth is a shadow; in dark mode shadows
/// give no contrast, so every level is empty and depth comes from the
/// surface colours (`card` → `field` → `raised`).
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    required this.elev1,
    required this.elev2,
    required this.elev3,
    required this.elev4,
  });

  /// Card: separates from the background without suggesting float.
  final List<BoxShadow> elev1;

  /// Primary button / FAB: invites the tap.
  final List<BoxShadow> elev2;

  /// Popover, menu, drawer.
  final List<BoxShadow> elev3;

  /// Modal dialog and sheet.
  final List<BoxShadow> elev4;

  static const light = AppShadows(
    elev1: [
      BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x0A101E36)),
    ],
    elev2: [
      BoxShadow(offset: Offset(0, 8), blurRadius: 20, color: Color(0x3D004AC6)),
    ],
    elev3: [
      BoxShadow(
        offset: Offset(0, 14),
        blurRadius: 30,
        color: Color(0x26101E36),
      ),
    ],
    elev4: [
      BoxShadow(
        offset: Offset(0, 20),
        blurRadius: 44,
        color: Color(0x3D101E36),
      ),
    ],
  );

  static const dark = AppShadows(elev1: [], elev2: [], elev3: [], elev4: []);

  @override
  AppShadows copyWith({
    List<BoxShadow>? elev1,
    List<BoxShadow>? elev2,
    List<BoxShadow>? elev3,
    List<BoxShadow>? elev4,
  }) => AppShadows(
    elev1: elev1 ?? this.elev1,
    elev2: elev2 ?? this.elev2,
    elev3: elev3 ?? this.elev3,
    elev4: elev4 ?? this.elev4,
  );

  @override
  AppShadows lerp(covariant AppShadows? other, double t) =>
      other == null || t < .5 ? this : other;
}
