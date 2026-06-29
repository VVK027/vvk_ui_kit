import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Which corners receive a diagonal cut in [UISharpCorners].
enum UISharpCorner { topStart, topEnd, bottomStart, bottomEnd }

/// Clips [child] with diagonal cuts on selected corners.
class UISharpCorners extends StatelessWidget {
  const UISharpCorners({
    super.key,
    required this.child,
    this.cutSize = 12,
    this.corners = const {UISharpCorner.topStart, UISharpCorner.bottomEnd},
  }) : assert(cutSize >= 0);

  final Widget child;
  final double cutSize;
  final Set<UISharpCorner> corners;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: UISharpCornersClipper(cutSize: cutSize, corners: corners),
      child: child,
    );
  }
}

/// Custom clipper for [UISharpCorners].
class UISharpCornersClipper extends CustomClipper<Path> {
  UISharpCornersClipper({required this.cutSize, required this.corners});

  final double cutSize;
  final Set<UISharpCorner> corners;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final c = math.min(cutSize, math.min(w / 2, h / 2));

    final path = Path();

    if (corners.contains(UISharpCorner.topStart)) {
      path.moveTo(c, 0);
    } else {
      path.moveTo(0, 0);
    }

    if (corners.contains(UISharpCorner.topEnd)) {
      path.lineTo(w - c, 0);
      path.lineTo(w, c);
    } else {
      path.lineTo(w, 0);
    }

    if (corners.contains(UISharpCorner.bottomEnd)) {
      path.lineTo(w, h - c);
      path.lineTo(w - c, h);
    } else {
      path.lineTo(w, h);
    }

    if (corners.contains(UISharpCorner.bottomStart)) {
      path.lineTo(c, h);
      path.lineTo(0, h - c);
    } else {
      path.lineTo(0, h);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant UISharpCornersClipper oldClipper) {
    return oldClipper.cutSize != cutSize || oldClipper.corners != corners;
  }
}
