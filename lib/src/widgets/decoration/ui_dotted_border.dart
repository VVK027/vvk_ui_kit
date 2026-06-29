import 'package:flutter/material.dart';

/// Draws a dotted rounded-rect border around [child].
class UIDottedBorder extends StatelessWidget {
  const UIDottedBorder({
    super.key,
    required this.child,
    this.color,
    this.strokeWidth = 1,
    this.dotLength = 5,
    this.gap = 3,
    this.radius = 0,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final double strokeWidth;
  final double dotLength;
  final double gap;
  final double radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final borderColor = color ?? Theme.of(context).colorScheme.outline;

    return CustomPaint(
      painter: _DottedBorderPainter(
        color: borderColor,
        strokeWidth: strokeWidth,
        dotLength: dotLength,
        gap: gap,
        radius: radius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  _DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dotLength,
    required this.gap,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double dotLength;
  final double gap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);
    final dashedPath = _buildDashedPath(path, dotLength, gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _buildDashedPath(Path source, double dashLength, double dashGap) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = distance + dashLength;
        dashed.addPath(
          metric.extractPath(distance, end.clamp(0.0, metric.length)),
          Offset.zero,
        );
        distance = end + dashGap;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        dotLength != oldDelegate.dotLength ||
        gap != oldDelegate.gap ||
        radius != oldDelegate.radius;
  }
}
