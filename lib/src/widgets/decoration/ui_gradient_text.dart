import 'package:flutter/material.dart';

/// A text widget that renders with a gradient fill.
class UIGradientText extends StatelessWidget {
  /// Creates a [UIGradientText].
  const UIGradientText(
    this.text, {
    super.key,
    this.textChild,
    required this.gradient,
    this.style,
  });

  /// The text to display.
  final String text;

  /// Optional custom widget to use instead of the default [Text].
  final Widget? textChild;

  /// The style to use for the text.
  final TextStyle? style;

  /// The gradient to apply to the text.
  final Gradient gradient;

  UIGradientText copyWith({
    Key? key,
    String? text,
    Widget? textChild,
    Gradient? gradient,
    TextStyle? style,
  }) {
    return UIGradientText(
      text ?? this.text,
      key: key ?? this.key,
      textChild: textChild ?? this.textChild,
      gradient: gradient ?? this.gradient,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textWidget =
        textChild ??
        Text(
          text,
          style: style,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        );

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: textWidget,
    );
  }
}
