import 'dart:math' show pi;

import 'package:flutter/material.dart';

/// Axis used by [UIAnimatedFlipCard] for the 3D flip animation.
enum UIFlipDirection { horizontal, vertical }

/// Visual configuration for [UIAnimatedFlipCard].
class UIAnimatedFlipCardStyle {
  const UIAnimatedFlipCardStyle({
    this.width,
    this.height,
    this.borderRadius,
    this.shadows,
    this.frontColor,
    this.backColor,
    this.border,
    this.flipDuration = const Duration(milliseconds: 400),
    this.flipCurve = Curves.easeInOut,
    this.padding,
    this.frontDecoration,
    this.backDecoration,
    this.direction = UIFlipDirection.horizontal,
    this.fill = false,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final Color? frontColor;
  final Color? backColor;
  final Border? border;
  final Duration flipDuration;
  final Curve flipCurve;
  final EdgeInsets? padding;
  final BoxDecoration? frontDecoration;
  final BoxDecoration? backDecoration;
  final UIFlipDirection direction;
  final bool fill;

  UIAnimatedFlipCardStyle copyWith({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    Color? frontColor,
    Color? backColor,
    Border? border,
    Duration? flipDuration,
    Curve? flipCurve,
    EdgeInsets? padding,
    BoxDecoration? frontDecoration,
    BoxDecoration? backDecoration,
    UIFlipDirection? direction,
    bool? fill,
  }) {
    return UIAnimatedFlipCardStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      frontColor: frontColor ?? this.frontColor,
      backColor: backColor ?? this.backColor,
      border: border ?? this.border,
      flipDuration: flipDuration ?? this.flipDuration,
      flipCurve: flipCurve ?? this.flipCurve,
      padding: padding ?? this.padding,
      frontDecoration: frontDecoration ?? this.frontDecoration,
      backDecoration: backDecoration ?? this.backDecoration,
      direction: direction ?? this.direction,
      fill: fill ?? this.fill,
    );
  }
}

/// Interactive card that flips between a front and back face.
class UIAnimatedFlipCard extends StatefulWidget {
  const UIAnimatedFlipCard({
    super.key,
    required this.front,
    required this.back,
    this.style,
    this.onFlip,
    this.flipOnTap = true,
    this.isFlipped = false,
  });

  final Widget front;
  final Widget back;
  final UIAnimatedFlipCardStyle? style;
  final VoidCallback? onFlip;
  final bool flipOnTap;
  final bool isFlipped;

  factory UIAnimatedFlipCard.fromTheme(
    BuildContext context, {
    Key? key,
    required Widget front,
    required Widget back,
    UIAnimatedFlipCardStyle? style,
    VoidCallback? onFlip,
    bool flipOnTap = true,
    bool isFlipped = false,
  }) {
    final theme = Theme.of(context);
    return UIAnimatedFlipCard(
      key: key,
      front: front,
      back: back,
      onFlip: onFlip,
      flipOnTap: flipOnTap,
      isFlipped: isFlipped,
      style:
          style ??
          UIAnimatedFlipCardStyle(
            frontColor: theme.cardColor,
            backColor: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            shadows: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            padding: const EdgeInsets.all(16),
          ),
    );
  }

  @override
  State<UIAnimatedFlipCard> createState() => _UIAnimatedFlipCardState();
}

class _UIAnimatedFlipCardState extends State<UIAnimatedFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool _isFrontVisible;

  UIAnimatedFlipCardStyle get _effectiveStyle {
    final theme = Theme.of(context);
    return widget.style ??
        UIAnimatedFlipCardStyle(
          frontColor: theme.cardColor,
          backColor: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          shadows: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          padding: const EdgeInsets.all(16),
        );
  }

  @override
  void initState() {
    super.initState();
    _isFrontVisible = !widget.isFlipped;
    final style = widget.style;
    _controller = AnimationController(
      vsync: this,
      duration: style?.flipDuration ?? const Duration(milliseconds: 400),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: style?.flipCurve ?? Curves.easeInOut,
      ),
    )..addListener(() => setState(() {}));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() => _isFrontVisible = !_isFrontVisible);
      }
    });

    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(UIAnimatedFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (!widget.flipOnTap || _controller.isAnimating) return;
    widget.onFlip?.call();
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _effectiveStyle;
    final angle = _animation.value * pi;

    Widget buildFace(Widget child, bool isFront) {
      return Container(
        width: style.width,
        height: style.height,
        padding: style.padding,
        decoration:
            (isFront ? style.frontDecoration : style.backDecoration) ??
            BoxDecoration(
              color: isFront ? style.frontColor : style.backColor,
              borderRadius: style.borderRadius,
              border: style.border,
              boxShadow: style.shadows,
            ),
        child: child,
      );
    }

    final flip = _buildFlipAnimation(angle, style.direction, buildFace);

    return GestureDetector(
      onTap: _toggleCard,
      child: style.fill ? SizedBox.expand(child: flip) : flip,
    );
  }

  Widget _buildFlipAnimation(
    double angle,
    UIFlipDirection direction,
    Widget Function(Widget child, bool isFront) buildFace,
  ) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(direction == UIFlipDirection.horizontal ? angle : 0)
        ..rotateX(direction == UIFlipDirection.vertical ? angle : 0),
      alignment: Alignment.center,
      child: angle < (pi / 2)
          ? buildFace(widget.front, true)
          : Transform(
              transform: Matrix4.identity()
                ..rotateY(direction == UIFlipDirection.horizontal ? pi : 0)
                ..rotateX(direction == UIFlipDirection.vertical ? pi : 0),
              alignment: Alignment.center,
              child: buildFace(widget.back, false),
            ),
    );
  }
}
