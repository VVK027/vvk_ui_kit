import 'package:flutter/material.dart';

/// A utility wrapper to apply standard entrance animations to any widget.
class UIAnimateWrapper extends StatefulWidget {
  const UIAnimateWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.offset = const Offset(0, 30),
    this.scale = 1.0,
    this.fade = true,
    this.curve = Curves.easeOutBack,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset offset;
  final double scale;
  final bool fade;
  final Curve curve;

  @override
  State<UIAnimateWrapper> createState() => _UIAnimateWrapperState();
}

class _UIAnimateWrapperState extends State<UIAnimateWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _offsetAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(
      begin: widget.scale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget result = Transform.translate(
          offset: _offsetAnimation.value,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );

        if (widget.fade) {
          result = Opacity(opacity: _fadeAnimation.value, child: result);
        }

        return result;
      },
      child: widget.child,
    );
  }
}
