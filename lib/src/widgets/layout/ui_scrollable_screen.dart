import 'package:flutter/material.dart';

/// Scroll layout mode for [UIScrollableScreen].
enum UIScrollableType { singleChild, custom }

/// Screen wrapper with configurable scroll behavior and safe-area padding.
class UIScrollableScreen extends StatefulWidget {
  const UIScrollableScreen({
    super.key,
    this.type = UIScrollableType.singleChild,
    this.child,
    this.slivers,
    this.scrollController,
    this.physics,
    this.withRefresh = false,
    this.onRefresh,
    this.onScrollControllerReady,
  }) : assert(
         !withRefresh || onRefresh != null,
         'onRefresh must be provided when withRefresh is true',
       );

  final UIScrollableType type;
  final Widget? child;
  final List<Widget>? slivers;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool withRefresh;
  final Future<void> Function()? onRefresh;
  final void Function(ScrollController controller)? onScrollControllerReady;

  UIScrollableScreen copyWith({
    Key? key,
    UIScrollableType? type,
    Widget? child,
    List<Widget>? slivers,
    ScrollController? scrollController,
    ScrollPhysics? physics,
    bool? withRefresh,
    Future<void> Function()? onRefresh,
    void Function(ScrollController controller)? onScrollControllerReady,
  }) {
    return UIScrollableScreen(
      key: key ?? this.key,
      type: type ?? this.type,
      slivers: slivers ?? this.slivers,
      scrollController: scrollController ?? this.scrollController,
      physics: physics ?? this.physics,
      withRefresh: withRefresh ?? this.withRefresh,
      onRefresh: onRefresh ?? this.onRefresh,
      onScrollControllerReady:
          onScrollControllerReady ?? this.onScrollControllerReady,
      child: child ?? this.child,
    );
  }

  @override
  State<UIScrollableScreen> createState() => _UIScrollableScreenState();
}

class _UIScrollableScreenState extends State<UIScrollableScreen> {
  late final ScrollController _internalController;
  late final bool _isExternalController;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.scrollController != null;
    _internalController = widget.scrollController ?? ScrollController();
    widget.onScrollControllerReady?.call(_internalController);
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = widget.type == UIScrollableType.singleChild
        ? SingleChildScrollView(
            controller: _internalController,
            physics: widget.physics ?? const ClampingScrollPhysics(),
            child: widget.child ?? const SizedBox(),
          )
        : CustomScrollView(
            controller: _internalController,
            physics: widget.physics ?? const ClampingScrollPhysics(),
            slivers:
                widget.slivers ??
                [SliverToBoxAdapter(child: widget.child ?? const SizedBox())],
          );

    if (widget.withRefresh) {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: scrollView);
    }

    return scrollView;
  }
}
