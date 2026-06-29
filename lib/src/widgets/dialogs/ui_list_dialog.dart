import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_primary_text_button.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_text_button.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

/// Scrollable single-select list presented as a dialog.
class UIListDialog<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T, int, bool)? displayBuilder;
  final Widget Function(T, int, bool)? separatorBuilder;
  final String Function(T)? getTextFromItem;
  final ValueChanged<T> onItemSelected;
  final String? heading;
  final Widget? headingChild;
  final int initialSelectedIndex;
  final String? confirmBtnText;
  final String? cancelBtnText;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final double? posLeft;
  final double? posRight;
  final double? posTop;
  final double? posBottom;
  final double headingTextSize;
  final Color? backgroundColor;
  final Color? headingColor;
  final Color? dividerColor;
  final Color? itemTextColor;
  final Color? selectedRadioColor;
  final Color? radioUnselectedBorderColor;
  final Color? cancelButtonColor;
  final Color? confirmButtonBgColor;
  final Color? confirmButtonTextColor;
  final UIDialogProps dialog;

  const UIListDialog({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.heading,
    this.headingChild,
    this.displayBuilder,
    this.separatorBuilder,
    this.confirmBtnText,
    this.cancelBtnText,
    this.getTextFromItem,
    this.initialSelectedIndex = 0,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.posLeft,
    this.posRight,
    this.posTop,
    this.posBottom,
    this.headingTextSize = 17.0,
    this.backgroundColor,
    this.headingColor,
    this.dividerColor,
    this.itemTextColor,
    this.selectedRadioColor,
    this.radioUnselectedBorderColor,
    this.cancelButtonColor,
    this.confirmButtonBgColor,
    this.confirmButtonTextColor,
    this.dialog = const UIDialogProps(),
  });

  UIListDialog<T> copyWith({
    Key? key,
    List<T>? items,
    Widget Function(T, int, bool)? displayBuilder,
    Widget Function(T, int, bool)? separatorBuilder,
    String Function(T)? getTextFromItem,
    ValueChanged<T>? onItemSelected,
    String? heading,
    Widget? headingChild,
    int? initialSelectedIndex,
    String? confirmBtnText,
    String? cancelBtnText,
    double? width,
    double? height,
    EdgeInsets? padding,
    double? posLeft,
    double? posRight,
    double? posTop,
    double? posBottom,
    double? headingTextSize,
    Color? backgroundColor,
    Color? headingColor,
    Color? dividerColor,
    Color? itemTextColor,
    Color? selectedRadioColor,
    Color? radioUnselectedBorderColor,
    Color? cancelButtonColor,
    Color? confirmButtonBgColor,
    Color? confirmButtonTextColor,
    UIDialogProps? dialog,
  }) {
    return UIListDialog<T>(
      key: key ?? this.key,
      items: items ?? this.items,
      displayBuilder: displayBuilder ?? this.displayBuilder,
      separatorBuilder: separatorBuilder ?? this.separatorBuilder,
      getTextFromItem: getTextFromItem ?? this.getTextFromItem,
      onItemSelected: onItemSelected ?? this.onItemSelected,
      heading: heading ?? this.heading,
      headingChild: headingChild ?? this.headingChild,
      initialSelectedIndex: initialSelectedIndex ?? this.initialSelectedIndex,
      confirmBtnText: confirmBtnText ?? this.confirmBtnText,
      cancelBtnText: cancelBtnText ?? this.cancelBtnText,
      width: width ?? this.width,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      posLeft: posLeft ?? this.posLeft,
      posRight: posRight ?? this.posRight,
      posTop: posTop ?? this.posTop,
      posBottom: posBottom ?? this.posBottom,
      headingTextSize: headingTextSize ?? this.headingTextSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headingColor: headingColor ?? this.headingColor,
      dividerColor: dividerColor ?? this.dividerColor,
      itemTextColor: itemTextColor ?? this.itemTextColor,
      selectedRadioColor: selectedRadioColor ?? this.selectedRadioColor,
      radioUnselectedBorderColor:
          radioUnselectedBorderColor ?? this.radioUnselectedBorderColor,
      cancelButtonColor: cancelButtonColor ?? this.cancelButtonColor,
      confirmButtonBgColor: confirmButtonBgColor ?? this.confirmButtonBgColor,
      confirmButtonTextColor:
          confirmButtonTextColor ?? this.confirmButtonTextColor,
      dialog: dialog ?? this.dialog,
    );
  }

  @override
  State<UIListDialog<T>> createState() => _UIListDialogState<T>();
}

