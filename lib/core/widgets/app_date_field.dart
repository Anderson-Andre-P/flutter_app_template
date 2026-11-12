import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../utils/formatters.dart';
import 'app_calendar.dart';
import 'app_icon_button.dart';
import 'app_text_field.dart';
import 'input_masks.dart';

/// Date field of the design system (section 26): `DD/MM/AAAA`, accepts
/// typing (the slashes come by themselves) and checks it when leaving the
/// field; the calendar button opens [AppCalendar.pick].
///
/// [onChanged] receives the typed date, or `null` when what was typed is
/// not a date. Out-of-range messages ("Data no passado.") are the screen's
/// [errorText] — the field does not hide a date the user typed.
class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.firstDate,
    this.lastDate,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.hint = CommonStrings.dateHint,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;
  final bool required;

  /// `false` for a date "definido pelo sistema".
  final bool enabled;
  final String hint;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  late final _controller = TextEditingController(text: _text(widget.value));

  static String _text(DateTime? date) =>
      date == null ? '' : formatNumericDate(date);

  @override
  void didUpdateWidget(AppDateField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value &&
        parseNumericDate(_controller.text) != widget.value) {
      _controller.text = _text(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit() => widget.onChanged(parseNumericDate(_controller.text));

  Future<void> _openCalendar() async {
    final picked = await AppCalendar.pick(
      context,
      title: widget.label,
      initial: widget.value ?? parseNumericDate(_controller.text),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked == null) return;
    _controller.text = _text(picked);
    widget.onChanged(picked);
  }

  @override
  Widget build(BuildContext context) => Focus(
    canRequestFocus: false,
    skipTraversal: true,
    onFocusChange: (focused) {
      if (!focused) _commit();
    },
    child: AppTextField(
      label: widget.label,
      controller: _controller,
      hint: widget.hint,
      errorText: widget.errorText,
      required: widget.required,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: const [DigitMaskFormatter.date],
      onSubmitted: (_) => _commit(),
      suffix: AppIconButton(
        icon: Icons.calendar_today_outlined,
        label: CommonStrings.chooseDate,
        bordered: false,
        onPressed: widget.enabled ? _openCalendar : null,
      ),
    ),
  );
}
