import 'package:flutter/material.dart';

import 'ui_coupon_clipper.dart';

/// Clips [child] to a split-panel coupon shape with curved tear lines.
///
/// For shadow and border along the clip path, use [UICouponCard] or compose
/// [UICouponDecorationPainter] yourself. For circular edge notches, use
/// [UITicketClip].
class UICouponClip extends StatelessWidget {
  const UICouponClip({
    super.key,
    required this.child,
    this.borderRadius = 8,
    this.curveRadius = 20,
    this.curvePosition = 100,
    this.curveAxis = Axis.horizontal,
    this.clockwise = false,
  });

  final Widget child;
  final double borderRadius;
  final double curveRadius;
  final double curvePosition;
  final Axis curveAxis;
  final bool clockwise;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: UICouponClipper(
        borderRadius: borderRadius,
        curveRadius: curveRadius,
        curvePosition: curvePosition,
        curveAxis: curveAxis,
        direction: Directionality.of(context),
        clockwise: clockwise,
      ),
      child: child,
    );
  }
}
