import 'package:flutter/material.dart';

/// Micro-interaction wrapper that applies a spring scale-down effect on tap down.
///
/// Wraps cards, list tiles, or custom buttons to give physical tactile feedback.
class UIPressable extends StatefulWidget {
  const UIPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
  });

  /// Child widget to scale down on tap.
  final Widget child;

  /// On tap callback.
  final VoidCallback? onTap;

  /// Scale factor applied during tap down.
  final double pressedScale;

  /// Duration of scale transition.
  final Duration duration;

  /// Curve of scale transition.
  final Curve curve;

  @override
  State<UIPressable> createState() => _UIPressableState();
}

class _UIPressableState extends State<UIPressable> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _onTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
