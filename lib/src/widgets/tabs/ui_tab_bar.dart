import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// A horizontal scrollable tab bar with customizable styles and indicators.
class UITabBar<T> extends StatelessWidget {
  /// The list of items to display as tabs.
  final List<T> items;

  /// Function to extract label text from an item.
  final String? Function(T) getTextFromItem;

  /// Callback when a tab is clicked.
  final void Function(int, T) onTabClicked;

  /// Optional function for custom text styles per tab.
  final TextStyle Function(int, T)? customTextStyle;

  /// Text style for the selected tab.
  final TextStyle? selectedTextStyle;

  /// Text style for unselected tabs.
  final TextStyle? unSelectedTextStyle;

  /// The currently selected index.
  final int selectedIndex;

  /// Outer padding for the tab bar.
  final EdgeInsets padding;

  /// Color of the underline indicator.
  final Color? underLineColor;

  /// Whether to show the underline indicator for the selected tab.
  final bool? isToShowUnderLine;

  /// Height of the underline indicator.
  final double underlineHeight;

  /// Prefix for keys used in automated testing.
  final String childKeyPrefix;

  /// Creates a [UITabBar].
  const UITabBar({
    super.key,
    required this.items,
    required this.getTextFromItem,
    required this.onTabClicked,
    required this.selectedTextStyle,
    required this.unSelectedTextStyle,
    this.customTextStyle,
    this.selectedIndex = 0,
    this.underLineColor,
    this.isToShowUnderLine = false,
    this.underlineHeight = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.childKeyPrefix = '',
  });

  UITabBar<T> copyWith({
    Key? key,
    List<T>? items,
    String? Function(T)? getTextFromItem,
    void Function(int, T)? onTabClicked,
    TextStyle Function(int, T)? customTextStyle,
    TextStyle? selectedTextStyle,
    TextStyle? unSelectedTextStyle,
    int? selectedIndex,
    EdgeInsets? padding,
    Color? underLineColor,
    bool? isToShowUnderLine,
    double? underlineHeight,
    String? childKeyPrefix,
  }) {
    return UITabBar<T>(
      key: key ?? this.key,
      items: items ?? this.items,
      getTextFromItem: getTextFromItem ?? this.getTextFromItem,
      onTabClicked: onTabClicked ?? this.onTabClicked,
      customTextStyle: customTextStyle ?? this.customTextStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      unSelectedTextStyle: unSelectedTextStyle ?? this.unSelectedTextStyle,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      padding: padding ?? this.padding,
      underLineColor: underLineColor ?? this.underLineColor,
      isToShowUnderLine: isToShowUnderLine ?? this.isToShowUnderLine,
      underlineHeight: underlineHeight ?? this.underlineHeight,
      childKeyPrefix: childKeyPrefix ?? this.childKeyPrefix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < items.length; i++)
              InkWell(
                key: Key('${childKeyPrefix}app_tab_bar_item_$i'),
                onTap: () => onTabClicked(i, items[i]),
                child: IntrinsicWidth(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: UIText(
                          getTextFromItem(items[i]) ?? '',
                          key: Key('${childKeyPrefix}app_tab_bar_item_text_$i'),
                          style: selectedIndex == i
                              ? selectedTextStyle
                              : customTextStyle?.call(i, items[i]) ??
                                    unSelectedTextStyle,
                        ),
                      ),
                      Visibility(
                        visible: selectedIndex == i && isToShowUnderLine!,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: underlineHeight,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4),
                              ),
                              color:
                                  underLineColor ??
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
