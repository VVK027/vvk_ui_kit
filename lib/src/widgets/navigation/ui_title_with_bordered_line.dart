import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Section title with a trailing horizontal divider line.
class UITitleWithBorderedLine extends StatelessWidget {
  final String? text;
  final Widget? textChild;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final EdgeInsets titlePadding;
  final EdgeInsets dividerPadding;
  final bool isProximaNova;
  final double lineHeight;
  final double? dividerWidth;
  final Color dividerColor;

  const UITitleWithBorderedLine({
    super.key,
    this.text,
    this.textChild,
    required this.dividerColor,
    this.size,
    this.color,
    this.fontWeight,
    this.style,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.titlePadding = const EdgeInsets.only(left: 17, right: 17),
    this.dividerPadding = const EdgeInsets.only(left: 17),
    this.isProximaNova = true,
    this.lineHeight = 0,
    this.dividerWidth,
  }) : assert(
         textChild != null || text != null,
         'Either text or textChild must be provided.',
       );

  UITitleWithBorderedLine copyWith({
    Key? key,
    String? text,
    Widget? textChild,
    double? size,
    FontWeight? fontWeight,
    Color? color,
    int? maxLines,
    TextStyle? style,
    TextAlign? textAlign,
    EdgeInsets? titlePadding,
    EdgeInsets? dividerPadding,
    bool? isProximaNova,
    double? lineHeight,
    double? dividerWidth,
    Color? dividerColor,
  }) {
    return UITitleWithBorderedLine(
      key: key ?? this.key,
      text: text ?? this.text,
      textChild: textChild ?? this.textChild,
      size: size ?? this.size,
      fontWeight: fontWeight ?? this.fontWeight,
      color: color ?? this.color,
      maxLines: maxLines ?? this.maxLines,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      titlePadding: titlePadding ?? this.titlePadding,
      dividerPadding: dividerPadding ?? this.dividerPadding,
      isProximaNova: isProximaNova ?? this.isProximaNova,
      lineHeight: lineHeight ?? this.lineHeight,
      dividerWidth: dividerWidth ?? this.dividerWidth,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textWidget =
        textChild ??
        UIText(
          text!,
          size: size,
          fontWeight: fontWeight,
          color: color,
          maxLines: maxLines,
          style: style,
          textAlign: textAlign,
          lineHeight: lineHeight,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: titlePadding, child: textWidget),
        Container(
          margin: dividerPadding,
          width: dividerWidth ?? MediaQuery.sizeOf(context).width / 2.5,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}
