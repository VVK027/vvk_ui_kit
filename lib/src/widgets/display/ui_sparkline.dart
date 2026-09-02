import 'package:flutter/material.dart';

/// Lightweight custom-painted sparkline trend chart for stat cards and dashboards.
class UISparkline extends StatelessWidget {
  const UISparkline({
    super.key,
    required this.data,
    this.width,
    this.height = 40,
    this.lineColor,
    this.lineWidth = 2.0,
    this.fillGradient,
    this.curved = true,
  });

  /// Numerical data points representing the trendline.
  final List<double> data;

  /// Optional fixed width.
  final double? width;

  /// Height of the sparkline chart.
  final double height;

  /// Line color. Defaults to ambient primary color.
  final Color? lineColor;

  /// Line stroke width.
  final double lineWidth;

  /// Optional fill gradient under the trendline.
  final Gradient? fillGradient;

  /// Whether to draw smooth cubic bezier curves or straight segments.
  final bool curved;

  @override
  Widget build(BuildContext context) {
    assert(data.length >= 2, 'UISparkline requires at least 2 data points.');
    final effectiveLineColor =
        lineColor ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _UISparklinePainter(
          data: data,
          lineColor: effectiveLineColor,
          lineWidth: lineWidth,
          fillGradient: fillGradient,
          curved: curved,
        ),
      ),
    );
  }
}

class _UISparklinePainter extends CustomPainter {
  _UISparklinePainter({
    required this.data,
    required this.lineColor,
    required this.lineWidth,
    required this.fillGradient,
    required this.curved,
  });

  final List<double> data;
  final Color lineColor;
  final double lineWidth;
  final Gradient? fillGradient;
  final bool curved;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minVal = data.reduce((a, b) => a < b ? a : b);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    final points = <Offset>[];
    final stepX = size.width / (data.length - 1);

    for (var i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i] - minVal) / range) * (size.height * 0.8) - (size.height * 0.1);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    if (curved && points.length > 2) {
      for (var i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlX = (p0.dx + p1.dx) / 2;
        path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
      }
    } else {
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    if (fillGradient != null) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();

      final fillPaint = Paint()
        ..shader = fillGradient!.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);
    }

    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_UISparklinePainter oldDelegate) {
    return data != oldDelegate.data ||
        lineColor != oldDelegate.lineColor ||
        lineWidth != oldDelegate.lineWidth ||
        fillGradient != oldDelegate.fillGradient ||
        curved != oldDelegate.curved;
  }
}
