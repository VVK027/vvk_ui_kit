import 'package:flutter/material.dart';

/// Paging carousel with animated dot indicators.
class UICarouselWithIndicator extends StatefulWidget {
  final int itemCount;
  final double? height;
  final Widget Function(BuildContext, int, int) builder;
  final ValueChanged<int>? onPageChange;
  final int initialIndex;
  final double viewPortion;
  final double indicatorWidth;
  final double selectedIndicatorWidth;
  final double indicatorHeight;
  final Color selectedIndicatorColor;
  final Color unSelectedIndicatorColor;
  final double? indicatorRadius;
  final bool infiniteScroll;
  final bool autoScroll;
  final PageController? carouselController;
  final Color? indicatorBackgroundColor;
  final double itemCountHeight;
  final EdgeInsetsGeometry? indicatorMargin;
  final EdgeInsetsGeometry? indicatorPadding;

  const UICarouselWithIndicator({
    super.key,
    required this.itemCount,
    this.height,
    required this.builder,
    this.initialIndex = 0,
    this.viewPortion = 1,
    this.indicatorWidth = 5,
    this.selectedIndicatorWidth = 20,
    this.indicatorHeight = 5,
    required this.selectedIndicatorColor,
    required this.unSelectedIndicatorColor,
    this.infiniteScroll = false,
    this.indicatorRadius,
    this.onPageChange,
    this.autoScroll = false,
    this.carouselController,
    this.indicatorBackgroundColor,
    this.itemCountHeight = 10,
    this.indicatorMargin = const EdgeInsets.only(left: 20, right: 20),
    this.indicatorPadding = EdgeInsets.zero,
  });

  UICarouselWithIndicator copyWith({
    Key? key,
    int? itemCount,
    double? height,
    Widget Function(BuildContext, int, int)? builder,
    ValueChanged<int>? onPageChange,
    int? initialIndex,
    double? viewPortion,
    double? indicatorWidth,
    double? selectedIndicatorWidth,
    double? indicatorHeight,
    Color? selectedIndicatorColor,
    Color? unSelectedIndicatorColor,
    double? indicatorRadius,
    bool? infiniteScroll,
    bool? autoScroll,
    PageController? carouselController,
    Color? indicatorBackgroundColor,
    double? itemCountHeight,
    EdgeInsetsGeometry? indicatorMargin,
    EdgeInsetsGeometry? indicatorPadding,
  }) {
    return UICarouselWithIndicator(
      key: key ?? this.key,
      itemCount: itemCount ?? this.itemCount,
      height: height ?? this.height,
      builder: builder ?? this.builder,
      onPageChange: onPageChange ?? this.onPageChange,
      initialIndex: initialIndex ?? this.initialIndex,
      viewPortion: viewPortion ?? this.viewPortion,
      indicatorWidth: indicatorWidth ?? this.indicatorWidth,
      selectedIndicatorWidth:
          selectedIndicatorWidth ?? this.selectedIndicatorWidth,
      indicatorHeight: indicatorHeight ?? this.indicatorHeight,
      selectedIndicatorColor:
          selectedIndicatorColor ?? this.selectedIndicatorColor,
      unSelectedIndicatorColor:
          unSelectedIndicatorColor ?? this.unSelectedIndicatorColor,
      indicatorRadius: indicatorRadius ?? this.indicatorRadius,
      infiniteScroll: infiniteScroll ?? this.infiniteScroll,
      autoScroll: autoScroll ?? this.autoScroll,
      carouselController: carouselController ?? this.carouselController,
      indicatorBackgroundColor:
          indicatorBackgroundColor ?? this.indicatorBackgroundColor,
      itemCountHeight: itemCountHeight ?? this.itemCountHeight,
      indicatorMargin: indicatorMargin ?? this.indicatorMargin,
      indicatorPadding: indicatorPadding ?? this.indicatorPadding,
    );
  }

  @override
  State<UICarouselWithIndicator> createState() =>
      _UICarouselWithIndicatorState();
}

class _UICarouselWithIndicatorState extends State<UICarouselWithIndicator> {
  late final PageController _controller;
  late int _selectedPage;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.initialIndex;
    if (widget.carouselController != null) {
      _controller = widget.carouselController!;
    } else {
      _ownsController = true;
      _controller = PageController(
        initialPage: widget.initialIndex,
        viewportFraction: widget.viewPortion,
      );
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.itemCount,
              onPageChanged: (index) {
                setState(() => _selectedPage = index);
                widget.onPageChange?.call(index);
              },
              itemBuilder: (context, index) =>
                  widget.builder(context, index, index),
            ),
          ),
        ),
        SizedBox(height: widget.itemCount > 1 ? widget.itemCountHeight : 0),
        if (widget.itemCount > 1)
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            color: widget.indicatorBackgroundColor,
            margin: widget.indicatorMargin,
            padding: widget.indicatorPadding,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < widget.itemCount; i++)
                    Container(
                      width: _selectedPage == i
                          ? widget.selectedIndicatorWidth
                          : widget.indicatorWidth,
                      height: widget.indicatorHeight,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: _selectedPage == i
                            ? widget.selectedIndicatorColor
                            : widget.unSelectedIndicatorColor,
                        borderRadius: BorderRadius.circular(
                          widget.indicatorRadius ??
                              (widget.indicatorHeight / 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
