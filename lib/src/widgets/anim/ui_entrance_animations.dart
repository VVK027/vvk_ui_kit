import 'dart:math';

import 'package:flutter/widgets.dart';

import 'ui_animation_configuration.dart';

Animation<double> _curvedTween({
  required Animation<double> parent,
  required double begin,
  required double end,
  required Curve curve,
}) => Tween<double>(
  begin: begin,
  end: end,
).animate(CurvedAnimation(parent: parent, curve: curve));

/// Fades a child from transparent to opaque.
class UIFadeInAnimation extends StatelessWidget {
  const UIFadeInAnimation({
    super.key,
    this.duration,
    this.delay,
    this.curve = Curves.ease,
    required this.child,
  });

  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UIAnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: (animation) => Opacity(
        opacity: _curvedTween(
          parent: animation,
          begin: 0.0,
          end: 1.0,
          curve: curve,
        ).value,
        child: child,
      ),
    );
  }
}

/// Axis for [UIFlipAnimation].
enum UIFlipAxis { x, y }

/// Flips a child in 3D along the X or Y axis.
class UIFlipAnimation extends StatelessWidget {
  const UIFlipAnimation({
    super.key,
    this.duration,
    this.delay,
    this.curve = Curves.ease,
    this.flipAxis = UIFlipAxis.x,
    required this.child,
  });

  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final UIFlipAxis flipAxis;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UIAnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: (animation) {
        final value = _curvedTween(
          parent: animation,
          begin: 0,
          end: 1,
          curve: curve,
        ).value;
        final radians = (1 - value) * pi / 2;
        final transform = flipAxis == UIFlipAxis.y
            ? Matrix4.rotationY(radians)
            : Matrix4.rotationX(radians);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}

/// Scales a child from [scale] to 1.0.
class UIScaleInAnimation extends StatelessWidget {
  const UIScaleInAnimation({
    super.key,
    this.duration,
    this.delay,
    this.curve = Curves.ease,
    this.scale = 0.0,
    required this.child,
  }) : assert(scale >= 0.0);

  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UIAnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: (animation) => Transform.scale(
        scale: _curvedTween(
          parent: animation,
          begin: scale,
          end: 1.0,
          curve: curve,
        ).value,
        child: child,
      ),
    );
  }
}

/// Slides a child from an offset to its natural position.
class UISlideInAnimation extends StatelessWidget {
  const UISlideInAnimation({
    super.key,
    this.duration,
    this.delay,
    this.curve = Curves.ease,
    double? verticalOffset,
    double? horizontalOffset,
    required this.child,
  }) : verticalOffset = (verticalOffset == null && horizontalOffset == null)
           ? 50.0
           : (verticalOffset ?? 0.0),
       horizontalOffset = horizontalOffset ?? 0.0;

  final Duration? duration;
  final Duration? delay;
  final Curve curve;
  final double verticalOffset;
  final double horizontalOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UIAnimationConfigurator(
      duration: duration,
      delay: delay,
      animatedChildBuilder: (animation) {
        double animatedOffset(double offset) => _curvedTween(
          parent: animation,
          begin: offset,
          end: 0.0,
          curve: curve,
        ).value;
        return Transform.translate(
          offset: Offset(
            horizontalOffset == 0.0 ? 0.0 : animatedOffset(horizontalOffset),
            verticalOffset == 0.0 ? 0.0 : animatedOffset(verticalOffset),
          ),
          child: child,
        );
      },
    );
  }
}
