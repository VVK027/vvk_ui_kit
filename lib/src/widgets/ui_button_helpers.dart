import 'package:flutter/material.dart';
import 'buttons/ui_styled_button.dart';
import 'text/ui_text.dart';

/// Applies [UIStyledButtonStyle] text colors to a button label widget.
Widget applyButtonLabelStyle(
  Widget label,
  UIStyledButtonStyle style,
  bool isDisabled,
) {
  final color = isDisabled ? style.disabledForegroundColor : style.textColor;

  if (label is Text) {
    return Text(
      label.data ?? '',
      style: style.textStyle.copyWith(color: color).merge(label.style),
      textAlign: label.textAlign,
      overflow: label.overflow ?? TextOverflow.ellipsis,
      maxLines: label.maxLines ?? 1,
    );
  }

  if (label is UIText) {
    return UIText(
      label.text,
      key: label.key,
      size: label.size,
      fontWeight: label.fontWeight,
      color: color,
      maxLines: label.maxLines,
      style: style.textStyle.copyWith(color: color).merge(label.style),
      textAlign: label.textAlign,
      textOverflow: label.textOverflow,
      lineHeight: label.lineHeight,
      letterSpacing: label.letterSpacing,
    );
  }

  if (label is Row) {
    return Row(
      mainAxisSize: label.mainAxisSize,
      mainAxisAlignment: label.mainAxisAlignment,
      crossAxisAlignment: label.crossAxisAlignment,
      children: label.children
          .map((child) => applyButtonLabelStyle(child, style, isDisabled))
          .toList(),
    );
  }

  return label;
}

/// Builds the inner row for icon + label button content.
Widget buildButtonChildRow({
  required Widget label,
  Widget? icon,
  double iconGap = 8,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ?icon,
      if (icon != null) SizedBox(width: iconGap),
      Flexible(child: label),
    ],
  );
}

RoundedRectangleBorder buttonShape(UIStyledButtonStyle style) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(style.borderRadius),
  );
}
