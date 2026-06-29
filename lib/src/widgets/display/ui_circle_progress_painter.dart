import 'dart:math';

import 'package:flutter/material.dart';

/// Circular progress arc painter for custom gauge and ring indicators.
class UICircleProgressPainter extends CustomPainter {
  UICircleProgressPainter({
    required this.progress,
    this.trackColor,
    this.progressColors = const [Color(0xFF5EEAD4), Color(0xFF0D9488)],
    this.trackStrokeWidth = 5,
    this.progressStrokeWidth = 8,
  });

  final double progress;
  final Color? trackColor;
  final List<Color> progressColors;
  final double trackStrokeWidth;
  final double progressStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final track = trackColor ?? progressColors.last.withValues(alpha: 0.15);
    final outerCircle = Paint()
      ..strokeWidth = trackStrokeWidth
      ..color = track
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradient = SweepGradient(
      startAngle: 3 * pi / 2,
      endAngle: 7 * pi / 2,
      tileMode: TileMode.repeated,
      colors: progressColors,
    );

    final completeArc = Paint()
      ..strokeWidth = progressStrokeWidth
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 10;

    canvas.drawCircle(center, radius, outerCircle);

    final angle = 2 * pi * (progress / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      completeArc,
    );
  }

  @override
  bool shouldRepaint(covariant UICircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColors != progressColors;
  }
}
