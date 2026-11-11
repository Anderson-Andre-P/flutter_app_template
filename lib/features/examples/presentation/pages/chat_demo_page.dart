import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/app_attachment.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chat.dart';
import '../../../../core/widgets/app_media_placeholder.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_viewer.dart';
import '../../application/demo_tags_bloc.dart';
import '../examples_strings.dart';
import '../widgets/demo_scaffold.dart';

/// Catalogue of comments, files and media (design system, sections 16 and
/// 18): a comment thread with the composer, message attachments in each
/// upload state, media placeholders, file-type badges and the full-screen
/// viewer. Sent comments live in a [DemoTagsBloc].
class ChatDemoPage extends StatelessWidget {
  const ChatDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    void soon() => AppSnackbar.info(context, ExamplesStrings.comingSoon);
    const m = ExamplesStrings.chatMessages;
    const t = ExamplesStrings.chatTimes;
    return BlocProvider(
      create: (_) => DemoTagsBloc(const []),
      child: DemoScaffold(
        title: ExamplesStrings.chatTitle,
        children: [
          DemoSection(
            title: ExamplesStrings.chatThread,
            caption: ExamplesStrings.chatThreadCaption,
            child: AppCard(
              child: BlocBuilder<DemoTagsBloc, List<String>>(
                builder: (context, sent) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppChatDay(label: ExamplesStrings.chatToday),
                    AppChatBubble(
                      text: m[0],
                      time: t[0],
                      author: ExamplesStrings.chatAna,
                      initials: ExamplesStrings.chatAnaInitials,
                    ),
                    AppChatBubble(
                      text: m[1],
                      time: t[1],
                      mine: true,
                      read: true,
                    ),
                    AppChatBubble(
                      text: m[2],
                      time: t[2],
                      author: ExamplesStrings.chatRafael,
                      initials: ExamplesStrings.chatRafaelInitials,
                    ),
                    AppChatBubble(
                      text: m[3],
                      time: t[3],
                      author: ExamplesStrings.chatRafael,
                      initials: ExamplesStrings.chatRafaelInitials,
                      firstInGroup: false,
                      attachment: const SizedBox(
                        width: 200,
                        height: 90,
                        child: AppMediaPlaceholder(kind: AppMediaKind.image),
                      ),
                    ),
                    for (final (i, text) in sent.indexed)
                      AppChatBubble(
                        text: text,
                        time: ExamplesStrings.chatNow,
                        mine: true,
                        firstInGroup: i == 0,
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    AppMessageComposer(
                      hint: ExamplesStrings.chatHint,
                      onSend: (text) =>
                          context.read<DemoTagsBloc>().add(DemoTagAdded(text)),
                      onAttach: soon,
                    ),
                  ],
                ),
              ),
            ),
          ),
          DemoSection(
            title: ExamplesStrings.chatFiles,
            caption: ExamplesStrings.chatFilesCaption,
            child: Column(
              children: [
                for (final (i, (name, detail))
                    in ExamplesStrings.chatFileList.indexed) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.sm),
                  AppAttachmentTile(
                    name: name,
                    detail: detail,
                    status: const [
                      AppAttachmentStatus.sent,
                      AppAttachmentStatus.uploading,
                      AppAttachmentStatus.waiting,
                      AppAttachmentStatus.failed,
                    ][i],
                    progress: .64,
                    onOpen: soon,
                    onDownload: soon,
                    onCancel: soon,
                    onRemove: soon,
                  ),
                ],
              ],
            ),
          ),
          DemoSection(
            title: ExamplesStrings.mediaTitle,
            caption: ExamplesStrings.mediaCaption,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (final (i, label)
                        in ExamplesStrings.mediaLabels.indexed) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.6,
                          child: AppMediaPlaceholder(
                            kind: AppMediaKind.values[i],
                            label: label,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    for (final name in ExamplesStrings.mediaFileTypes) ...[
                      AppFileBadge(fileName: name),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: ExamplesStrings.viewerOpen,
                  icon: Icons.fullscreen,
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.md,
                  onPressed: () => AppViewer.open(
                    context,
                    title: ExamplesStrings.viewerTitle,
                    initial: 1,
                    pages: [
                      for (final label in ExamplesStrings.viewerPages)
                        AspectRatio(
                          aspectRatio: .75,
                          child: AppMediaPlaceholder(
                            kind: AppMediaKind.attachment,
                            label: label,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
