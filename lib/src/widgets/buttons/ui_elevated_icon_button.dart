import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_button_props.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Elevated button with a leading icon and optional text label.
class UIElevatedIconButton extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String? label;
  final Widget? labelChild;
  final Color? backgroundColor;
  final Color foregroundColor;
  final double? elevation;
  final double radius;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final UIMaterialButtonProps material;

  const UIElevatedIconButton({
    super.key,
    this.icon,
    this.iconWidget,
    this.label,
    this.labelChild,
    this.backgroundColor,
    required this.foregroundColor,
    this.elevation,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.radius = 16.0,
    this.material = const UIMaterialButtonProps(),
  }) : assert(
         labelChild != null || label != null,
         'Either label or labelChild must be provided.',
       );

  UIElevatedIconButton copyWith({
    Key? key,
    IconData? icon,
    Widget? iconWidget,
    String? label,
    Widget? labelChild,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    double? radius,
    UIMaterialButtonProps? material,
  }) {
    return UIElevatedIconButton(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      iconWidget: iconWidget ?? this.iconWidget,
      label: label ?? this.label,
      labelChild: labelChild ?? this.labelChild,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      elevation: elevation ?? this.elevation,
      onPressed: onPressed ?? this.onPressed,
      padding: padding ?? this.padding,
      radius: radius ?? this.radius,
      material: material ?? this.material,
    );
  }

  @override
  Widget build(BuildContext context) {
    final leadingIcon =
        iconWidget ??
        (icon != null
            ? Icon(icon, color: foregroundColor)
            : const SizedBox.shrink());
    final labelWidget = labelChild ?? UIText(label!, color: foregroundColor);

    return material.elevatedIcon(
      onPressed: onPressed,
      baseStyle: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        side: BorderSide(color: foregroundColor),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      icon: leadingIcon,
      label: labelWidget,
    );
  }
}
