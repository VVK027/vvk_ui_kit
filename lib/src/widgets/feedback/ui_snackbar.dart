import 'dart:async';

import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Message category for [UISnackbar].
enum UISnackbarType { success, error }

/// Visual styling for [UISnackbar].
class UISnackbarStyle {
  const UISnackbarStyle({
    required this.backgroundColor,
    required this.textStyle,
    required this.successColor,
    required this.errorColor,
    required this.closeIconColor,
  });

  final Color backgroundColor;
  final TextStyle textStyle;
  final Color successColor;
  final Color errorColor;
  final Color closeIconColor;

  /// Builds a theme-driven style from the ambient [Theme], keeping [UISnackbar]
  /// consistent with the kit's theme-first factory convention. Any parameter
  /// overrides the resolved theme value.
  factory UISnackbarStyle.fromTheme(
    BuildContext context, {
    Color? backgroundColor,
    TextStyle? textStyle,
    Color? successColor,
    Color? errorColor,
    Color? closeIconColor,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return UISnackbarStyle(
      backgroundColor: backgroundColor ?? scheme.surface,
      textStyle:
          textStyle ??
          theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface) ??
          TextStyle(color: scheme.onSurface),
      successColor: successColor ?? scheme.primary,
      errorColor: errorColor ?? scheme.error,
      closeIconColor: closeIconColor ?? scheme.onSurface,
    );
  }

  UISnackbarStyle copyWith({
    Color? backgroundColor,
    TextStyle? textStyle,
    Color? successColor,
    Color? errorColor,
    Color? closeIconColor,
  }) {
    return UISnackbarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      closeIconColor: closeIconColor ?? this.closeIconColor,
    );
  }
}

/// A transient overlay snackbar with success and error variants.
class UISnackbar {
  static OverlayEntry? _entry;
  static Future<void> Function()? _dismiss;

  static void show({
    required BuildContext context,
    required String message,
    required UISnackbarStyle style,
    UISnackbarType type = UISnackbarType.success,
    Widget? leadingIcon,
    Widget? closeIcon,
    Duration duration = const Duration(seconds: 4),
  }) {
    _entry?.remove();
    _entry = null;
    _dismiss = null;

    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (overlayContext) => _UISnackbarOverlay(
        message: message,
        style: style,
        type: type,
        leadingIcon: leadingIcon,
        closeIcon: closeIcon,
        duration: duration,
        onRegisterDismiss: (dismiss) => _dismiss = dismiss,
        onRemoved: () {
          entry.remove();
          if (_entry == entry) {
            _entry = null;
          }
          _dismiss = null;
        },
      ),
    );

    _entry = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    final dismiss = _dismiss;
    if (dismiss != null) {
      dismiss();
    }
  }
}

class _UISnackbarOverlay extends StatefulWidget {
  const _UISnackbarOverlay({
    required this.message,
    required this.style,
    required this.type,
    required this.onRegisterDismiss,
    required this.onRemoved,
    this.leadingIcon,
    this.closeIcon,
    this.duration = const Duration(seconds: 4),
  });

  final String message;
  final UISnackbarStyle style;
  final UISnackbarType type;
  final Widget? leadingIcon;
  final Widget? closeIcon;
  final Duration duration;
  final void Function(Future<void> Function() dismiss) onRegisterDismiss;
  final VoidCallback onRemoved;

  @override
  State<_UISnackbarOverlay> createState() => _UISnackbarOverlayState();
}

class _UISnackbarOverlayState extends State<_UISnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  Timer? _timer;
  var _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    widget.onRegisterDismiss(_animateOut);
    _controller.forward();
    _timer = Timer(widget.duration, _animateOut);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateOut() async {
    if (_isDismissing) return;
    _isDismissing = true;
    _timer?.cancel();

    if (mounted) {
      await _controller.reverse();
    }

    widget.onRemoved();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.type == UISnackbarType.success
        ? widget.style.successColor
        : widget.style.errorColor;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Material(
              color: Colors.transparent,
              child: Semantics(
                liveRegion: true,
                container: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: widget.style.backgroundColor,
                    border: Border.all(color: color, width: 1.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      if (widget.leadingIcon != null) ...[
                        widget.leadingIcon!,
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: UIText(
                          widget.message,
                          style: widget.style.textStyle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _animateOut,
                        child:
                            widget.closeIcon ??
                            Icon(
                              Icons.close,
                              color: widget.style.closeIconColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
