import 'package:flutter/material.dart';
import '../loading/ui_shimmer.dart';

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

  /// Quick factory for a text-like line skeleton.
  factory UISkeletonPlaceholder.line({
    double? width,
    double height = 16,
    double borderRadius = 4,
  }) => UISkeletonPlaceholder(
    width: width,
    height: height,
    borderRadius: borderRadius,
  );

  /// Quick factory for a circular skeleton (e.g. avatar).
  factory UISkeletonPlaceholder.circle({required double size}) =>
      UISkeletonPlaceholder(
        width: size,
        height: size,
        borderRadius: size / 2,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedBase =
        baseColor ??
        color ??
        (isDark ? Colors.grey.shade800 : Colors.grey.shade300);
    final resolvedHighlight =
        highlightColor ?? (isDark ? Colors.grey.shade700 : Colors.grey.shade100);

    return SizedBox(
      width: width,
      height: height,
      child: UIShimmer.fromColors(
        baseColor: resolvedBase,
        highlightColor: resolvedHighlight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(width: width, height: height, color: Colors.white),
        ),
      ),
    );
  }
}

/// A pre-built skeleton for a list of items.
class UISkeletonList extends StatelessWidget {
  const UISkeletonList({
    super.key,
    this.itemCount = 5,
    this.padding = const EdgeInsets.all(16),
  });

  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, _) => Row(
        children: [
          UISkeletonPlaceholder.circle(size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UISkeletonPlaceholder.line(width: 150),
                const SizedBox(height: 8),
                UISkeletonPlaceholder.line(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