class _UIListDialogState<T> extends State<UIListDialog<T>> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = widget.backgroundColor ?? colorScheme.surface;
    final headingColor = widget.headingColor ?? colorScheme.onSurface;
    final dividerColor = widget.dividerColor ?? colorScheme.primary;
    final itemTextColor = widget.itemTextColor ?? colorScheme.onSurface;
    final selectedRadioColor = widget.selectedRadioColor ?? colorScheme.primary;
    final radioUnselectedBorderColor =
        widget.radioUnselectedBorderColor ??
        colorScheme.outline.withValues(alpha: 0.5);
    final cancelButtonColor = widget.cancelButtonColor ?? colorScheme.onSurface;
    final headingWidget =
        widget.headingChild ??
        (widget.heading != null
            ? UIText(
                widget.heading!,
                size: widget.headingTextSize,
                fontWeight: FontWeight.w700,
                color: headingColor,
                textAlign: TextAlign.center,
              )
            : null);
    final hasHeading = headingWidget != null;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: widget.posLeft,
              right: widget.posRight,
              top: widget.posTop,
              bottom: widget.posBottom,
              child: Container(
                width: widget.width,
                height: widget.height,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    if (headingWidget != null)
                      headingWidget
                    else
                      const SizedBox(),
                    SizedBox(height: hasHeading ? 15 : 0),
                    if (hasHeading)
                      Container(
                        width: double.infinity,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          color: dividerColor,
                        ),
                      )
                    else
                      const SizedBox(),
                    SizedBox(height: hasHeading ? 30 : 0),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              if (widget.confirmBtnText == null) {
                                _onSuccess(index);
                              } else {
                                setState(() => _selectedIndex = index);
                              }
                            },
                            child:
                                widget.displayBuilder?.call(
                                  widget.items[index],
                                  index,
                                  _selectedIndex == index,
                                ) ??
                                _defaultBuilder(
                                  widget.items[index],
                                  index,
                                  _selectedIndex == index,
                                  itemTextColor,
                                  selectedRadioColor,
                                  radioUnselectedBorderColor,
                                ),
                          );
                        },
                        separatorBuilder: (ctx, index) =>
                            widget.separatorBuilder?.call(
                              widget.items[index],
                              index,
                              _selectedIndex == index,
                            ) ??
                            const SizedBox(height: 15),
                        itemCount: widget.items.length,
                      ),
                    ),
                    SizedBox(height: widget.confirmBtnText != null ? 30 : 0),
                    if (widget.confirmBtnText != null)
                      widget.confirmButtonBgColor != null
                          ? UIPrimaryTextButton(
                              text: widget.confirmBtnText!,
                              height: 44,
                              enableBgColor: widget.confirmButtonBgColor,
                              enableTextColor: widget.confirmButtonTextColor,
                              onPressed: () => _onSuccess(_selectedIndex),
                            )
                          : UITextButton(
                              text: widget.confirmBtnText!,
                              height: 44,
                              onPressed: () => _onSuccess(_selectedIndex),
                            )
                    else
                      const SizedBox(),
                    SizedBox(height: widget.cancelBtnText != null ? 10 : 0),
                    if (widget.cancelBtnText != null)
                      UITextButton(
                        text: widget.cancelBtnText!,
                        onPressed: () => Navigator.of(context).pop(),
                        color: cancelButtonColor,
                        size: 14,
                        fontWeight: FontWeight.w600,
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTextFromItem(T item) => item.toString();

  Widget _defaultBuilder(
    T item,
    int index,
    bool isSelected,
    Color itemTextColor,
    Color selectedRadioColor,
    Color radioUnselectedBorderColor,
  ) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          _selectionIcon(
            isSelected,
            selectedRadioColor,
            radioUnselectedBorderColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: UIText(
              widget.getTextFromItem?.call(item) ?? _getTextFromItem(item),
              size: 15,
              fontWeight: FontWeight.w400,
              color: itemTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectionIcon(
    bool isSelected,
    Color selectedRadioColor,
    Color radioUnselectedBorderColor,
  ) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: isSelected ? selectedRadioColor : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isSelected ? selectedRadioColor : radioUnselectedBorderColor,
        ),
      ),
    );
  }

  void _onSuccess(int index) {
    Navigator.of(context).pop();
    widget.onItemSelected(widget.items[index]);
  }
}
