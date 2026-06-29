import 'package:flutter/material.dart';

import 'ui_rating_layout.dart';
import 'ui_rating_widget.dart';

/// Interactive star (or custom) rating bar with optional half-star support.
///
/// Use [UIRatingBar.builder] when each item should be built individually.
class UIRatingBar extends StatefulWidget {
  /// Creates a [UIRatingBar] with a fixed [ratingWidget] for every item.
  const UIRatingBar({
    super.key,
    required this.initialRating,
    this.ratingWidget,
    this.onRatingUpdate,
    this.itemCount = 5,
    this.minRating = 0,
    this.direction = Axis.horizontal,
    this.allowHalfRating = true,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 24,
    this.filledColor,
    this.emptyColor,
    this.tapEnabled = true,
    this.updateOnDrag = true,
  }) : itemBuilder = null;

  /// Creates a [UIRatingBar] with a per-index [itemBuilder].
  const UIRatingBar.builder({
    super.key,
    required this.initialRating,
    required this.itemBuilder,
    this.onRatingUpdate,
    this.itemCount = 5,
    this.minRating = 0,
    this.direction = Axis.horizontal,
    this.allowHalfRating = true,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 24,
    this.filledColor,
    this.emptyColor,
    this.tapEnabled = true,
    this.updateOnDrag = true,
  }) : ratingWidget = null;

  /// Starting rating value.
  final double initialRating;

  /// Called when the user changes the rating.
  final ValueChanged<double>? onRatingUpdate;

  /// Number of rating items.
  final int itemCount;

  /// Minimum selectable rating.
  final double minRating;

  /// Layout direction of the rating items.
  final Axis direction;

  /// Whether half-step ratings are allowed.
  final bool allowHalfRating;

  /// Padding around each item.
  final EdgeInsetsGeometry itemPadding;

  /// Default icon size when using the built-in star widget.
  final double itemSize;

  /// Color for filled stars when using the built-in star widget.
  final Color? filledColor;

  /// Color for empty stars when using the built-in star widget.
  final Color? emptyColor;

  /// Whether taps update the rating.
  final bool tapEnabled;

  /// Whether dragging across items updates the rating.
  final bool updateOnDrag;

  /// Fixed full/half/empty widgets for every item.
  final UIRatingWidget? ratingWidget;

  /// Builds each rating item; supports per-index customization.
  final UIRatingItemBuilder? itemBuilder;

  @override
  State<UIRatingBar> createState() => _UIRatingBarState();
}

class _UIRatingBarState extends State<UIRatingBar> {
  late double _rating;
  final GlobalKey _barKey = GlobalKey();

  double get _maxRating => widget.itemCount.toDouble();

  @override
  void initState() {
    super.initState();
    _rating = clampUIRating(
      widget.initialRating,
      minRating: widget.minRating,
      maxRating: _maxRating,
    );
  }

  @override
  void didUpdateWidget(covariant UIRatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _rating = clampUIRating(
        widget.initialRating,
        minRating: widget.minRating,
        maxRating: _maxRating,
      );
    }
  }

  UIRatingWidget _resolveRatingWidget(BuildContext context) {
    return widget.ratingWidget ??
        defaultUIRatingWidget(
          context,
          size: widget.itemSize,
          filledColor: widget.filledColor,
          emptyColor: widget.emptyColor,
        );
  }

  void _commitRating(double next) {
    final snapped = snapUIRating(
      clampUIRating(next, minRating: widget.minRating, maxRating: _maxRating),
      allowHalfRating: widget.allowHalfRating,
    );
    if (snapped == _rating) return;
    setState(() => _rating = snapped);
    widget.onRatingUpdate?.call(snapped);
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.tapEnabled || widget.onRatingUpdate == null) return;
    final next = _ratingFromGlobalPosition(details.globalPosition);
    if (next != null) _commitRating(next);
  }

  void _handleDrag(DragUpdateDetails details) {
    if (!widget.updateOnDrag || widget.onRatingUpdate == null) return;
    final next = _ratingFromGlobalPosition(details.globalPosition);
    if (next != null) _commitRating(next);
  }

  double? _ratingFromGlobalPosition(Offset globalPosition) {
    final box = _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;

    final local = box.globalToLocal(globalPosition);
    final isHorizontal = widget.direction == Axis.horizontal;
    final extent = isHorizontal ? box.size.width : box.size.height;
    if (extent <= 0) return null;

    var position = isHorizontal ? local.dx : local.dy;
    if (isHorizontal && Directionality.of(context) == TextDirection.rtl) {
      position = extent - position;
    }

    final raw = (position / extent) * widget.itemCount;
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final ratingWidget = _resolveRatingWidget(context);
    final interactive = widget.tapEnabled && widget.onRatingUpdate != null;

    Widget bar = UIRatingLayout(
      rating: _rating,
      itemCount: widget.itemCount,
      direction: widget.direction,
      itemPadding: widget.itemPadding,
      allowHalfRating: widget.allowHalfRating,
      ratingWidget: ratingWidget,
      itemBuilder: widget.itemBuilder,
    );

    bar = Semantics(
      label: 'Rating',
      value: '$_rating out of $_maxRating',
      increasedValue: (_rating + (widget.allowHalfRating ? 0.5 : 1))
          .clamp(widget.minRating, _maxRating)
          .toString(),
      decreasedValue: (_rating - (widget.allowHalfRating ? 0.5 : 1))
          .clamp(widget.minRating, _maxRating)
          .toString(),
      onIncrease: interactive
          ? () => _commitRating(_rating + (widget.allowHalfRating ? 0.5 : 1))
          : null,
      onDecrease: interactive
          ? () => _commitRating(_rating - (widget.allowHalfRating ? 0.5 : 1))
          : null,
      child: bar,
    );

    if (!interactive) {
      return KeyedSubtree(key: _barKey, child: bar);
    }

    return GestureDetector(
      key: _barKey,
      onTapDown: _handleTapDown,
      onHorizontalDragUpdate: widget.direction == Axis.horizontal
          ? _handleDrag
          : null,
      onVerticalDragUpdate: widget.direction == Axis.vertical
          ? _handleDrag
          : null,
      behavior: HitTestBehavior.translucent,
      child: bar,
    );
  }
}
