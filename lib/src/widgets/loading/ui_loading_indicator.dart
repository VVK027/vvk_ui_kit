import 'package:flutter/material.dart';

/// Circular loading indicator.
///
/// Use the default constructor for a sized, optionally centered spinner.
/// Use [UILoadingIndicator.compact] for a bare [CircularProgressIndicator].
class UILoadingIndicator extends StatelessWidget {
  const UILoadingIndicator({
    super.key,
    this.size = 28,
    this.strokeWidth = 2.6,
    this.color,
    this.centered = true,
  }) : _compact = false;

  const UILoadingIndicator.compact({
    super.key,
    this.color,
    this.strokeWidth = 2.6,
  }) : size = null,
       centered = false,
       _compact = true;

  final double? size;
  final double strokeWidth;
  final Color? color;
  final bool centered;
  final bool _compact;

  UILoadingIndicator copyWith({
    Key? key,
    double? size,
    double? strokeWidth,
    Color? color,
    bool? centered,
    bool? compact,
  }) {
    final isCompact = compact ?? _compact;
    if (isCompact) {
      return UILoadingIndicator.compact(
        key: key ?? this.key,
        color: color ?? this.color,
        strokeWidth: strokeWidth ?? this.strokeWidth,
      );
    }
    return UILoadingIndicator(
      key: key ?? this.key,
      size: size ?? this.size,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      centered: centered ?? this.centered,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_compact) {
      return CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? Theme.of(context).colorScheme.primary,
      );
    }

    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: color == null
            ? null
            : AlwaysStoppedAnimation<Color>(color!),
      ),
    );

    return centered ? Center(child: indicator) : indicator;
  }
}
