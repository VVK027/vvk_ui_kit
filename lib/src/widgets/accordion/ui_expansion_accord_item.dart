import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/accordion/ui_expansion_tile.dart';

/// A single expandable section inside `UIExpansionAccord`.
class UIExpansionAccordItem extends StatelessWidget {
  const UIExpansionAccordItem({
    super.key,
    required this.title,
    required this.content,
    required this.style,
    this.initiallyExpanded = false,
    this.onToggle,
    this.alignment,
    this.trailingIcon,
  });

  final String title;
  final Widget content;
  final UIAccordionItemStyle style;
  final bool initiallyExpanded;
  final void Function(bool)? onToggle;
  final AlignmentGeometry? alignment;
  final Widget? trailingIcon;

  UIExpansionAccordItem copyWith({
    Key? key,
    String? title,
    Widget? content,
    UIAccordionItemStyle? style,
    bool? initiallyExpanded,
    void Function(bool)? onToggle,
    AlignmentGeometry? alignment,
    Widget? trailingIcon,
  }) {
    return UIExpansionAccordItem(
      key: key ?? this.key,
      title: title ?? this.title,
      content: content ?? this.content,
      style: style ?? this.style,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      onToggle: onToggle ?? this.onToggle,
      alignment: alignment ?? this.alignment,
      trailingIcon: trailingIcon ?? this.trailingIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UIExpansionTile(
      title: title,
      style: style.copyWith(
        useInkWell: true,
        animatedExpansion: true,
        headerPadding: const EdgeInsets.symmetric(horizontal: 16),
        headerHeight: style.headerHeight < 52 ? 52 : style.headerHeight,
      ),
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onToggle,
      trailingIcon: trailingIcon,
      children: [
        Container(
          alignment: alignment,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
          child: content,
        ),
      ],
    );
  }
}
