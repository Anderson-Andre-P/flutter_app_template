import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Sizes follow the screen (flutter_screenutil_plus). Every token is the
// design-system number on the `AppScreen.designSize` frame, scaled by kind:
// widths `.w`, heights `.h`, radii and square shapes (icons, avatars,
// controls) `.r`, fonts `.sp` (in `AppTypography`). Spacing is used both
// across and down, so it scales with `.r` (the smaller ratio). Widgets keep
// reading tokens, never `16.w` (golden rule 4). Not scaled, on purpose: the
// 44px minimum touch target, the focus ring and error border, hairlines,
// ratios and the full radius; durations and shadows neither. Values are
// getters, so they are not `const`.

/// The frame the sizes are designed on.
abstract final class AppScreen {
  static const Size designSize = Size(360, 690);
}

/// Spacing scale: base 4, named by size (not by number) so a step can be
/// tuned without renaming. Screen margin = [xl]; between cards = [md];
/// between sections = [x3l].
abstract final class AppSpacing {
  /// Hairline gap between tightly paired pieces (a day and its dots, a
  /// metric's label and value).
  static double get xxs => 2.r;
  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get x2l => 24.r;
  static double get x3l => 32.r;
  static double get x4l => 40.r;

  /// Horizontal margin of every screen.
  static EdgeInsets get screen => EdgeInsets.symmetric(horizontal: xl);
}

/// Corner radius grows with the element: badge < chip < field/button < card
/// < sheet/modal. Nested radius = parent radius − parent padding.
abstract final class AppRadius {
  /// The speaker's corner of a chat bubble.
  static double get tail => 4.r;
  static double get xs => 6.r;
  static double get sm => 9.r;

  /// 10, between [sm] and [md]: day tiles, the settings icon box and the
  /// buttons of the mini stepper.
  static double get smPlus => 10.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 22.r;
  static const double full = 999;

  static BorderRadius get brXs => BorderRadius.all(Radius.circular(xs));
  static BorderRadius get brSm => BorderRadius.all(Radius.circular(sm));
  static BorderRadius get brSmPlus => BorderRadius.all(Radius.circular(smPlus));
  static BorderRadius get brMd => BorderRadius.all(Radius.circular(md));
  static BorderRadius get brLg => BorderRadius.all(Radius.circular(lg));
  static BorderRadius get brXl => BorderRadius.all(Radius.circular(xl));
  static BorderRadius get brFull =>
      const BorderRadius.all(Radius.circular(full));

  /// 14, between field and card: toast, dialog icon box.
  static BorderRadius get brMdPlus => BorderRadius.all(Radius.circular(14.r));

  /// Top corners only — surfaces anchored to the bottom edge (bottom bar,
  /// bottom sheet).
  static BorderRadius get topXl =>
      BorderRadius.vertical(top: Radius.circular(xl));
}

/// Fixed component sizes from the design system.
abstract final class AppSizes {
  /// Isolated call to action, onboarding.
  static double get buttonXl => 58.h;

  /// The screen's primary action (design system, section 09: 52px).
  static double get buttonLg => 52.h;

  /// "Continuar com …" identity-provider buttons (section 10: 48px).
  static double get socialButton => 48.h;
  static double get buttonMd => 44.h;
  static double get buttonSm => 38.h;

  /// Action inside a table or list row.
  static double get buttonXs => 30.h;
  static const double minTouchTarget = 44;
  static double get field => 48.h;

  /// Bottom bar without a system inset (design system: 64).
  static double get bottomNav => 64.h;

  /// Minimum height of the tabs when a system inset (home indicator, Android
  /// gesture/button bar) sits below them: the inset takes the rest of the 64
  /// instead of stacking on top of it.
  static double get bottomNavContent => 48.h;

  /// Largest text scale inside fixed-height bars (bottom navigation).
  static const double barTextScaleMax = 1.5;
  static double get chip => 32.h;

  /// Switch track and knob; checkbox and radio box.
  static double get switchWidth => 46.r;
  static double get switchHeight => 26.r;
  static double get switchKnob => 20.r;
  static double get switchInset => (switchHeight - switchKnob) / 2;
  static double get checkbox => 22.r;

  /// Round FAB side and extended FAB height.
  static double get fab => 58.r;
  static double get fabExtended => 52.h;

  /// Coloured bar at the start of a status tile.
  static double get statusBar => 4.w;

  /// Slider track thickness and handle diameter; the handle's touch
  /// target is [minTouchTarget].
  static double get sliderTrack => 6.r;
  static double get sliderThumb => 22.r;

  /// Step circle of the horizontal stepper; underline of the active tab.
  static double get stepCircle => 26.r;
  static const double tabIndicator = 2;

  /// Notification counter pill and the "new" dot.
  static double get counter => 20.r;

