import 'package:flutter/material.dart';
import 'ui_coupon_card.dart' show UICouponCard;

/// Paints shadow and border along a coupon clip path for [UICouponCard].
class UICouponDecorationPainter extends CustomPainter {
  const UICouponDecorationPainter({
    this.shadow,
    this.border,
    required this.clipper,
  });

  final Shadow? shadow;
  final BorderSide? border;
  final CustomClipper<Path> clipper;

  @override
  void paint(Canvas canvas, Size size) {
    if (shadow != null) {
      final paintShadow = shadow!.toPaint();
      final pathShadow = clipper.getClip(size).shift(shadow!.offset);
      canvas.drawPath(pathShadow, paintShadow);
    }

    if (border != null) {
      final paintBorder = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = border!.width
        ..color = border!.color;
      canvas.drawPath(clipper.getClip(size), paintBorder);
    }
  }

  @override
  bool shouldRepaint(covariant UICouponDecorationPainter oldDelegate) {
    return shadow != oldDelegate.shadow ||
        border != oldDelegate.border ||
        clipper != oldDelegate.clipper;
  }
}
