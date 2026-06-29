import 'package:flutter/material.dart';

/// Preset tap feedback styles for [AnimatedGestureDetector].
enum TapEffect {
  /// Subtle scale-down on press (default).
  scale,

  /// Stronger scale with elastic release.
  bounce,

  /// Opacity fade on press without scaling.
  highlight,
}

/// Wraps [child] with a short press animation before calling [onTap].
///
/// When [onTap] is `null`, no gesture or animation is applied.
class AnimatedGestureDetector extends StatefulWidget {
  const AnimatedGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.effect = TapEffect.scale,
    this.duration = const Duration(milliseconds: 120),
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Visual feedback applied while the widget is pressed.
  final TapEffect effect;

  /// Duration of the press/release animation.
  final Duration duration;

  @override
  State<AnimatedGestureDetector> createState() =>
      _AnimatedGestureDetectorState();
}

class _AnimatedGestureDetectorState extends State<AnimatedGestureDetector> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    final effect = widget.effect;
    final scale = switch (effect) {
      TapEffect.scale => _pressed ? 0.96 : 1.0,
      TapEffect.bounce => _pressed ? 0.92 : 1.0,
      TapEffect.highlight => 1.0,
    };

    Widget child = AnimatedScale(
      scale: scale,
      duration: widget.duration,
      curve: effect == TapEffect.bounce ? Curves.elasticOut : Curves.easeOut,
      child: widget.child,
    );

    if (effect == TapEffect.highlight) {
      child = AnimatedOpacity(
        opacity: _pressed ? 0.7 : 1.0,
        duration: widget.duration,
        child: child,
      );
    }

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: child,
    );
  }
}
