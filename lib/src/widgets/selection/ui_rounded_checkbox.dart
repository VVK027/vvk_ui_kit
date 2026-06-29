import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Circular checkbox with optional label.
class UIRoundedCheckbox extends StatefulWidget {
  const UIRoundedCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelStyle,
    this.size = 24,
    this.checkedColor,
    this.uncheckedColor,
    this.borderColor,
    this.checkedIcon,
    this.uncheckedIcon,
    this.spacing = 8,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final TextStyle? labelStyle;
  final double size;
  final Color? checkedColor;
  final Color? uncheckedColor;
  final Color? borderColor;
  final Widget? checkedIcon;
  final Widget? uncheckedIcon;
  final double spacing;
  final Duration animationDuration;

  @override
  State<UIRoundedCheckbox> createState() => _UIRoundedCheckboxState();
}

class _UIRoundedCheckboxState extends State<UIRoundedCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(UIRoundedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _toggle() {
    if (widget.onChanged == null) return;
    final next = !_value;
    setState(() => _value = next);
    widget.onChanged!(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkedColor = widget.checkedColor ?? theme.colorScheme.primary;
    final uncheckedColor =
        widget.uncheckedColor ?? theme.colorScheme.surfaceContainerHighest;
    final borderColor = widget.borderColor ?? theme.colorScheme.outline;
    final onChanged = widget.onChanged;

    final box = AnimatedContainer(
      duration: widget.animationDuration,
      width: widget.size,
      height: widget.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _value ? checkedColor : uncheckedColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: _value
          ? (widget.checkedIcon ??
                Icon(
                  Icons.check,
                  size: widget.size * 0.62,
                  color: theme.colorScheme.onPrimary,
                ))
          : widget.uncheckedIcon,
    );

    final checkbox = onChanged == null
        ? box
        : InkWell(
            onTap: _toggle,
            customBorder: const CircleBorder(),
            child: box,
          );

    if (widget.label == null) return checkbox;

    return InkWell(
      onTap: onChanged == null ? null : _toggle,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          checkbox,
          SizedBox(width: widget.spacing),
          Flexible(
            child: UIText(
              widget.label!,
              style: widget.labelStyle ?? theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
