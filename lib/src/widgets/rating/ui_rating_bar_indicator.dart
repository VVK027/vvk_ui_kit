import 'package:flutter/material.dart';

import 'ui_rating_layout.dart';
import 'ui_rating_widget.dart';

/// Read-only rating display that supports fractional values.
///
/// Use [UIRatingBarIndicator.builder] when each item should be built individually.
class UIRatingBarIndicator extends StatelessWidget {
  /// Creates a [UIRatingBarIndicator] with a fixed [ratingWidget] for every item.
  const UIRatingBarIndicator({
    super.key,
    required this.rating,
    this.ratingWidget,
    this.itemCount = 5,
    this.direction = Axis.horizontal,
    this.allowHalfRating = true,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 24,
    this.filledColor,
    this.emptyColor,
  }) : itemBuilder = null;

  /// Creates a [UIRatingBarIndicator] with a per-index [itemBuilder].
  const UIRatingBarIndicator.builder({
    super.key,
    required this.rating,
    required this.itemBuilder,
    this.itemCount = 5,
    this.direction = Axis.horizontal,
    this.allowHalfRating = true,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 24,
    this.filledColor,
    this.emptyColor,
  }) : ratingWidget = null;

  /// Rating value to display.
  final double rating;

  /// Number of rating items.
  final int itemCount;

  /// Layout direction of the rating items.
  final Axis direction;

  /// Whether half-step display is enabled.
  final bool allowHalfRating;

  /// Padding around each item.
  final EdgeInsetsGeometry itemPadding;

  /// Default icon size when using the built-in star widget.
  final double itemSize;

  /// Color for filled stars when using the built-in star widget.
  final Color? filledColor;

  /// Color for empty stars when using the built-in star widget.
  final Color? emptyColor;

  /// Fixed full/half/empty widgets for every item.
  final UIRatingWidget? ratingWidget;

  /// Builds each rating item; supports per-index customization.
  final UIRatingItemBuilder? itemBuilder;

  UIRatingBarIndicator copyWith({
    Key? key,
    double? rating,
    UIRatingWidget? ratingWidget,
    UIRatingItemBuilder? itemBuilder,
    int? itemCount,
    Axis? direction,
    bool? allowHalfRating,
    EdgeInsetsGeometry? itemPadding,
    double? itemSize,
    Color? filledColor,
    Color? emptyColor,
  }) {
    if (itemBuilder != null) {
      return UIRatingBarIndicator.builder(
        key: key ?? this.key,
        rating: rating ?? this.rating,
        itemBuilder: itemBuilder,
        itemCount: itemCount ?? this.itemCount,
        direction: direction ?? this.direction,
        allowHalfRating: allowHalfRating ?? this.allowHalfRating,
        itemPadding: itemPadding ?? this.itemPadding,
        itemSize: itemSize ?? this.itemSize,
        filledColor: filledColor ?? this.filledColor,
        emptyColor: emptyColor ?? this.emptyColor,
      );
    }

    return UIRatingBarIndicator(
      key: key ?? this.key,
      rating: rating ?? this.rating,
      ratingWidget: ratingWidget ?? this.ratingWidget,
      itemCount: itemCount ?? this.itemCount,
      direction: direction ?? this.direction,
      allowHalfRating: allowHalfRating ?? this.allowHalfRating,
      itemPadding: itemPadding ?? this.itemPadding,
      itemSize: itemSize ?? this.itemSize,
      filledColor: filledColor ?? this.filledColor,
      emptyColor: emptyColor ?? this.emptyColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedWidget =
        ratingWidget ??
        defaultUIRatingWidget(
          context,
          size: itemSize,
          filledColor: filledColor,
          emptyColor: emptyColor,
        );

    final clamped = clampUIRating(
      rating,
      minRating: 0,
      maxRating: itemCount.toDouble(),
    );

    return Semantics(
      label: 'Rating',
      value: '$clamped out of $itemCount',
      readOnly: true,
      child: UIRatingLayout(
        rating: clamped,
        itemCount: itemCount,
        direction: direction,
        itemPadding: itemPadding,
        allowHalfRating: allowHalfRating,
        ratingWidget: resolvedWidget,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
