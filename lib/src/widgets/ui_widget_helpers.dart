import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/layout/ui_separated_flex.dart'
    show UISeparatedRow, UISeparatedColumn;
import 'package:vvk_ui_kit/vvk_ui_kit.dart'
    show UISeparatedRow, UISeparatedColumn;

import 'text/ui_text.dart';

/// Shared text and layout helpers used across form fields, dropdowns, and
/// rich-text widgets in this package.
///
/// Prefer [UISeparatedRow] / [UISeparatedColumn] when inserting dividers
/// between a list of widgets; use [intersperse] for ad-hoc separator lists.

/// Builds a label using [child] when provided, otherwise a themed [UIText].
Widget buildUILabel(
  String text, {
  Widget? child,
  double? size,
  Color? color,
  FontWeight? fontWeight,
  TextStyle? style,
  int? maxLines,
  TextAlign? textAlign,
  TextOverflow? textOverflow,
  double? lineHeight,
  double? letterSpacing,
}) {
  return child ??
      UIText(
        text,
        size: size,
        color: color,
        fontWeight: fontWeight,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
        textOverflow: textOverflow,
        lineHeight: lineHeight,
        letterSpacing: letterSpacing,
      );
}

/// Creates a [TextStyle] with common parameters, merging onto an optional [base].
TextStyle textStyle({
  required Color color,
  required FontWeight fontWeight,
  required double fontSize,
  TextStyle? base,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
}) {
  return (base ?? const TextStyle()).copyWith(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationThickness: decorationThickness,
  );
}

/// Creates a [TextSpan] with optional tap handling.
TextSpan textSpan(
  String text,
  Color color,
  FontWeight fontWeight,
  double fontSize, {
  TextStyle? base,
  VoidCallback? onTap,
  TextDecoration? decoration,
}) {
  return TextSpan(
    text: text,
    style: textStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      base: base,
      decoration: decoration,
    ),
    recognizer: onTap == null ? null : (TapGestureRecognizer()..onTap = onTap),
  );
}

/// Calculates the number of lines required to display [text] with [style]
/// within [maxWidth].
int getMaxLines(String text, TextStyle style, double maxWidth) {
  final span = TextSpan(text: text, style: style);
  final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
  tp.layout(maxWidth: maxWidth);
  return tp.computeLineMetrics().length;
}

/// Calculates the height required to display [text] within given constraints.
double getTextHeight(
  BuildContext context,
  String text,
  TextStyle style,
  double maxWidth,
  int? maxLines, {
  TextDirection? direction,
  double bufferSpacing = 5,
}) {
  final span = TextSpan(text: text, style: style);
  final tp = TextPainter(
    text: span,
    textDirection: direction ?? Directionality.of(context),
    textScaler: MediaQuery.of(context).textScaler,
    maxLines: maxLines,
  );
  tp.layout(minWidth: 0, maxWidth: maxWidth);
  final lines = tp.computeLineMetrics().length;
  return tp.size.height +
      (lines * (style.fontSize! * (style.height ?? 1) - style.fontSize!)) +
      bufferSpacing;
}

/// Returns loose constraints sized to roughly half the screen width.
BoxConstraints getBoxConstraintsLoose(BuildContext context) {
  return BoxConstraints.loose(
    Size(MediaQuery.sizeOf(context).width / 2 - 50, 50),
  );
}

/// Inserts [divider] between each widget in [widgets].
///
/// Set [leading] or [trailing] to add a divider before the first or after
/// the last item.
List<Widget> intersperse(
  List<Widget> widgets,
  Widget divider, {
  bool leading = false,
  bool trailing = false,
}) {
  if (widgets.isEmpty && !leading && !trailing) return [];
  return [
    if (leading) divider,
    ...widgets
        .take(widgets.length - 1)
        .map((child) => [child, divider])
        .expand((element) => element),
    widgets.last,
    if (trailing) divider,
  ];
}

/// Maps each item in [widgets] through [mapFunc] and flattens the result.
List<Widget> widgetMap<T>(List<T> widgets, List<Widget> Function(T) mapFunc) {
  return [...widgets.map(mapFunc).expand((element) => element)];
}
