import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Corner placement for [UICornerRibbon].
enum UICornerRibbonLocation { topStart, topEnd, bottomStart, bottomEnd }

/// Diagonal corner ribbon overlay (e.g. "SALE", "NEW") on top of [child].
class UICornerRibbon extends StatelessWidget {
  const UICornerRibbon({
    super.key,
    required this.message,
    required this.location,
    this.child,
    this.textDirection,
    this.layoutDirection,
    this.color,
    this.textStyle,
    this.shadow = const BoxShadow(color: Color(0x7F000000), blurRadius: 6),
    this.ribbonOffset = 40,
    this.ribbonHeight = 20,
  });

  final Widget? child;
  final String message;
  final UICornerRibbonLocation location;
  final TextDirection? textDirection;
  final TextDirection? layoutDirection;
  final Color? color;
  final TextStyle? textStyle;
  final BoxShadow shadow;
  final double ribbonOffset;
  final double ribbonHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextDirection = textDirection ?? Directionality.of(context);
    final effectiveLayoutDirection =
        layoutDirection ?? Directionality.of(context);
    final effectiveColor = color ?? theme.colorScheme.error;
    final effectiveTextStyle =
        textStyle ??
        theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onError,
          fontWeight: FontWeight.w900,
          height: 1,
        ) ??
        TextStyle(
          color: theme.colorScheme.onError,
          fontSize: ribbonHeight * 0.7,
          fontWeight: FontWeight.w900,
          height: 1,
        );

    return ClipRect(
      child: CustomPaint(
        foregroundPainter: _CornerRibbonPainter(
          message: message,
          textDirection: effectiveTextDirection,
          location: location,
          layoutDirection: effectiveLayoutDirection,
          color: effectiveColor,
          textStyle: effectiveTextStyle,
          shadow: shadow,
          offset: ribbonOffset,
          height: ribbonHeight,
        ),
        child: child,
      ),
    );
  }
}

class _CornerRibbonPainter extends CustomPainter {
  _CornerRibbonPainter({
    required this.message,
    required this.textDirection,
    required this.location,
    required this.layoutDirection,
    required this.color,
    required this.textStyle,
    required this.shadow,
    required this.offset,
    required this.height,
  }) : super(repaint: PaintingBinding.instance.systemFonts);

  final String message;
  final TextDirection textDirection;
  final UICornerRibbonLocation location;
  final TextDirection layoutDirection;
  final Color color;
  final TextStyle textStyle;
  final BoxShadow shadow;
  final double offset;
  final double height;

  double get _totalBottomOffset => offset + (math.sqrt1_2 * height);

  Rect get _bannerRect =>
      Rect.fromLTWH(-offset, offset - height, offset * 2, height);

  @override
  void paint(Canvas canvas, Size size) {
    final bannerPaint = Paint()..color = color;
    final shadowPaint = shadow.toPaint();

    final textPainter = TextPainter(
      text: TextSpan(style: textStyle, text: message),
      textAlign: TextAlign.center,
      textDirection: textDirection,
    )..layout(minWidth: offset * 2, maxWidth: offset * 2);

    canvas.save();
    canvas.translate(_translationX(size.width), _translationY(size.height));
    canvas.rotate(_rotation);

    canvas.drawRect(_bannerRect, shadowPaint);
    canvas.drawRect(_bannerRect, bannerPaint);

    final textTop =
        _bannerRect.top + (_bannerRect.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(_bannerRect.left, textTop));
    canvas.restore();
  }

  double _translationX(double width) {
    return switch ((layoutDirection, location)) {
      (TextDirection.rtl, UICornerRibbonLocation.topStart) => width,
      (TextDirection.ltr, UICornerRibbonLocation.topStart) => 0,
      (TextDirection.rtl, UICornerRibbonLocation.topEnd) => 0,
      (TextDirection.ltr, UICornerRibbonLocation.topEnd) => width,
      (TextDirection.rtl, UICornerRibbonLocation.bottomStart) =>
        width - _totalBottomOffset,
      (TextDirection.ltr, UICornerRibbonLocation.bottomStart) =>
        _totalBottomOffset,
      (TextDirection.rtl, UICornerRibbonLocation.bottomEnd) =>
        _totalBottomOffset,
      (TextDirection.ltr, UICornerRibbonLocation.bottomEnd) =>
        width - _totalBottomOffset,
    };
  }

  double _translationY(double canvasHeight) {
    return switch (location) {
      UICornerRibbonLocation.bottomStart ||
      UICornerRibbonLocation.bottomEnd => canvasHeight - _totalBottomOffset,
      UICornerRibbonLocation.topStart || UICornerRibbonLocation.topEnd => 0,
    };
  }

  double get _rotation {
    return (math.pi / 4) *
        switch ((layoutDirection, location)) {
          (
            TextDirection.rtl,
            UICornerRibbonLocation.topStart || UICornerRibbonLocation.bottomEnd,
          ) =>
            1,
          (
            TextDirection.ltr,
            UICornerRibbonLocation.topStart || UICornerRibbonLocation.bottomEnd,
          ) =>
            -1,
          (
            TextDirection.rtl,
            UICornerRibbonLocation.bottomStart || UICornerRibbonLocation.topEnd,
          ) =>
            -1,
          (
            TextDirection.ltr,
            UICornerRibbonLocation.bottomStart || UICornerRibbonLocation.topEnd,
          ) =>
            1,
        };
  }

  @override
  bool shouldRepaint(covariant _CornerRibbonPainter oldDelegate) {
    return message != oldDelegate.message ||
        location != oldDelegate.location ||
        color != oldDelegate.color ||
        offset != oldDelegate.offset ||
        height != oldDelegate.height;
  }
}
