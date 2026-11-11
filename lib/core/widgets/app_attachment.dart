import 'package:flutter/material.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';
import 'app_dashed_button.dart';
import 'app_icon_button.dart';
import 'app_progress_bar.dart';
import 'app_tone.dart';

/// Where an attachment is in its upload.
enum AppAttachmentStatus { sent, uploading, waiting, failed }

/// The type of a file as a short label on a tinted square (design system,
/// section 16: 38 to 44px, radius 10). Taken from the extension.
class AppFileBadge extends StatelessWidget {
  const AppFileBadge({super.key, required this.fileName});

  final String fileName;

  static (String, AppTone) _kind(String name) {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    return switch (ext) {
      'pdf' => ('PDF', AppTone.danger),
      'jpg' || 'jpeg' => ('JPG', AppTone.primary),
      'png' => ('PNG', AppTone.primary),
      'xls' || 'xlsx' || 'csv' => ('XLS', AppTone.success),
      'doc' || 'docx' => ('DOC', AppTone.info),
      _ => (ext.isEmpty ? '?' : ext.toUpperCase(), AppTone.neutral),
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (label, tone) = _kind(fileName);
    return Container(
      width: AppSizes.fileBadge,
      height: AppSizes.fileBadge,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.toneBackground(tone),
        borderRadius: AppRadius.brSm,
      ),
      child: Text(
        label,
        style: AppTypography.microBold.copyWith(color: c.toneForeground(tone)),
      ),
    );
  }
}

/// One attached file (design system, sections 14 and 16): type badge, name,
/// detail line and the action of its [status] — open when sent, a progress
/// bar and cancel while uploading, a clock while waiting for a connection,
/// "Remover" when it failed.
class AppAttachmentTile extends StatelessWidget {
  const AppAttachmentTile({
    super.key,
    required this.name,
    required this.detail,
    required this.status,
    this.progress = 0,
    this.onOpen,
    this.onCancel,
    this.onRemove,
  });

  final String name;
  final String detail;
  final AppAttachmentStatus status;

  /// 0 to 1, while uploading.
  final double progress;
  final VoidCallback? onOpen;
  final VoidCallback? onCancel;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final failed = status == AppAttachmentStatus.failed;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadius.brLg,
        border: Border.all(
          color: failed ? c.danger.withValues(alpha: .4) : c.border,
        ),
      ),
      child: Row(
        children: [
          AppFileBadge(fileName: name),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMedium.copyWith(
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style: AppTypography.caption.copyWith(
                    color: failed ? c.danger : c.textMuted,
                  ),
                ),
                if (status == AppAttachmentStatus.uploading) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppProgressBar(value: progress),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          switch (status) {
            AppAttachmentStatus.sent => AppIconButton(
              icon: Icons.visibility_outlined,
              label: CommonStrings.openFile,
              bordered: false,
              onPressed: onOpen,
            ),
            AppAttachmentStatus.uploading => AppIconButton(
              icon: Icons.close,
              label: CommonStrings.cancelUpload,
              bordered: false,
              onPressed: onCancel,
            ),
            AppAttachmentStatus.waiting => Semantics(
              label: CommonStrings.waitingConnection,
              child: SizedBox.square(
                dimension: AppSizes.minTouchTarget,
                child: Icon(
                  Icons.schedule,
                  size: AppSizes.iconTopBar,
                  color: c.textMuted,
                ),
              ),
            ),
            AppAttachmentStatus.failed => TextButton(
              onPressed: onRemove,
              style: TextButton.styleFrom(
                foregroundColor: c.danger,
                minimumSize: const Size(
                  AppSizes.minTouchTarget,
                  AppSizes.minTouchTarget,
                ),
              ),
              child: const Text(CommonStrings.removeFile),
            ),
          },
        ],
      ),
    );
  }
}

/// Send a file (design system, section 14). On a phone it is a one-line
/// button — the drop zone exists only on the web — with what is accepted
/// below.
class AppUploadButton extends StatelessWidget {
  const AppUploadButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.hint,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? hint;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      AppDashedButton(
        label: label,
        icon: Icons.upload_outlined,
        onPressed: onPressed,
      ),
      if (hint case final hint?) ...[
        const SizedBox(height: AppSpacing.xs),
        Text(
          hint,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(
            color: context.colors.textMuted,
          ),
        ),
      ],
    ],
  );
}

/// Photos taken for a record (design system, section 14): thumbnails in
/// three columns, a × to remove each one while it can still be removed
/// (before syncing), and the "Capturar" tile at the end. A `null` photo
/// shows a placeholder.
class AppPhotoGrid extends StatelessWidget {
  const AppPhotoGrid({
    super.key,
    required this.photos,
    required this.onCapture,
    this.onRemove,
  });

  final List<ImageProvider?> photos;
  final VoidCallback? onCapture;

  /// `null` once the record is done: the photos are then permanent.
  final ValueChanged<int>? onRemove;

  static const _columns = 3;
  static const _aspect = 1.2;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tiles = <Widget>[
      for (final (i, photo) in photos.indexed)
        Stack(
          fit: StackFit.expand,
          children: [
            Semantics(
              container: true,
              image: true,
              label: CommonStrings.photo(i + 1),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: c.sunken,
                  borderRadius: AppRadius.brMd,
                  image: photo == null
                      ? null
                      : DecorationImage(image: photo, fit: BoxFit.cover),
                ),
                child: photo == null
                    ? Icon(Icons.image_outlined, color: c.textDisabled)
                    : null,
              ),
            ),
            if (onRemove case final remove?)
              Positioned(
                top: 0,
                right: 0,
                child: Semantics(
                  container: true,
                  button: true,
                  label: CommonStrings.removePhoto(i + 1),
                  child: ExcludeSemantics(
                    child: InkResponse(
                      onTap: () => remove(i),
                      radius: AppSizes.minTouchTarget / 2,
                      child: SizedBox.square(
                        dimension: AppSizes.minTouchTarget,
                        child: Center(
                          child: Container(
                            width: AppSizes.avatarSm,
                            height: AppSizes.avatarSm,
                            decoration: BoxDecoration(
                              color: c.textPrimary.withValues(alpha: .7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: AppSizes.iconInline,
                              color: c.card,
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
      _CaptureTile(onCapture: onCapture),
    ];
    return GridView.count(
      crossAxisCount: _columns,
      childAspectRatio: _aspect,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: tiles,
    );
  }
}

class _CaptureTile extends StatelessWidget {
  const _CaptureTile({required this.onCapture});

  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.card,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brMd,
        side: BorderSide(color: c.borderStrong),
      ),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
          borderRadius: AppRadius.brMd,
        ),
        onTap: onCapture,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              size: AppSizes.iconTopBar,
              color: c.primary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              CommonStrings.capture,
              style: AppTypography.captionBold.copyWith(color: c.primary),
            ),
          ],
        ),
      ),
    );
  }
}
