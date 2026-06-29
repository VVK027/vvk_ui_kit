import 'package:flutter/material.dart';

/// A standard text widget with easy access to common styling properties.
///
/// [UIText] wraps the standard [Text] widget and provides a more convenient
/// API for setting font size, weight, color, and other common attributes.
class UIText extends StatelessWidget {
  /// The text to display.
  final String text;

  /// Font size.
  final double? size;

  /// Font weight.
  final FontWeight? fontWeight;

  /// Text color.
  final Color? color;

  /// Maximum number of lines for the text.
  final int? maxLines;

  /// Optional [TextStyle] override.
  final TextStyle? style;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Text overflow behavior.
  final TextOverflow? textOverflow;

  /// Line height.
  final double? lineHeight;

  /// Letter spacing.
  final double? letterSpacing;

  /// Creates a [UIText].
  const UIText(
    this.text, {
    super.key,
    this.size,
    this.color,
    this.fontWeight,
    this.style,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.textOverflow,
    this.lineHeight,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle =
        style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    return Text(
      text,
      softWrap: true,
      key: key,
      textAlign: textAlign,
      style: baseStyle.copyWith(
        fontSize: size ?? baseStyle.fontSize,
        fontWeight: fontWeight ?? baseStyle.fontWeight,
        color: color ?? baseStyle.color,
        height: lineHeight ?? baseStyle.height,
        letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
      ),
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
