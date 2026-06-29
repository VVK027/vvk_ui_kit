import 'package:flutter/material.dart';

/// Dashed line divider along the horizontal or vertical axis.
class UIDashedDivider extends StatelessWidget {
  const UIDashedDivider({
    super.key,
    this.thickness = 1,
    this.dashLength = 6,
    this.dashSpace = 4,
    this.color,
    this.axis = Axis.horizontal,
    this.length,
  }) : assert(thickness > 0),
       assert(dashLength > 0),
       assert(dashSpace >= 0);

  /// Creates a vertical dashed divider.
  factory UIDashedDivider.vertical({
    Key? key,
    double thickness = 1,
    double dashLength = 6,
    double dashSpace = 4,
    Color? color,
    double? length,
  }) {
    return UIDashedDivider(
      key: key,
      thickness: thickness,
      dashLength: dashLength,
      dashSpace: dashSpace,
      color: color,
      axis: Axis.vertical,
      length: length,
    );
  }

  /// Thickness of the divider line.
  final double thickness;

  /// Length of each dash along the main axis.
  final double dashLength;

  /// Gap between dashes along the main axis.
  final double dashSpace;
  final Color? color;
  final Axis axis;

  /// Fixed length along the main axis. When null, expands to parent constraints.
  final double? length;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).dividerColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final mainExtent =
            length ??
            (axis == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight);

        if (!mainExtent.isFinite || mainExtent <= 0) {
          return const SizedBox.shrink();
        }

        final dashCount = ((mainExtent + dashSpace) / (dashLength + dashSpace))
            .floor();

        if (dashCount <= 0) return const SizedBox.shrink();

        final children = List<Widget>.generate(dashCount, (_) {
          return axis == Axis.horizontal
              ? SizedBox(
                  width: dashLength,
                  height: thickness,
                  child: ColoredBox(color: effectiveColor),
                )
              : SizedBox(
                  width: thickness,
                  height: dashLength,
                  child: ColoredBox(color: effectiveColor),
                );
        });

        final line = Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: axis == Axis.horizontal ? Axis.horizontal : Axis.vertical,
          children: children,
        );

        if (axis == Axis.horizontal) {
          return SizedBox(width: mainExtent, height: thickness, child: line);
        }
        return SizedBox(width: thickness, height: mainExtent, child: line);
      },
    );
  }
}
