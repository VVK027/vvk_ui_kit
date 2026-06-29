import 'package:flutter/material.dart';

import 'ui_tour_enums.dart';

/// Full-screen dim overlay with a transparent cutout around [targetRect].
class UISpotlightOverlay extends StatefulWidget {
  const UISpotlightOverlay({
    super.key,
    required this.targetRect,
    this.padding = 8,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.shape = UISpotlightShape.rounded,
    this.borderRadius = 12,
    this.showPulse = false,
    this.onTargetTap,
    this.pulseColor = Colors.white,
  });

  final Rect targetRect;
  final double padding;
  final Color overlayColor;
  final UISpotlightShape shape;
  final double borderRadius;
  final bool showPulse;
  final VoidCallback? onTargetTap;
  final Color pulseColor;

  @override
  State<UISpotlightOverlay> createState() => _UISpotlightOverlayState();
}

class _UISpotlightOverlayState extends State<UISpotlightOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    );
    if (widget.showPulse) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(UISpotlightOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPulse && !oldWidget.showPulse) {
      _pulseController.repeat();
    } else if (!widget.showPulse && oldWidget.showPulse) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.targetRect.inflate(widget.padding);
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: CustomPaint(
            size: size,
            painter: _UISpotlightPainter(
              target: target,
              color: widget.overlayColor,
              shape: widget.shape,
              borderRadius: widget.borderRadius,
            ),
          ),
        ),
        if (widget.showPulse)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: size,
                painter: _UISpotlightPulsePainter(
                  target: target,
                  progress: _pulseAnimation.value,
                  color: widget.pulseColor,
                  shape: widget.shape,
                  borderRadius: widget.borderRadius,
                ),
              );
            },
          ),
        if (widget.onTargetTap != null)
          Positioned(
            left: target.left,
            top: target.top,
            width: target.width,
            height: target.height,
            child: GestureDetector(
              onTap: widget.onTargetTap,
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
      ],
    );
  }
}

class _UISpotlightPainter extends CustomPainter {
  _UISpotlightPainter({
    required this.target,
    required this.color,
    required this.shape,
    required this.borderRadius,
  });

  final Rect target;
  final Color color;
  final UISpotlightShape shape;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final cutout = Paint()
      ..color = color
      ..blendMode = BlendMode.dstOut;
    final overlay = Paint()..color = color;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, overlay);
    _drawShape(canvas, target, cutout);
    canvas.restore();
  }

  void _drawShape(Canvas canvas, Rect rect, Paint paint) {
    switch (shape) {
      case UISpotlightShape.circle:
        final radius = rect.shortestSide / 2;
        canvas.drawCircle(rect.center, radius, paint);
      case UISpotlightShape.pill:
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
          paint,
        );
      case UISpotlightShape.rectangle:
        canvas.drawRect(rect, paint);
      case UISpotlightShape.rounded:
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _UISpotlightPainter oldDelegate) {
    return target != oldDelegate.target ||
        color != oldDelegate.color ||
        shape != oldDelegate.shape ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class _UISpotlightPulsePainter extends CustomPainter {
  _UISpotlightPulsePainter({
    required this.target,
    required this.progress,
    required this.color,
    required this.shape,
    required this.borderRadius,
  });

  final Rect target;
  final double progress;
  final Color color;
  final UISpotlightShape shape;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final expansion = 20 * progress;
    final opacity = (1 - progress) * 0.6;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final expanded = target.inflate(expansion);

    switch (shape) {
      case UISpotlightShape.circle:
        canvas.drawCircle(
          expanded.center,
          expanded.shortestSide / 2,
          paint,
        );
      case UISpotlightShape.pill:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            expanded,
            Radius.circular(expanded.height / 2),
          ),
          paint,
        );
      case UISpotlightShape.rectangle:
        canvas.drawRect(expanded, paint);
      case UISpotlightShape.rounded:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            expanded,
            Radius.circular(borderRadius + expansion / 2),
          ),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _UISpotlightPulsePainter oldDelegate) {
    return progress != oldDelegate.progress || target != oldDelegate.target;
  }
}
