import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

/// Selectable list tile with title, subtitle, and selection highlight.
class UIListTileSelect extends StatelessWidget {
  final Color titleColor;
  final Color subtitleColor;
  final Color selectedTitleColor;
  final Color unselectedTitleColor;
  final Color arrowColor;
  final String? title;
  final String? titleSelection;
  final String subTitle;
  final Widget? titleChild;
  final Widget? titleSelectionChild;
  final Widget? subtitleChild;
  final VoidCallback? onSelectTap;
  final bool isValueChanged;
  final bool showArrow;
  final UIListTileProps listTile;

  const UIListTileSelect({
    super.key,
    required this.titleColor,
    required this.subtitleColor,
    required this.selectedTitleColor,
    required this.unselectedTitleColor,
    required this.arrowColor,
    this.title,
    this.titleSelection,
    this.titleChild,
    this.titleSelectionChild,
    this.subtitleChild,
    this.onSelectTap,
    this.subTitle = '',
    this.isValueChanged = false,
    this.showArrow = false,
    this.listTile = const UIListTileProps(
      dense: true,
      contentPadding: EdgeInsets.zero,
    ),
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       ),
       assert(
         titleSelectionChild != null || titleSelection != null,
         'Either titleSelection or titleSelectionChild must be provided.',
       );

  UIListTileSelect copyWith({
    Key? key,
    Color? titleColor,
    Color? subtitleColor,
    Color? selectedTitleColor,
    Color? unselectedTitleColor,
    Color? arrowColor,
    String? title,
    String? titleSelection,
    String? subTitle,
    Widget? titleChild,
    Widget? titleSelectionChild,
    Widget? subtitleChild,
    VoidCallback? onSelectTap,
    bool? isValueChanged,
    bool? showArrow,
    UIListTileProps? listTile,
  }) {
    return UIListTileSelect(
      key: key ?? this.key,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      selectedTitleColor: selectedTitleColor ?? this.selectedTitleColor,
      unselectedTitleColor: unselectedTitleColor ?? this.unselectedTitleColor,
      arrowColor: arrowColor ?? this.arrowColor,
      title: title ?? this.title,
      titleSelection: titleSelection ?? this.titleSelection,
      subTitle: subTitle ?? this.subTitle,
      titleChild: titleChild ?? this.titleChild,
      titleSelectionChild: titleSelectionChild ?? this.titleSelectionChild,
      subtitleChild: subtitleChild ?? this.subtitleChild,
      onSelectTap: onSelectTap ?? this.onSelectTap,
      isValueChanged: isValueChanged ?? this.isValueChanged,
      showArrow: showArrow ?? this.showArrow,
      listTile: listTile ?? this.listTile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          size: 14,
          fontWeight: FontWeight.w400,
          color: titleColor,
          maxLines: 2,
        );
    final titleSelectionWidget =
        titleSelectionChild ??
        UIText(
          titleSelection!,
          size: isValueChanged ? 16 : 14,
          fontWeight: FontWeight.w600,
          color: isValueChanged ? selectedTitleColor : unselectedTitleColor,
          maxLines: 2,
        );
    final subtitleWidget =
        subtitleChild ??
        (subTitle.isNotEmpty
            ? UIText(
                subTitle,
                size: 12,
                color: subtitleColor,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.left,
                maxLines: 3,
              )
            : null);

    return listTile.build(
      title: Row(
        children: [
          Expanded(child: titleWidget),
          InkWell(
            onTap: showArrow ? onSelectTap : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titleSelectionWidget,
                const SizedBox(width: 16),
                if (showArrow)
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: arrowColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      subtitle: subtitleWidget,
    );
  }
}
