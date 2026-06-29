import 'package:flutter/material.dart';

import 'ui_shimmer.dart';
import 'ui_page_loading.dart';

/// The layout type for the shimmer effect.
enum UIShimmerLoadingType {
  /// Shimmer for a list view.
  list,

  /// Shimmer for a grid view.
  grid,
}

/// A container that switches between a loading shimmer and the actual content.
class UIShimmerLoadingContainer extends StatelessWidget {
  /// Creates a [UIShimmerLoadingContainer].
  const UIShimmerLoadingContainer({
    super.key,
    required this.type,
    required this.child,
    required this.isLoading,
    this.loadingView,
    this.baseColor,
    this.highlightColor,
  });

  /// The type of shimmer to display (list or grid).
  final UIShimmerLoadingType type;

  /// The actual content to display when loading is finished.
  final Widget child;

  /// Whether the loading shimmer is currently active.
  final bool isLoading;

  /// Optional custom widget to use as the shimmer skeleton.
  final Widget? loadingView;

  /// Base color of the shimmer.
  final Color? baseColor;

  /// Highlight color of the shimmer.
  final Color? highlightColor;

  UIShimmerLoadingContainer copyWith({
    Key? key,
    UIShimmerLoadingType? type,
    Widget? child,
    bool? isLoading,
    Widget? loadingView,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return UIShimmerLoadingContainer(
      key: key ?? this.key,
      type: type ?? this.type,
      isLoading: isLoading ?? this.isLoading,
      loadingView: loadingView ?? this.loadingView,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [...previousChildren, ?currentChild],
        );
      },
      duration: const Duration(milliseconds: 300),
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (!isLoading) return child;
    return UIShimmer.fromColors(
      key: ValueKey('shimmer:$type'),
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      enabled: true,
      child: _getLoadingView(),
    );
  }

  Widget _getLoadingView() {
    if (loadingView != null) return loadingView!;
    switch (type) {
      case UIShimmerLoadingType.list:
        return const UIListViewShimmerLoading();
      case UIShimmerLoadingType.grid:
        return const UIGripShimmerLoading();
    }
  }
}
