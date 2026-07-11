import 'package:flutter/material.dart';

/// Global overlay entry handle for managing active overlays.
class UIOverlayEntry {
  UIOverlayEntry(this._entry);
  final OverlayEntry _entry;

  void remove() {
    _entry.remove();
  }
}

/// Helper for showing non-blocking global overlays (toasts, custom banners).
class UIOverlayUtil {
  UIOverlayUtil._();

  /// Shows a custom widget as a global overlay.
  /// 
  /// Returns a [UIOverlayEntry] that can be used to remove the overlay.
  static UIOverlayEntry show(
    BuildContext context,
    Widget child, {
    Duration? duration,
    Alignment alignment = Alignment.topCenter,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => SafeArea(
        child: Align(
          alignment: alignment,
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );

    overlay.insert(entry);
    
    final handle = UIOverlayEntry(entry);

    if (duration != null) {
      Future.delayed(duration, () {
        handle.remove();
      });
    }

    return handle;
  }
}