  /// Counter over an icon (the bell), ring included, and the ring that
  /// cuts it out of the icon below.
  static double get counterCompact => 18.r;
  static const double counterRing = 2;
  static double get newDot => 8.r;

  /// Determinate progress ring and its stroke.
  static double get progressRing => 56.r;
  static double get progressRingStroke => 6.r;

  /// Status dot on an avatar.
  static double get avatarStatus => 12.r;

  /// File-type badge (PDF, JPG, XLS) at the start of an attachment.
  static double get fileBadge => 40.r;

  /// Timeline dot and its halo; page indicator dot (the current one is
  /// [pageDotActive] wide).
  static double get timelineDot => 10.r;
  static double get timelineHalo => 18.r;
  static double get pageDot => 6.r;
  static double get pageDotActive => 18.r;

  /// Gap between the parts of a segmented bar.
  static const double barGap = 2;

  /// Widest a chat bubble gets, as a share of the row.
  static const double bubbleMaxShare = .78;

  /// Media strip of a card, and the thumbnail of a horizontal card.
  static double get cardMedia => 104.h;
  static double get cardThumb => 112.w;

  /// Width of the numeric stepper (− value +).
  static double get numberStepper => 140.w;

  /// Button of the mini stepper (inside a 44px touch target) and the width
  /// of its value.
  static double get miniStepperButton => 32.r;
  static double get miniStepperValue => 44.w;

  /// Width of the load stepper card (label, value, − and + buttons).
  static double get loadStepper => 171.w;

  /// Icon box at the start of a settings row.
  static double get settingsIcon => 34.r;

  /// Countdown ring: full screen, inside a card, and compact (beside other
  /// content). Its stroke is a share of the side.
  static double get countdownLg => 248.r;
  static double get countdownMd => 220.r;
  static double get countdownSm => 96.r;
  static const double countdownStrokeShare = .05;

  /// Day of the history strip: the number circle, its activity dot and the
  /// cell width; the goal tile is a square.
  static double get dayCircle => 32.r;
  static double get dayMark => 5.r;
  static double get dayCell => 44.w;
  static double get goalDay => 44.r;

  /// Goal line across a bar chart.
  static const double chartGoalLine = 2;

  /// Icon box at the start of an attention band.
  static double get bandIcon => 24.r;
  static double get progressBar => 8.r;
  static double get iconBox => 40.r;
  static double get heroIcon => 80.r;
  static double get chart => 160.h;

  /// Thickness of the donut chart's ring.
  static double get donutRing => 26.r;
  static double get sheetHandleWidth => 36.w;
  static double get sheetHandleHeight => 4.h;
  static double get pill => 26.h;
  static double get listTileMin => 56.h;
  static double get modalMaxWidth => 340.w;
  static const double focusRing = 2;

  /// Gap between a control and its focus ring.
  static const double focusRingGap = 2;
  static const double errorBorder = 2;

  /// Dividers and 1px separators: never scaled, a hairline stays a hairline.
  static const double hairline = 1;

  /// Spinner inside a button.
  static double get spinner => 18.r;

  /// Status dot of a badge.
  static double get badgeDot => 6.r;

  /// Line chart stroke and point; slider handle ring; dashed outline.
  static double get chartStroke => 2.5.r;
  static double get chartDot => 4.r;
  static double get sliderRing => 2.5.r;
  static double get dash => 5.r;
  static double get dashGap => 4.r;

  /// The short line of a skeleton (a subtitle under a full line).
  static double get skeletonShortLine => 140.w;

  /// An image placed in a chat bubble.
  static double get chatMediaWidth => 200.w;
  static double get chatMediaHeight => 90.h;

  /// Icon box at the top of a dialog.
  static double get dialogIcon => 42.r;

  /// Round tone icon at the start of a toast.
  static double get toastIcon => 28.r;

  /// Toasts never grow wider than this on a tablet.
  static double get toastMaxWidth => 500.w;

  static double get avatarSm => 24.r;
  static double get avatarMd => 32.r;
  static double get avatarLg => 40.r;
  static double get avatarXl => 56.r;

  static double get iconInline => 12.r;
  static double get iconChip => 15.r;
  static double get iconField => 17.r;
  static double get iconTopBar => 20.r;
  static double get icon => 22.r;
}

/// Motion tokens.
abstract final class AppDurations {
  static const Duration sheet = Duration(milliseconds: 220);
  static const Duration dialog = Duration(milliseconds: 200);
  static const Duration toast = Duration(milliseconds: 200);
  static const Duration accordion = Duration(milliseconds: 160);
  static const Duration toggle = Duration(milliseconds: 180);

  /// One sweep of the skeleton shimmer, looped.
  static const Duration shimmer = Duration(milliseconds: 1200);

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
