import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_rich_text.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import '../ui_widget_helpers.dart';

/// A styled dropdown field with optional title and required marker.
class UIDropdown extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final List<String>? items;
  final String? title;
  final String? selectedValue;
  final Color titleColor;
  final Color requiredMarkColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String? placeholder;

  /// Text appended after the title to mark a required field.
  final String requiredMarker;

  /// Whether to display the [requiredMarker] after the title.
  final bool showRequiredMarker;

  const UIDropdown({
    super.key,
    this.selectedValue,
    this.onChanged,
    this.items,
    this.title,
    required this.titleColor,
    required this.requiredMarkColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.placeholder,
    this.requiredMarker = ' *',
    this.showRequiredMarker = true,
  });

  /// Creates a [UIDropdown] with colors derived from [Theme.of(context)].
  factory UIDropdown.fromTheme(
    BuildContext context, {
    Key? key,
    ValueChanged<String>? onChanged,
    List<String>? items,
    String? title,
    String? selectedValue,
    String? placeholder,
    Color? titleColor,
    Color? requiredMarkColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    String requiredMarker = ' *',
    bool showRequiredMarker = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIDropdown(
      key: key,
      onChanged: onChanged,
      items: items,
      title: title,
      selectedValue: selectedValue,
      placeholder: placeholder,
      titleColor: titleColor ?? scheme.onSurface,
      requiredMarkColor: requiredMarkColor ?? scheme.error,
      backgroundColor: backgroundColor ?? scheme.surface,
      borderColor: borderColor ?? scheme.outline,
      textColor: textColor ?? scheme.onSurface,
      requiredMarker: requiredMarker,
      showRequiredMarker: showRequiredMarker,
    );
  }

  UIDropdown copyWith({
    Key? key,
    ValueChanged<String>? onChanged,
    List<String>? items,
    String? title,
    String? selectedValue,
    Color? titleColor,
    Color? requiredMarkColor,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    String? placeholder,
    String? requiredMarker,
    bool? showRequiredMarker,
  }) {
    return UIDropdown(
      key: key ?? this.key,
      onChanged: onChanged ?? this.onChanged,
      items: items ?? this.items,
      title: title ?? this.title,
      selectedValue: selectedValue ?? this.selectedValue,
      titleColor: titleColor ?? this.titleColor,
      requiredMarkColor: requiredMarkColor ?? this.requiredMarkColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      placeholder: placeholder ?? this.placeholder,
      requiredMarker: requiredMarker ?? this.requiredMarker,
      showRequiredMarker: showRequiredMarker ?? this.showRequiredMarker,
    );
  }

  @override
  State<UIDropdown> createState() => _UIDropdownState();
}

class _UIDropdownState extends State<UIDropdown> {
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem =
        widget.selectedValue ??
        widget.placeholder ??
        (widget.items?.isNotEmpty == true ? widget.items!.first : '');
  }

  @override
  void didUpdateWidget(covariant UIDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != null && widget.selectedValue != _selectedItem) {
      _selectedItem = widget.selectedValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = List<String>.from(widget.items ?? []);
    if (widget.selectedValue != null && !items.contains(widget.selectedValue)) {
      items.add(widget.selectedValue!);
    }
    if (_selectedItem.isNotEmpty && !items.contains(_selectedItem)) {
      items.add(_selectedItem);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIRichText(
          listTextSpan: [
            textSpan(
              widget.title ?? '',
              widget.titleColor,
              FontWeight.w700,
              16,
            ),
            if (widget.showRequiredMarker)
              textSpan(
                widget.requiredMarker,
                widget.requiredMarkColor,
                FontWeight.w700,
                16,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: widget.borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
              child: DropdownButton<String>(
                underline: Container(),
                isExpanded: true,
                value: items.contains(_selectedItem) ? _selectedItem : null,
                onChanged: (newValue) {
                  if (newValue == null) return;
                  setState(() => _selectedItem = newValue);
                  widget.onChanged?.call(newValue);
                },
                items: items
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: UIText(
                          value,
                          style: textStyle(
                            color: widget.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
