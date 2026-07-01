import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart' show UICouponCard, UITicketClipper;

/// Clips a widget to a split-panel coupon shape with curved tear lines.
///
/// Use with [ClipPath] or [UICouponCard]. For circular edge notches, see
/// [UITicketClipper].
class UICouponClipper extends CustomClipper<Path> {
  const UICouponClipper({
    this.borderRadius = 8,
    this.curveRadius = 20,
    this.curvePosition = 100,
    this.curveAxis = Axis.horizontal,
    this.direction = TextDirection.ltr,
    this.clockwise = false,
  }) : assert(
         curvePosition > borderRadius,
         'curvePosition must be greater than borderRadius',
       );

  final double borderRadius;
  final double curveRadius;
  final double curvePosition;
  final Axis curveAxis;
  final TextDirection direction;
  final bool clockwise;

  @override
  Path getClip(Size size) {
    var directionalCurvePosition = curvePosition;

    if (curveAxis == Axis.vertical && direction == TextDirection.rtl) {
      directionalCurvePosition = size.width - curvePosition - curveRadius;
    }

    final arcRadius = Radius.circular(borderRadius);
    final bottomLeftArc = Offset(borderRadius, size.height);
    final bottomRightArc = Offset(size.width, size.height - borderRadius);
    final topRightArc = Offset(size.width - borderRadius, 0);
    final topLeftArc = Offset(0, borderRadius);

    final path = Path()..moveTo(0, borderRadius - 2);

    if (curveAxis == Axis.horizontal) {
      path
        ..lineTo(0, directionalCurvePosition)
        ..quadraticBezierTo(
          curveRadius / 1.5,
          directionalCurvePosition + (curveRadius / 2),
          0,
          directionalCurvePosition + curveRadius,
        );
    }

    path
      ..lineTo(0, size.height - borderRadius)
      ..arcToPoint(bottomLeftArc, radius: arcRadius, clockwise: clockwise);

    if (curveAxis == Axis.vertical) {
      path
        ..lineTo(directionalCurvePosition, size.height)
        ..quadraticBezierTo(
          directionalCurvePosition + (curveRadius / 2),
          size.height - (curveRadius / 1.5),
          directionalCurvePosition + curveRadius,
          size.height,
        );
    }

    path
      ..lineTo(size.width - borderRadius, size.height)
      ..arcToPoint(bottomRightArc, radius: arcRadius, clockwise: clockwise);

    if (curveAxis == Axis.horizontal) {
      path
        ..lineTo(size.width, directionalCurvePosition + curveRadius)
        ..quadraticBezierTo(
          size.width - (curveRadius / 1.5),
          directionalCurvePosition + (curveRadius / 2),
          size.width,
          directionalCurvePosition,
        );
    }

    path
      ..lineTo(size.width, borderRadius)
      ..arcToPoint(topRightArc, radius: arcRadius, clockwise: clockwise);

    if (curveAxis == Axis.vertical) {
      path
        ..lineTo(directionalCurvePosition + curveRadius, 0)
        ..quadraticBezierTo(
          (directionalCurvePosition - (curveRadius / 2)) + curveRadius,
          curveRadius / 1.5,
          directionalCurvePosition - curveRadius + curveRadius,
          0,
        );
    }

    path
      ..lineTo(borderRadius, 0)
      ..arcToPoint(topLeftArc, radius: arcRadius, clockwise: clockwise);

    return path;
  }

  @override
  bool shouldReclip(covariant UICouponClipper oldClipper) => oldClipper != this;
}
