import 'package:flutter/material.dart';

/// Sort order applied when painting [UISegmentedBar] segments.
enum UISegmentOrder { ascending, descending, none }

/// One proportional segment in a [UISegmentedBar].
class UISegmentValue {
  const UISegmentValue({required this.size, required this.color});

  final double size;
  final Color color;

  UISegmentValue copyWith({double? size, Color? color}) {
    return UISegmentValue(size: size ?? this.size, color: color ?? this.color);
  }
}

/// Segmented horizontal bar for proportional data (e.g. sleep stages).
class UISegmentedBar extends StatelessWidget {
  const UISegmentedBar({
    super.key,
    required this.width,
    this.height = 8,
    required this.radius,
    required this.segments,
    required this.segmentLimit,
    required this.order,
    this.background = Colors.grey,
  });

  final double width;
  final double height;
  final double radius;
  final List<UISegmentValue> segments;
  final double segmentLimit;
  final UISegmentOrder order;
  final Color background;

  UISegmentedBar copyWith({
    Key? key,
    double? width,
    double? height,
    double? radius,
    List<UISegmentValue>? segments,
    double? segmentLimit,
    UISegmentOrder? order,
    Color? background,
  }) {
    return UISegmentedBar(
      key: key ?? this.key,
      width: width ?? this.width,
      height: height ?? this.height,
      radius: radius ?? this.radius,
      segments: segments ?? this.segments,
      segmentLimit: segmentLimit ?? this.segmentLimit,
      order: order ?? this.order,
      background: background ?? this.background,
    );
  }

  double _valuesSum(List<UISegmentValue> values) {
    var sum = 0.0;
    for (final segment in values) {
      sum += segment.size;
    }
    return sum;
  }

  List<UISegmentValue> _orderedSegments() {
    final ordered = List<UISegmentValue>.from(segments);
    switch (order) {
      case UISegmentOrder.ascending:
        ordered.sort((a, b) => a.size.compareTo(b.size));
      case UISegmentOrder.descending:
        ordered.sort((a, b) => b.size.compareTo(a.size));
      case UISegmentOrder.none:
        break;
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    final ordered = _orderedSegments();
    final valuesSum = _valuesSum(ordered);
    if (valuesSum <= 0) {
      final rad = radius > 0 ? radius : (height / 2);
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.all(Radius.circular(rad)),
        ),
        width: width,
        height: height,
      );
    }
    final renderLimit = valuesSum > segmentLimit ? valuesSum : segmentLimit;
    final rad = radius > 0 ? radius : (height / 2);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.all(Radius.circular(rad)),
      ),
      width: width,
      height: height,
      child: Row(
        children: [
          for (final segment in ordered)
            SizedBox(
              width: (segment.size * width) / renderLimit,
              height: height,
              child: ColoredBox(color: segment.color),
            ),
        ],
      ),
    );
  }
}
