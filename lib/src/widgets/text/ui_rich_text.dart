import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Configuration for a segment of text within a [UIRichText] widget.
class UIRichTextSpan {
  /// Creates a [UIRichTextSpan].
  const UIRichTextSpan({
    required this.text,
    this.style,
    this.onTap,
    this.recognizer,
  });

  /// The text content of this span.
  final String text;

  /// Style for this specific span.
  final TextStyle? style;

  /// Callback when this span is tapped.
  final VoidCallback? onTap;

  /// Optional [TapGestureRecognizer] for advanced tap handling.
  final TapGestureRecognizer? recognizer;
}

/// A text widget that supports multiple styles and interactive segments.
class UIRichText extends StatelessWidget {
  /// Creates a [UIRichText].
  const UIRichText({
    super.key,
    this.text,
    this.children = const [],
    this.onChildTap,
    this.listTextSpan,
    this.spans = const [],
    this.size,
    this.fontWeight,
    this.color,
    this.maxLines,
    this.style,
    this.textAlign = TextAlign.left,
    this.fontFamily,
    this.textOverflow,
    this.lineHeight,
  });

  final String? text;
  final List<Map<String, dynamic>> children;
  final ValueChanged<int>? onChildTap;
  final List<TextSpan>? listTextSpan;
  final List<UIRichTextSpan> spans;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    if (listTextSpan != null) {
      return RichText(
        key: key,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: textOverflow ?? TextOverflow.clip,
        text: TextSpan(children: listTextSpan),
      );
    }

    if (spans.isNotEmpty) {
      return Text.rich(
        TextSpan(
          style: style ?? Theme.of(context).textTheme.bodyMedium,
          children: spans
              .map((span) {
                TapGestureRecognizer? recognizer = span.recognizer;
                if (recognizer == null && span.onTap != null) {
                  recognizer = TapGestureRecognizer()..onTap = span.onTap;
                } else if (recognizer != null && span.onTap != null) {
                  recognizer.onTap = span.onTap;
                }
                return TextSpan(
                  text: span.text,
                  style: span.style,
                  recognizer: recognizer,
                );
              })
              .toList(growable: false),
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: textOverflow,
      );
    }

    final TextStyle resolved = _resolveStyle(context);
    return Text.rich(
      softWrap: true,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      style: resolved,
      TextSpan(
        text: text,
        children: List.generate(children.length, (index) {
          final Map<String, dynamic> item = children[index];
          final TextStyle childStyle = resolved.copyWith(
            color: item['color'] as Color? ?? resolved.color,
          );
          if (item['clickable'] == true) {
            final TapGestureRecognizer recognizer = TapGestureRecognizer()
              ..onTap = () => onChildTap?.call(index);
            return TextSpan(
              text: item['title'] as String,
              style: childStyle,
              recognizer: recognizer,
            );
          }
          return TextSpan(text: item['title'] as String, style: childStyle);
        }),
      ),
    );
  }

  TextStyle _resolveStyle(BuildContext context) {
    final TextStyle themeStyle =
        style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    return themeStyle.copyWith(
      fontFamily: fontFamily ?? themeStyle.fontFamily,
      fontSize: size ?? themeStyle.fontSize,
      fontWeight: fontWeight ?? themeStyle.fontWeight,
      color: color ?? themeStyle.color,
      height: lineHeight ?? themeStyle.height,
    );
  }
}
