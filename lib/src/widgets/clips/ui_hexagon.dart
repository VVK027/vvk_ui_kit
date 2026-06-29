import 'package:flutter/material.dart';

/// A widget clipped to a hexagonal shape.
class UIHexagon extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;

  const UIHexagon({
    super.key,
    this.child,
    this.width = 100.0,
    this.height = 100.0,
  });

  UIHexagon copyWith({Key? key, Widget? child, double? width, double? height}) {
    return UIHexagon(
      key: key ?? this.key,
      width: width ?? this.width,
      height: height ?? this.height,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: UIHexagonClipper(),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

/// Custom clipper that shapes widgets into a flat-top hexagon.
class UIHexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double w = size.width;
    final double h = size.height;

    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
