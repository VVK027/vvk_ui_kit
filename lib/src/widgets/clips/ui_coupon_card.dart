import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/clips/ui_ticket_clip.dart'
    show UITicketClip;

import 'ui_coupon_clipper.dart';
import 'ui_coupon_decoration_painter.dart';

/// Split-panel coupon card with curved tear lines between [firstChild] and
/// [secondChild].
///
/// For simple circular edge notches, use [UITicketClip] instead.
class UICouponCard extends StatelessWidget {
  const UICouponCard({
    super.key,
    required this.firstChild,
    required this.secondChild,
    this.width,
    this.height = 150,
    this.borderRadius = 8,
    this.curveRadius = 20,
    this.curvePosition = 100,
    this.curveAxis = Axis.horizontal,
    this.clockwise = false,
    this.backgroundColor,
    this.decoration,
    this.shadow,
    this.border,
  });

  final Widget firstChild;
  final Widget secondChild;
  final double? width;
  final double height;
  final double borderRadius;
  final double curveRadius;
  final double curvePosition;
  final Axis curveAxis;
  final bool clockwise;
  final Color? backgroundColor;
  final Decoration? decoration;
  final Shadow? shadow;
  final BorderSide? border;

  factory UICouponCard.fromTheme(
    BuildContext context, {
    Key? key,
    required Widget firstChild,
    required Widget secondChild,
    double? width,
    double height = 150,
    double borderRadius = 8,
    double curveRadius = 20,
    double curvePosition = 100,
    Axis curveAxis = Axis.horizontal,
    bool clockwise = false,
    Color? backgroundColor,
    Decoration? decoration,
    Shadow? shadow,
    BorderSide? border,
  }) {
    return UICouponCard(
      key: key,
      firstChild: firstChild,
      secondChild: secondChild,
      width: width,
      height: height,
      borderRadius: borderRadius,
      curveRadius: curveRadius,
      curvePosition: curvePosition,
      curveAxis: curveAxis,
      clockwise: clockwise,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      decoration: decoration,
      shadow: shadow,
      border: border,
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (curveAxis == Axis.horizontal)
        SizedBox(
          width: double.maxFinite,
          height: curvePosition + (curveRadius / 2),
          child: firstChild,
        )
      else
        SizedBox(
          width: curvePosition + (curveRadius / 2),
          height: double.maxFinite,
          child: firstChild,
        ),
      Expanded(child: secondChild),
    ];

    final clipper = UICouponClipper(
      borderRadius: borderRadius,
      curveRadius: curveRadius,
      curvePosition: curvePosition,
      curveAxis: curveAxis,
      direction: Directionality.of(context),
      clockwise: clockwise,
    );

    return CustomPaint(
      painter: UICouponDecorationPainter(
        shadow: shadow,
        border: border,
        clipper: clipper,
      ),
      child: ClipPath(
        clipper: clipper,
        child: Container(
          width: width,
          height: height,
          decoration: decoration ?? BoxDecoration(color: backgroundColor),
          child: curveAxis == Axis.horizontal
              ? Column(children: children)
              : Row(children: children),
        ),
      ),
    );
  }
}
