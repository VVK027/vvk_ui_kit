import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/loading/ui_shimmer.dart';

/// A rounded shimmer placeholder for loading skeletons.
class UISkeletonPlaceholder extends StatelessWidget {
  const UISkeletonPlaceholder({
    super.key,
    this.width,
    this.height,
    this.color,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
  });

  final double? width;
  final double? height;
  final Color? color;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  UISkeletonPlaceholder copyWith({
    Key? key,
    double? width,
    double? height,
    Color? color,
    double? borderRadius,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return UISkeletonPlaceholder(
      key: key ?? this.key,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      borderRadius: borderRadius ?? this.borderRadius,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: UIShimmer.fromColors(
        baseColor: baseColor ?? color ?? Colors.grey.shade300,
        highlightColor: highlightColor ?? Colors.grey.shade100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(width: width, height: height, color: Colors.white),
        ),
      ),
    );
  }
}
