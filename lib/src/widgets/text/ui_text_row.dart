import 'package:flutter/material.dart';

import 'ui_marquee.dart';
import 'ui_text.dart';

/// Horizontal row with optional prefix, primary text, and suffix widgets.
class UITextRow extends StatelessWidget {
  const UITextRow({
    super.key,
    this.prefix,
    this.text,
    this.textChild,
    this.suffix,
    this.spacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textStyle,
    this.maxLines = 1,
    this.marqueeOnOverflow = false,
  }) : assert(
         textChild != null || text != null,
         'Either text or textChild must be provided.',
       );

  final Widget? prefix;
  final String? text;
  final Widget? textChild;
  final Widget? suffix;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? textStyle;
  final int? maxLines;
  final bool marqueeOnOverflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle =
        textStyle ?? theme.textTheme.bodyMedium ?? const TextStyle();

    Widget label =
        textChild ??
        UIText(
          text!,
          maxLines: maxLines,
          textOverflow: TextOverflow.ellipsis,
          style: effectiveTextStyle,
        );

    if (marqueeOnOverflow) {
      label = Flexible(child: UIMarquee(child: label));
    } else {
      label = Flexible(child: label);
    }

    final children = <Widget>[
      if (prefix != null) ...[prefix!, SizedBox(width: spacing)],
      label,
      if (suffix != null) ...[SizedBox(width: spacing), suffix!],
    ];

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
