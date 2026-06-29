import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Generic dropdown list item.
class UIOverlayDropdownItem {
  const UIOverlayDropdownItem({
    required this.value,
    required this.label,
    this.display,
    this.itemColor,
    this.leading,
    this.selectedBadge,
  });

  final String value;
  final String label;
  final String? display;
  final Color? itemColor;
  final Widget? leading;
  final Widget? selectedBadge;
}

/// Visual styling for [UIOverlayDropdown] field and menu.
class UIOverlayDropdownStyle {
  const UIOverlayDropdownStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.labelStyle,
    required this.itemStyle,
    required this.selectedBackgroundColor,
    required this.selectedBorderColor,
    required this.menuBackgroundColor,
    required this.menuBorderColor,
    this.maxMenuHeight = 300,
    this.itemHeight = 40,
    this.fieldHeight = 40,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final TextStyle labelStyle;
  final TextStyle itemStyle;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color menuBackgroundColor;
  final Color menuBorderColor;
  final double maxMenuHeight;
  final double itemHeight;
  final double fieldHeight;
}

/// Overlay dropdown field that opens a positioned selection menu.
class UIOverlayDropdown extends StatefulWidget {
  const UIOverlayDropdown({
    required this.items,
    required this.style,
    super.key,
    this.value,
    this.placeholder,
    this.onChanged,
    this.displayLabelBuilder,
    this.trailingIcon,
    this.autoChange = false,
    this.onOverlayInsert,
    this.onOverlayRemove,
  });

  final List<UIOverlayDropdownItem> items;
  final UIOverlayDropdownStyle style;
  final String? value;
  final String? placeholder;
  final ValueChanged<String?>? onChanged;
  final String Function(UIOverlayDropdownItem selectedItem, String? value)?
  displayLabelBuilder;
  final Widget? trailingIcon;
  final bool autoChange;
  final void Function(OverlayEntry entry)? onOverlayInsert;
  final VoidCallback? onOverlayRemove;

  @override
  State<UIOverlayDropdown> createState() => _UIOverlayDropdownState();
}

class _UIOverlayDropdownState extends State<UIOverlayDropdown> {
  String? selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant UIOverlayDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      selectedValue = widget.value;
    }
  }

  @override
  void dispose() {
    _removeOverlay(isDisposing: true);
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final triggerWidth = renderBox.size.width;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            dismissible: true,
            onDismiss: _removeOverlay,
            color: Colors.transparent,
          ),
          Positioned(
            width: triggerWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, widget.style.fieldHeight + 8),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: widget.style.maxMenuHeight,
                    minWidth: triggerWidth,
                  ),
                  decoration: BoxDecoration(
                    color: widget.style.menuBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: widget.style.menuBorderColor),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    children: widget.items.map((item) {
                      final isSelected = item.value == selectedValue;
                      return InkWell(
                        onTap: () {
                          _handleChanged(item.value);
                          _removeOverlay();
                        },
                        child: Container(
                          height: widget.style.itemHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            children: [
                              Container(
                                decoration: isSelected
                                    ? BoxDecoration(
                                        color: widget
                                            .style
                                            .selectedBackgroundColor,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color:
                                              widget.style.selectedBorderColor,
                                        ),
                                      )
                                    : null,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                height: widget.style.itemHeight,
                                child: Row(
                                  children: [
                                    if (item.leading != null) ...[
                                      item.leading!,
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: UIText(
                                        (item.display?.isNotEmpty == true
                                                ? item.display
                                                : item.label) ??
                                            '',
                                        style: widget.style.itemStyle.copyWith(
                                          color: item.itemColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected && item.selectedBadge != null)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: item.selectedBadge!,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.onOverlayInsert != null) {
      widget.onOverlayInsert!(_overlayEntry!);
    } else {
      overlay.insert(_overlayEntry!);
    }

    setState(() => _isDropdownOpen = true);
  }

  void _removeOverlay({bool isDisposing = false}) {
    widget.onOverlayRemove?.call();
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted && !isDisposing) {
      setState(() => _isDropdownOpen = false);
    }
  }

  void _handleChanged(String? newValue) {
    setState(() => selectedValue = newValue);
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == selectedValue,
      orElse: () => widget.items.first,
    );

    if (selectedValue == null ||
        !widget.items.any((item) => item.value == selectedValue)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.autoChange) {
          _handleChanged(selectedItem.value);
        }
      });
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: widget.style.fieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.style.backgroundColor,
            border: Border.all(
              color: _isDropdownOpen
                  ? widget.style.focusedBorderColor
                  : widget.style.borderColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UIText(
                  widget.displayLabelBuilder?.call(
                        selectedItem,
                        selectedValue,
                      ) ??
                      selectedItem.label,
                  style: widget.style.labelStyle,
                  textOverflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              widget.trailingIcon ??
                  Icon(
                    _isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
