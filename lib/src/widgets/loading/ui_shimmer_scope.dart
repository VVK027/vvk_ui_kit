import 'package:flutter/material.dart';

/// Inherited scope that propagates global loading state down the widget tree
/// for automated skeleton shimmer placeholders.
class UIShimmerScope extends InheritedWidget {
  const UIShimmerScope({
    super.key,
    required this.isLoading,
    required super.child,
    this.baseColor,
    this.highlightColor,
  });

  /// Whether the enclosed subtree is in a shimmer loading state.
  final bool isLoading;

  /// Custom base shimmer color.
  final Color? baseColor;

  /// Custom highlight shimmer color.
  final Color? highlightColor;

  /// Returns the nearest [UIShimmerScope] or null if none exists.
  static UIShimmerScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UIShimmerScope>();
  }

  /// Returns whether the ambient scope is currently in a loading state.
  static bool isLoadingOf(BuildContext context) {
    return maybeOf(context)?.isLoading ?? false;
  }

  @override
  bool updateShouldNotify(UIShimmerScope oldWidget) {
    return isLoading != oldWidget.isLoading ||
        baseColor != oldWidget.baseColor ||
        highlightColor != oldWidget.highlightColor;
  }
}
