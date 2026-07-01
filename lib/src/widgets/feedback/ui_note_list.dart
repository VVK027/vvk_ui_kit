import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Bulleted note list with optional title and custom bullet styling.
class UINoteList extends StatelessWidget {
  const UINoteList({
    super.key,
    required this.notes,
    this.title,
    this.titleChild,
    this.titleStyle,
    this.bulletStyle,
    this.decoration,
    this.padding,
    this.showTitle = true,
  });

  final List<Widget> notes;
  final String? title;
  final Widget? titleChild;
  final TextStyle? titleStyle;
  final TextStyle? bulletStyle;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final bool showTitle;

  UINoteList copyWith({
    Key? key,
    List<Widget>? notes,
    String? title,
    Widget? titleChild,
    TextStyle? titleStyle,
    TextStyle? bulletStyle,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    bool? showTitle,
  }) {
    return UINoteList(
      key: key ?? this.key,
      notes: notes ?? this.notes,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      titleStyle: titleStyle ?? this.titleStyle,
      bulletStyle: bulletStyle ?? this.bulletStyle,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      showTitle: showTitle ?? this.showTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget =
        titleChild ??
        (title != null ? UIText(title!, style: titleStyle) : null);

    return Container(
      decoration: decoration,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle && titleWidget != null) titleWidget,
          if (showTitle && titleWidget != null) const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notes.map((note) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIText('• ', style: bulletStyle),
                  Expanded(child: note),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
