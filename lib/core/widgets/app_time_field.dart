import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import '../utils/formatters.dart';
import 'app_bottom_sheet.dart';
import 'app_icon_button.dart';
import 'app_text_field.dart';
import 'input_masks.dart';

/// A time of day, 24h.
typedef AppTime = ({int hour, int minute});

/// Time field of the design system (section 26): `HH:MM` in 24h, accepts
/// typing and checks it when leaving the field; the clock button lists the
/// times every [minuteStep] minutes (13:00, 13:30…) in a bottom sheet.
/// [onChanged] receives `null` when what was typed is not a time.
class AppTimeField extends StatefulWidget {
  const AppTimeField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.minuteStep = 30,
    this.errorText,
    this.required = false,
    this.enabled = true,
  });

  final String label;
  final AppTime? value;
  final ValueChanged<AppTime?> onChanged;
  final int minuteStep;
  final String? errorText;
  final bool required;
  final bool enabled;

  @override
  State<AppTimeField> createState() => _AppTimeFieldState();
}

class _AppTimeFieldState extends State<AppTimeField> {
  late final _controller = TextEditingController(text: _text(widget.value));

  static String _text(AppTime? t) =>
      t == null ? '' : formatTime(t.hour, t.minute);

  @override
  void didUpdateWidget(AppTimeField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value &&
        parseTime(_controller.text) != widget.value) {
      _controller.text = _text(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit() => widget.onChanged(parseTime(_controller.text));

  Future<void> _openList() async {
    final current = widget.value ?? parseTime(_controller.text);
    final times = <AppTime>[
      for (var m = 0; m < 24 * 60; m += widget.minuteStep)
        (hour: m ~/ 60, minute: m % 60),
    ];
    final picked = await AppBottomSheet.show<AppTime>(
      context,
      title: widget.label,
      child: _TimeList(times: times, selected: current),
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
      hint: CommonStrings.timeHint,
      errorText: widget.errorText,
      required: widget.required,
      enabled: widget.enabled,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: const [DigitMaskFormatter.time],
      onSubmitted: (_) => _commit(),
      suffix: AppIconButton(
        icon: Icons.schedule,
        label: CommonStrings.chooseTime,
        bordered: false,
        onPressed: widget.enabled ? _openList : null,
      ),
    ),
  );
}

class _TimeList extends StatefulWidget {
  const _TimeList({required this.times, required this.selected});

  final List<AppTime> times;
  final AppTime? selected;

  @override
  State<_TimeList> createState() => _TimeListState();
}

/// Owns the scroll position only, so the list opens at the current time.
class _TimeListState extends State<_TimeList> {
  late final _scroll = ScrollController(
    initialScrollOffset: _start <= 0 ? 0 : (_start - 1) * AppSizes.listTileMin,
  );

  int get _start =>
      widget.selected == null ? 0 : widget.times.indexOf(widget.selected!);

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final times = widget.times;
    final selected = widget.selected;
    return SizedBox(
      height: AppSizes.listTileMin * 6,
      child: ListView.builder(
        controller: _scroll,
        itemExtent: AppSizes.listTileMin,
        itemCount: times.length,
        itemBuilder: (context, i) {
          final t = times[i];
          final isSelected = t == selected;
          return Material(
            color: isSelected ? c.primarySubtle : Colors.transparent,
            borderRadius: AppRadius.brSm,
            child: InkWell(
              borderRadius: AppRadius.brSm,
              onTap: () => Navigator.of(context).pop(t),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    formatTime(t.hour, t.minute),
                    style:
                        (isSelected ? AppTypography.label : AppTypography.body)
                            .copyWith(
                              color: isSelected ? c.primary : c.textPrimary,
                            ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
