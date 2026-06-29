import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Convenience wrappers around [AnimatedBuilder] for [Listenable] values.
extension ListenableExtension on Listenable {
  /// Rebuilds [builder] whenever this listenable notifies listeners.
  Widget builder({required TransitionBuilder builder, Widget? child}) {
    return AnimatedBuilder(animation: this, builder: builder, child: child);
  }
}

/// [AnimatedBuilder] helpers for [ValueListenable] values.
extension ValueListenableExtension<T> on ValueListenable<T> {
  /// Rebuilds from the current [value] on each notification.
  Widget listen(Widget Function(T value) builder) {
    return AnimatedBuilder(
      animation: this,
      builder: (context, child) => builder(value),
    );
  }

  /// Like [listen], but passes an optional static [child] into [builder].
  Widget listenChild({
    required Widget Function(T value, Widget? child) builder,
    Widget? child,
  }) {
    return AnimatedBuilder(
      animation: this,
      child: child,
      builder: (context, child) => builder(value, child),
    );
  }
}

/// Conditional builders for [ValueListenable<bool>].
extension BoolValueListenableExtension on ValueListenable<bool> {
  /// Builds [builder] when `true`; otherwise [onFalse] or [SizedBox.shrink].
  Widget buildWhenTrue(Widget Function() builder, {Widget? onFalse}) {
    return ValueListenableBuilder<bool>(
      valueListenable: this,
      builder: (context, value, child) {
        if (value) return builder();
        return onFalse ?? const SizedBox.shrink();
      },
    );
  }
}
