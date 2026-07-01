import 'package:flutter/material.dart';
import 'ui_badge.dart';
import '../text/ui_text.dart';

class UILiveBadgeStyle {
  const UILiveBadgeStyle({
    required this.backgroundColor,
    required this.textStyle,
    required this.dotColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.height = 18,
    this.borderRadius = 5.8,
    this.dotSize = 5,
  });

  final Color backgroundColor;
  final TextStyle textStyle;
  final Color dotColor;
  final EdgeInsetsGeometry padding;
  final double height;
  final double borderRadius;
  final double dotSize;
}

class UILiveBadge extends StatelessWidget {
  const UILiveBadge({
    super.key,
    required this.style,
    this.label,
    this.labelChild,
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       );

  final UILiveBadgeStyle style;
  final String? label;
  final Widget? labelChild;

  UILiveBadge copyWith({
    Key? key,
    UILiveBadgeStyle? style,
    String? label,
    Widget? labelChild,
  }) {
    return UILiveBadge(
      key: key ?? this.key,
      style: style ?? this.style,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget = labelChild ?? UIText(label!, style: style.textStyle);

    return UIBadge.live(
      backgroundColor: style.backgroundColor,
      foregroundColor: style.textStyle.color,
      dotColor: style.dotColor,
      dotSize: style.dotSize,
      padding: style.padding,
      borderRadius: style.borderRadius,
      child: labelWidget,
    );
  }
}
