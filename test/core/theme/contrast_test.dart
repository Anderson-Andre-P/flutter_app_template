import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_app_template/core/theme/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.1 contrast ratio between two opaque colours.
double contrast(Color a, Color b) {
  double channel(double c) =>
      c <= .03928 ? c / 12.92 : math.pow((c + .055) / 1.055, 2.4).toDouble();
  double luminance(Color c) =>
      .2126 * channel(c.r) + .7152 * channel(c.g) + .0722 * channel(c.b);
  final (la, lb) = (luminance(a), luminance(b));
  return (math.max(la, lb) + .05) / (math.min(la, lb) + .05);
}

typedef _Pair = (String fg, String bg);

/// Design system, section 23: 4.5:1 for text, 3:1 for icons and control
/// borders, between the colour pairs the widgets actually use, in both
/// themes. `textDisabled` (decorative) and the hairline `border` of cards
/// are out on purpose.
void main() {
  Map<String, Color> roles(AppColors c) => {
    'screen': c.screen,
    'card': c.card,
    'field': c.field,
    'raised': c.raised,
    'textPrimary': c.textPrimary,
    'textSecondary': c.textSecondary,
    'textMuted': c.textMuted,
    'onPrimary': c.onPrimary,
    'primary': c.primary,
    'primarySubtle': c.primarySubtle,
    'link': c.link,
    'focus': c.focus,
    'borderStrong': c.borderStrong,
    'success': c.success,
    'successSubtle': c.successSubtle,
    'alert': c.alert,
    'alertSubtle': c.alertSubtle,
    'alertText': c.alertText,
    'danger': c.danger,
    'dangerSubtle': c.dangerSubtle,
    'info': c.info,
    'infoSubtle': c.infoSubtle,
  };

  const text = <_Pair>[
    ('textPrimary', 'screen'),
    ('textPrimary', 'card'),
    ('textPrimary', 'field'),
    ('textPrimary', 'raised'),
    ('textPrimary', 'successSubtle'),
    ('textSecondary', 'card'),
    ('textSecondary', 'screen'),
    ('textMuted', 'card'),
    ('textMuted', 'screen'),
    ('textMuted', 'field'),
    ('textMuted', 'primarySubtle'),
    ('onPrimary', 'primary'),
    ('onPrimary', 'success'),
    ('link', 'card'),
    ('primary', 'card'),
    ('primary', 'primarySubtle'),
    ('danger', 'card'),
    ('danger', 'dangerSubtle'),
    ('card', 'danger'),
    ('success', 'card'),
    ('success', 'successSubtle'),
    ('alertText', 'card'),
    ('alertText', 'alertSubtle'),
    ('info', 'infoSubtle'),
  ];

  const ui = <_Pair>[
    ('focus', 'card'),
    ('focus', 'screen'),
    ('textMuted', 'card'),
    ('primary', 'card'),
    ('alert', 'card'),
    ('alert', 'alertSubtle'),
    ('borderStrong', 'card'),
  ];

  /// Pairs of the current palette that do not reach AA yet — a decision for
  /// the design system, recorded in docs/design-system-backlog.md. Each one
  /// must still be below its target: once the palette is fixed, this test
  /// fails until the pair leaves the list.
  const knownLow = <String, Set<_Pair>>{
    'light': {
      ('textMuted', 'screen'),
      ('textMuted', 'field'),
      ('textMuted', 'primarySubtle'),
      ('success', 'successSubtle'),
      ('alert', 'card'),
      ('alert', 'alertSubtle'),
      ('borderStrong', 'card'),
    },
    'dark': {
      ('textMuted', 'field'),
      ('textMuted', 'primarySubtle'),
      ('borderStrong', 'card'),
    },
  };

  for (final (name, palette) in [
    ('light', AppColors.light),
    ('dark', AppColors.dark),
  ]) {
    final c = roles(palette);
    for (final (pairs, target, kind) in [
      (text, 4.5, 'text'),
      (ui, 3.0, 'icons and borders'),
    ]) {
      group('$name · $kind ($target:1)', () {
        for (final pair in pairs) {
          final (fg, bg) = pair;
          final ratio = contrast(c[fg]!, c[bg]!);
          final known = knownLow[name]!.contains(pair);
          test('$fg on $bg (${ratio.toStringAsFixed(2)}:1)', () {
            if (known) {
              expect(
                ratio,
                lessThan(target),
                reason: 'Now reaches $target:1 — remove it from knownLow.',
              );
            } else {
              expect(ratio, greaterThanOrEqualTo(target));
            }
          });
        }
      });
    }
  }

  test('contrast matches the WCAG reference values', () {
    expect(contrast(const Color(0xFF000000), const Color(0xFFFFFFFF)), 21);
    expect(
      contrast(const Color(0xFF777777), const Color(0xFFFFFFFF)),
      closeTo(4.48, .01),
    );
  });
}
