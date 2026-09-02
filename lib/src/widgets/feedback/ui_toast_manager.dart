import 'dart:async';

import 'package:flutter/material.dart';

/// Where toasts are positioned on screen.
enum UIToastPosition { top, bottom }

/// Toast notification manager for queued, auto-dismissing floating messages.
class UIToastManager {
  UIToastManager._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  /// Shows a floating toast message on screen.
  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration duration = const Duration(seconds: 3),
    UIToastPosition position = UIToastPosition.bottom,
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    dismiss();

    final overlay = Overlay.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bg = backgroundColor ?? colorScheme.inverseSurface;
    final fg = foregroundColor ?? colorScheme.onInverseSurface;

    _currentEntry = OverlayEntry(
      builder: (context) {
        final alignment = position == UIToastPosition.top
            ? Alignment.topCenter
            : Alignment.bottomCenter;

        return SafeArea(
          child: Align(
            alignment: alignment,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: fg, size: 20),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: Text(
                            message,
                            style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (actionLabel != null && onAction != null) ...[
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () {
                              dismiss();
                              onAction();
                            },
                            child: Text(
                              actionLabel,
                              style: TextStyle(color: colorScheme.inversePrimary, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_currentEntry!);
    _dismissTimer = Timer(duration, dismiss);
  }

  /// Dismisses the currently displayed toast.
  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
