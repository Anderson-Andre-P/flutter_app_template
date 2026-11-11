import 'package:flutter/services.dart';

/// Keeps only digits and lays them over [pattern], where `#` is a digit and
/// anything else is inserted as typed: `##/##/####` turns `25122026` into
/// `25/12/2026`.
class DigitMaskFormatter extends TextInputFormatter {
  const DigitMaskFormatter(this.pattern);

  final String pattern;

  static const date = DigitMaskFormatter('##/##/####');
  static const time = DigitMaskFormatter('##:##');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final out = StringBuffer();
    var d = 0;
    for (var i = 0; i < pattern.length && d < digits.length; i++) {
      out.write(pattern[i] == '#' ? digits[d++] : pattern[i]);
    }
    final text = out.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
