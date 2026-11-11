import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_avatar.dart';
import 'app_icon_button.dart';

/// A comment tied to a record (design system, section 16) — part of its
/// audit trail, so it cannot be deleted. Own messages go right in primary;
/// others go left in grey, with avatar and name only on the
/// [firstInGroup] message of a run. The corner on the speaker's side is
/// 4px.
class AppChatBubble extends StatelessWidget {
  const AppChatBubble({
    super.key,
    required this.text,
    required this.time,
    this.mine = false,
    this.read = false,
    this.author,
    this.initials,
    this.firstInGroup = true,
    this.attachment,
  });

  final String text;
  final String time;
  final bool mine;

  /// Own messages only: shows the double tick.
  final bool read;
  final String? author;
  final String? initials;
  final bool firstInGroup;

  /// Shown under the text (an image placeholder, a file tile).
  final Widget? attachment;

  static const _corner = Radius.circular(AppRadius.tail);
  static const _round = Radius.circular(AppRadius.lg);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final showHeader = !mine && firstInGroup;
    final bubble = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: mine ? c.primary : c.primarySubtle,
        borderRadius: BorderRadius.only(
          topLeft: !mine && firstInGroup ? _corner : _round,
          topRight: mine ? _corner : _round,
          bottomLeft: _round,
          bottomRight: _round,
        ),
      ),
      child: Text(
        text,
        style: AppTypography.body.copyWith(
          color: mine ? c.onPrimary : c.textPrimary,
        ),
      ),
    );
    final meta = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(time, style: AppTypography.caption.copyWith(color: c.textMuted)),
        if (mine && read) ...[
          const SizedBox(width: AppSpacing.xs),
          Semantics(
            label: CommonStrings.read,
            child: Icon(
              Icons.done_all,
              size: AppSizes.iconInline + AppSpacing.xs,
              color: c.primary,
            ),
          ),
        ],
      ],
    );
    return Padding(
      padding: EdgeInsets.only(
        top: firstInGroup ? AppSpacing.md : AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine) ...[
            SizedBox(
              width: AppSizes.avatarMd,
              child: showHeader && initials != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: AppAvatar(
                        initials: initials!,
                        size: AppSizes.avatarMd,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * AppSizes.bubbleMaxShare,
                ),
                child: Column(
                  crossAxisAlignment: mine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showHeader && author != null) ...[
                      Text(
                        author!,
                        style: AppTypography.caption.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    bubble,
                    if (attachment case final a?) ...[
                      const SizedBox(height: AppSpacing.xs),
                      a,
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    meta,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Hoje", "Ontem" between messages of different days.
class AppChatDay extends StatelessWidget {
  const AppChatDay({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: c.primarySubtle,
          borderRadius: AppRadius.brXs,
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(color: c.textSecondary),
        ),
      ),
    );
  }
}

/// Write a comment (design system, section 16): the text, an attach button
/// and a round send button, enabled once there is text.
class AppMessageComposer extends StatefulWidget {
  const AppMessageComposer({
    super.key,
    required this.hint,
    required this.onSend,
    this.onAttach,
  });

  final String hint;

  /// Receives the trimmed text; the field is cleared after.
  final ValueChanged<String> onSend;
  final VoidCallback? onAttach;

  @override
  State<AppMessageComposer> createState() => _AppMessageComposerState();
}

/// Owns only the text being typed.
class _AppMessageComposerState extends State<AppMessageComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _empty => _controller.text.trim().isEmpty;

  void _send() {
    if (_empty) return;
    widget.onSend(_controller.text.trim());
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: AppSpacing.lg,
        end: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.brXl,
        border: Border.all(color: c.borderStrong),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _send(),
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 4,
              style: AppTypography.body.copyWith(color: c.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
          if (widget.onAttach case final attach?)
            AppIconButton(
              icon: Icons.attach_file,
              label: CommonStrings.attach,
              bordered: false,
              onPressed: attach,
            ),
          Semantics(
            button: true,
            enabled: !_empty,
            label: CommonStrings.send,
            child: ExcludeSemantics(
              child: SizedBox.square(
                dimension: AppSizes.minTouchTarget,
                child: Center(
                  child: Material(
                    color: _empty ? c.sunken : c.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _empty ? null : _send,
                      child: SizedBox.square(
                        dimension: AppSizes.avatarLg - AppSpacing.xs,
                        child: Icon(
                          Icons.arrow_forward,
                          size: AppSizes.iconTopBar,
                          color: _empty ? c.textDisabled : c.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
