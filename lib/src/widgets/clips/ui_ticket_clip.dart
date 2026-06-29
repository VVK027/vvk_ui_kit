import 'package:flutter/material.dart';

/// Side along which ticket notches are cut.
enum UITicketNotchSide {
  /// Semicircular notches on the left and right edges.
  horizontal,

  /// Semicircular notches on the top and bottom edges.
  vertical,
}

/// Clips [child] to a ticket/coupon shape with optional edge notches.
class UITicketClip extends StatelessWidget {
  const UITicketClip({
    super.key,
    required this.child,
    this.notchRadius = 10,
    this.notchSide = UITicketNotchSide.horizontal,
    this.borderRadius = 12,
  }) : assert(notchRadius >= 0),
       assert(borderRadius >= 0);

  final Widget child;
  final double notchRadius;
  final UITicketNotchSide notchSide;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: UITicketClipper(
        notchRadius: notchRadius,
        notchSide: notchSide,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// Custom clipper for [UITicketClip].
class UITicketClipper extends CustomClipper<Path> {
  UITicketClipper({
    required this.notchRadius,
    required this.notchSide,
    required this.borderRadius,
  });

  final double notchRadius;
  final UITicketNotchSide notchSide;
  final double borderRadius;

  @override
  Path getClip(Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rect);

    if (notchRadius <= 0) return path;

    final notchPath = Path();
    switch (notchSide) {
      case UITicketNotchSide.horizontal:
        _addHorizontalNotches(notchPath, size);
      case UITicketNotchSide.vertical:
        _addVerticalNotches(notchPath, size);
    }

    return Path.combine(PathOperation.difference, path, notchPath);
  }

  void _addHorizontalNotches(Path notchPath, Size size) {
    final centerY = size.height / 2;
    final r = notchRadius;

    notchPath.addOval(Rect.fromCircle(center: Offset(0, centerY), radius: r));
    notchPath.addOval(
      Rect.fromCircle(center: Offset(size.width, centerY), radius: r),
    );
  }

  void _addVerticalNotches(Path notchPath, Size size) {
    final centerX = size.width / 2;
    final r = notchRadius;

    notchPath.addOval(Rect.fromCircle(center: Offset(centerX, 0), radius: r));
    notchPath.addOval(
      Rect.fromCircle(center: Offset(centerX, size.height), radius: r),
    );
  }

  @override
  bool shouldReclip(covariant UITicketClipper oldClipper) {
    return oldClipper.notchRadius != notchRadius ||
        oldClipper.notchSide != notchSide ||
        oldClipper.borderRadius != borderRadius;
  }
}
