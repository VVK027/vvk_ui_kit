import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_button_props.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Outlined button with custom border, radius, and label styling.
class UICustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? iconWidget;
  final IconData? labelIcon;
  final Widget? labelIconWidget;
  final String? label;
  final Widget? labelChild;
  final Widget? child;
  final double iconSize;
  final double? gap;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final UIMaterialButtonProps material;

  const UICustomOutlinedButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.labelIcon,
    this.labelIconWidget,
    this.label,
    this.labelChild,
    this.child,
    this.iconSize = 18.0,
    this.gap,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
    this.material = const UIMaterialButtonProps(),
  });

  UICustomOutlinedButton copyWith({
    Key? key,
    VoidCallback? onPressed,
    IconData? icon,
    Widget? iconWidget,
    IconData? labelIcon,
    Widget? labelIconWidget,
    String? label,
    Widget? labelChild,
    Widget? child,
    double? iconSize,
    double? gap,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    UIMaterialButtonProps? material,
  }) {
    return UICustomOutlinedButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      icon: icon ?? this.icon,
      iconWidget: iconWidget ?? this.iconWidget,
      labelIcon: labelIcon ?? this.labelIcon,
      labelIconWidget: labelIconWidget ?? this.labelIconWidget,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
      iconSize: iconSize ?? this.iconSize,
      gap: gap ?? this.gap,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      padding: padding ?? this.padding,
      material: material ?? this.material,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorderColor = Theme.of(
      context,
    ).colorScheme.outline.withValues(alpha: 0.4);
    return material.outlined(
      onPressed: onPressed,
      baseStyle: OutlinedButton.styleFrom(
        padding: padding,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        side: BorderSide(color: borderColor ?? defaultBorderColor),
      ),
      child: child ?? _buildContent(),
    );
  }

  Widget _buildContent() {
    final leadingIcon =
        iconWidget ??
        (icon != null
            ? Icon(icon, size: iconSize, color: foregroundColor)
            : null);
    final trailingIcon =
        labelIconWidget ??
        (labelIcon != null
            ? Icon(labelIcon, size: iconSize, color: foregroundColor)
            : null);
    final labelWidget =
        labelChild ??
        (label != null ? UIText(label!, color: foregroundColor) : null);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ?leadingIcon,
        if (leadingIcon != null &&
            (labelWidget != null || trailingIcon != null))
          SizedBox(width: gap ?? 4),
        ?labelWidget,
        if (labelWidget != null && trailingIcon != null)
          SizedBox(width: gap ?? 4),
        ?trailingIcon,
      ],
    );
  }
}
