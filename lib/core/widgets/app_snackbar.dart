import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../constants/strings/common_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';
import '../theme/theme_context.dart';

/// Transient, non-blocking feedback (design system, section 29): a title,
/// an optional description and an optional action, in four tones.
///
/// Toasts show at the top, below the top bar, so they never cover the
/// bottom navigation. At most [maxVisible] are on screen; the newest enters
/// on top and pushes out the oldest. They leave after
/// [AppDurations.toastVisible], except errors, which stay until dismissed
/// and therefore always carry an action ([CommonStrings.close] by default).
/// Any toast can also be swiped away.
///
/// Every toast is a live region, so a screen reader announces it as soon as
/// it appears (the design system's `role=status` / `role=alert`).
abstract final class AppSnackbar {
  static const int maxVisible = 2;

  static void success(
    BuildContext context,
    String title, {
    String? description,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    _Toast(_ToastKind.success, title, description, actionLabel, onAction),
  );

  static void error(
    BuildContext context,
    String title, {
    String? description,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    _Toast(
      _ToastKind.error,
      title,
      description,
      actionLabel ?? CommonStrings.close,
      onAction,
    ),
  );

  static void warning(
    BuildContext context,
    String title, {
    String? description,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    _Toast(_ToastKind.warning, title, description, actionLabel, onAction),
  );

  static void info(
    BuildContext context,
    String title, {
    String? description,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    _Toast(_ToastKind.info, title, description, actionLabel, onAction),
  );

  /// Neutral feedback with an action, on the plain surface — "Item
  /// arquivado · Desfazer" (design system, section 17). No tone icon.
  static void neutral(
    BuildContext context,
    String title, {
    String? description,
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    _Toast(_ToastKind.neutral, title, description, actionLabel, onAction),
  );

  /// A failure the user can retry, on the dark [AppColors.inverse] surface
  /// that stands out in both themes — "Não foi possível salvar · Tentar
  /// novamente" (design system, section 35). Like an error it stays until
  /// dismissed or retried.
  static void failure(
    BuildContext context,
    String title, {
    required VoidCallback onRetry,
    String? description,
    String actionLabel = CommonStrings.retry,
  }) => _show(
    context,
    _Toast(_ToastKind.failure, title, description, actionLabel, onRetry),
  );

  /// Visible toasts, newest first.
  static final List<_Toast> _toasts = [];
  static OverlayEntry? _entry;
  static OverlayState? _overlay;

  static void _show(BuildContext context, _Toast toast) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (!identical(overlay, _overlay)) {
      // A different app (or a rebuilt one, as between tests): whatever was
      // tracked belongs to an overlay that is gone.
      _toasts.clear();
      _entry = null;
      _overlay = overlay;
    }
    _toasts.insert(0, toast);
    if (_toasts.length > maxVisible) {
      _toasts.removeRange(maxVisible, _toasts.length);
    }
    final entry = _entry;
    if (entry == null) {
      overlay.insert(
        _entry = OverlayEntry(builder: (_) => _ToastStack(List.of(_toasts))),
      );
    } else {
      entry.markNeedsBuild();
    }
  }

  static void _dismiss(_Toast toast) {
    if (!_toasts.remove(toast)) return;
    final entry = _entry;
    if (entry == null) return;
    if (_toasts.isEmpty) {
      _entry = null;
      if (entry.mounted) entry.remove();
    } else {
      entry.markNeedsBuild();
    }
  }
}

enum _ToastKind { success, warning, error, info, neutral, failure }

final class _Toast {
  _Toast(
    this.kind,
    this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  );

  final _ToastKind kind;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;
}

class _ToastStack extends StatelessWidget {
  const _ToastStack(this.toasts);

  final List<_Toast> toasts;

  @override
  Widget build(BuildContext context) => Positioned(
    top: MediaQuery.paddingOf(context).top + kToolbarHeight + AppSpacing.sm,
    left: AppSpacing.xl,
    right: AppSpacing.xl,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppSizes.toastMaxWidth),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final toast in toasts)
                Padding(
                  key: ObjectKey(toast),
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _ToastView(toast),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// One toast. Owns its own timer, so the timer dies with the widget — when
/// the toast is dismissed, pushed out of the stack or the app goes away.
class _ToastView extends StatefulWidget {
  const _ToastView(this.toast);

  final _Toast toast;

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Errors and failures wait for the user.
    if (widget.toast.kind case _ToastKind.error || _ToastKind.failure) return;
    _timer = Timer(AppDurations.toastVisible, _dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _dismiss() => AppSnackbar._dismiss(widget.toast);

  void _act() {
    _dismiss();
    widget.toast.onAction?.call();
  }

  @override
  Widget build(BuildContext context) {
    final toast = widget.toast;
    final c = context.colors;
    final fg = _foreground(c, toast.kind);
    final failure = toast.kind == _ToastKind.failure;
    final text = failure ? c.onInverse : c.textPrimary;
    final detail = failure ? c.onInverse : c.textMuted;
    final action = toast.actionLabel;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppDurations.toast,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, -AppSpacing.sm * (1 - t)),
          child: child,
        ),
      ),
      child: Dismissible(
        key: ObjectKey(toast),
        onDismissed: (_) => _dismiss(),
        child: Semantics(
          container: true,
          liveRegion: true,
          child: Material(
            color: _background(c, toast.kind),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.brMdPlus,
              side: BorderSide(
                color: switch (toast.kind) {
                  _ToastKind.neutral => c.border,
                  _ToastKind.failure => c.inverse,
                  _ => fg,
                },
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
              ),
              child: Row(
                children: [
                  if (failure) ...[
                    Icon(
                      Icons.info_outline,
                      size: AppSizes.iconTopBar,
                      color: c.onInverse,
                    ),
                    SizedBox(width: AppSpacing.md),
                  ] else if (_icon(toast.kind) case final icon?) ...[
                    Container(
                      width: AppSizes.toastIcon,
                      height: AppSizes.toastIcon,
                      decoration: BoxDecoration(
                        color: fg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: AppSizes.iconChip,
                        // The card colour: white on light, near-black on dark.
                        color: c.card,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          toast.title,
                          style: AppTypography.label.copyWith(color: text),
                        ),
                        if (toast.description case final description?) ...[
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            description,
                            style: AppTypography.bodySmall.copyWith(
                              color: detail,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (action != null)
                    InkWell(
                      onTap: _act,
                      borderRadius: AppRadius.brSm,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: AppSizes.minTouchTarget,
                          minHeight: AppSizes.minTouchTarget,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              action,
                              style: AppTypography.label.copyWith(color: fg),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(width: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Border, icon and action colour. Info uses the brand colour, as in the
  /// design system's toast.
  static Color _foreground(AppColors c, _ToastKind kind) => switch (kind) {
    _ToastKind.success => c.success,
    _ToastKind.warning => c.alertText,
    _ToastKind.error => c.danger,
    _ToastKind.info => c.primary,
    _ToastKind.neutral => c.link,
    _ToastKind.failure => c.inverseLink,
  };

  static Color _background(AppColors c, _ToastKind kind) => switch (kind) {
    _ToastKind.success => c.successSubtle,
    _ToastKind.warning => c.alertSubtle,
    _ToastKind.error => c.dangerSubtle,
    _ToastKind.info => c.primarySubtle,
    _ToastKind.neutral => c.raised,
    _ToastKind.failure => c.inverse,
  };

  static IconData? _icon(_ToastKind kind) => switch (kind) {
    _ToastKind.success => Icons.check,
    _ToastKind.warning => Icons.priority_high,
    _ToastKind.error => Icons.close,
    _ToastKind.info => Icons.info_outline,
    _ToastKind.neutral || _ToastKind.failure => null,
  };
}
