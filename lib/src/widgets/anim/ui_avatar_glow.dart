import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Pulsing glow effect around [child], useful for live status indicators.
class UIAvatarGlow extends StatefulWidget {
  const UIAvatarGlow({
    super.key,
    required this.child,
    this.glowCount = 2,
    this.glowColor,
    this.glowShape = BoxShape.circle,
    this.glowBorderRadius,
    this.duration = const Duration(seconds: 2),
    this.startDelay,
    this.animate = true,
    this.repeat = true,
    this.curve = Curves.fastOutSlowIn,
    this.glowRadiusFactor = 0.7,
  }) : assert(
         glowShape != BoxShape.circle || glowBorderRadius == null,
         'Cannot specify a border radius when the glow shape is a circle.',
       );

  final Widget child;
  final int glowCount;
  final Color? glowColor;
  final BoxShape glowShape;
  final BorderRadius? glowBorderRadius;
  final Duration duration;
  final Duration? startDelay;
  final bool animate;
  final bool repeat;
  final Curve curve;
  final double glowRadiusFactor;

  @override
  State<UIAvatarGlow> createState() => _UIAvatarGlowState();
}

class _UIAvatarGlowState extends State<UIAvatarGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animate) _startAnimation();
  }

  @override
  void didUpdateWidget(covariant UIAvatarGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _startAnimation() : _stopAnimation();
    } else if (widget.repeat != oldWidget.repeat && widget.animate) {
      widget.repeat ? _controller.repeat() : _controller.forward();
    }
  }

  Future<void> _startAnimation() async {
    final delay = widget.startDelay;
    if (delay != null) await Future<void>.delayed(delay);
    if (!mounted) return;
    if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  void _stopAnimation() {
    _controller.reverse().then((_) {
      if (mounted) _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? Theme.of(context).colorScheme.primary;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _GlowPainter(
              progress: _controller.value,
              curve: widget.curve,
              glowCount: widget.glowCount,
              glowColor: glowColor,
              glowShape: widget.glowShape,
              glowBorderRadius: widget.glowBorderRadius,
              glowRadiusFactor: widget.glowRadiusFactor,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  _GlowPainter({
    required this.progress,
    required this.curve,
    required this.glowCount,
    required this.glowColor,
    required this.glowShape,
    required this.glowBorderRadius,
    required this.glowRadiusFactor,
  });

  final double progress;
  final Curve curve;
  final int glowCount;
  final Color glowColor;
  final BoxShape glowShape;
  final BorderRadius? glowBorderRadius;
  final double glowRadiusFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = Tween<double>(begin: 0.3, end: 0).transform(progress);
    final paint = Paint()
      ..color = glowColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final glowSize = math.min(size.width, size.height);
    final glowRadius = glowSize / 2;
    final currentProgress = curve.transform(progress);
    final decoration = BoxDecoration(
      color: glowColor,
      shape: glowShape,
      borderRadius: glowBorderRadius,
    );

    for (var i = 1; i <= glowCount; i++) {
      final currentRadius =
          glowRadius + glowRadius * glowRadiusFactor * i * currentProgress;
      final rect = Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: currentRadius,
      );
      final path = decoration.getClipPath(rect, TextDirection.ltr);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        glowColor != oldDelegate.glowColor ||
        glowCount != oldDelegate.glowCount;
  }
}
