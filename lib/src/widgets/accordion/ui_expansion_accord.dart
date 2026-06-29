import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/accordion/ui_expansion_accord_item.dart';
import 'package:vvk_ui_kit/src/widgets/accordion/ui_expansion_tile.dart';

/// An accordion that expands one or more [UIExpansionAccordItem]s.
class UIExpansionAccord extends StatefulWidget {
  const UIExpansionAccord({
    super.key,
    required this.items,
    required this.style,
    this.allowMultipleExpansion = false,
  });

  final List<UIExpansionAccordItem> items;
  final UIAccordionItemStyle style;
  final bool allowMultipleExpansion;

  UIExpansionAccord copyWith({
    Key? key,
    List<UIExpansionAccordItem>? items,
    UIAccordionItemStyle? style,
    bool? allowMultipleExpansion,
  }) {
    return UIExpansionAccord(
      key: key ?? this.key,
      items: items ?? this.items,
      style: style ?? this.style,
      allowMultipleExpansion:
          allowMultipleExpansion ?? this.allowMultipleExpansion,
    );
  }

  @override
  State<UIExpansionAccord> createState() => _UIExpansionAccordState();
}

class _UIExpansionAccordState extends State<UIExpansionAccord> {
  final Set<int> _expandedIndices = {};

  void _onToggle(int index, bool isExpanded) {
    setState(() {
      if (widget.allowMultipleExpansion) {
        if (isExpanded) {
          _expandedIndices.add(index);
        } else {
          _expandedIndices.remove(index);
        }
      } else {
        _expandedIndices
          ..clear()
          ..addAll(isExpanded ? {index} : {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return UIExpansionAccordItem(
          title: item.title,
          content: item.content,
          style: widget.style,
          initiallyExpanded: _expandedIndices.contains(index),
          onToggle: (expanded) => _onToggle(index, expanded),
          alignment: item.alignment,
          trailingIcon: item.trailingIcon,
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 6),
    );
  }
}
