import 'package:flutter/material.dart';

import 'ui_rating_widget.dart';

typedef UIRatingItemBuilder = Widget Function(BuildContext context, int index);

/// Paints one rating item for [rating] at [index].
Widget buildUIRatingItem({
  required int index,
  required double rating,
  required bool allowHalfRating,
  required UIRatingWidget ratingWidget,
}) {
  final itemValue = rating - index;

  if (itemValue >= 1) {
    return ratingWidget.full;
  }
  if (itemValue <= 0) {
    return ratingWidget.empty;
  }
  if (allowHalfRating && (itemValue - 0.5).abs() < 0.001) {
    return ratingWidget.half;
  }

  return Stack(
    alignment: Alignment.centerLeft,
    children: [
      ratingWidget.empty,
      ClipRect(
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: itemValue.clamp(0.0, 1.0),
          child: ratingWidget.full,
        ),
      ),
    ],
  );
}

/// Lays out rating items in a row or column.
class UIRatingLayout extends StatelessWidget {
  const UIRatingLayout({
    super.key,
    required this.rating,
    required this.itemCount,
    required this.direction,
    required this.itemPadding,
    required this.allowHalfRating,
    required this.ratingWidget,
    this.itemBuilder,
    this.wrapItem,
  });

  final double rating;
  final int itemCount;
  final Axis direction;
  final EdgeInsetsGeometry itemPadding;
  final bool allowHalfRating;
  final UIRatingWidget ratingWidget;
  final UIRatingItemBuilder? itemBuilder;
  final Widget Function(int index, Widget child)? wrapItem;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (var index = 0; index < itemCount; index++) {
      Widget item;
      if (itemBuilder != null) {
        final base = itemBuilder!(context, index);
        item = _applyFractionToCustomItem(
          index: index,
          rating: rating,
          allowHalfRating: allowHalfRating,
          child: base,
        );
      } else {
        item = buildUIRatingItem(
          index: index,
          rating: rating,
          allowHalfRating: allowHalfRating,
          ratingWidget: ratingWidget,
        );
      }

      if (wrapItem != null) {
        item = wrapItem!(index, item);
      }

      children.add(Padding(padding: itemPadding, child: item));
    }

    return Flex(
      direction: direction,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _applyFractionToCustomItem({
    required int index,
    required double rating,
    required bool allowHalfRating,
    required Widget child,
  }) {
    final itemValue = rating - index;
    if (itemValue >= 1 || itemValue <= 0) {
      return child;
    }
    if (allowHalfRating && (itemValue - 0.5).abs() < 0.001) {
      return child;
    }

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Opacity(opacity: 0.35, child: child),
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: itemValue.clamp(0.0, 1.0),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Snaps [value] to half or whole steps when [allowHalfRating] is enabled.
double snapUIRating(double value, {required bool allowHalfRating}) {
  if (allowHalfRating) {
    return (value * 2).roundToDouble() / 2;
  }
  return value.ceilToDouble();
}

/// Clamps [rating] between [minRating] and [maxRating].
double clampUIRating(
  double rating, {
  required double minRating,
  required double maxRating,
}) {
  return rating.clamp(minRating, maxRating).toDouble();
}
