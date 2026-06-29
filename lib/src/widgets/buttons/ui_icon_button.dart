import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_button_props.dart';

/// A simple icon button wrapper around Material [IconButton].
class UIIconButton extends StatelessWidget {
  /// Creates a [UIIconButton].
  ///
  /// Provide [iconData] for the default [Icon], or pass a custom [icon] widget.
  const UIIconButton(
    this.iconData, {
    super.key,
    this.onPressed,
    this.iconSize,
    this.color = Colors.black,
    this.icon,
    this.props = const UIIconButtonProps(),
  });

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Color of the icon.
  final Color? color;

  /// The icon data to display when [icon] is not provided.
  final IconData iconData;

  /// Size of the icon.
  final double? iconSize;

  /// Custom icon widget. When provided, [iconData] is ignored.
  final Widget? icon;

  /// Forwarded [IconButton] interaction and style overrides.
  final UIIconButtonProps props;

  UIIconButton copyWith({
    Key? key,
    IconData? iconData,
    VoidCallback? onPressed,
    double? iconSize,
    Color? color,
    Widget? icon,
    UIIconButtonProps? props,
  }) {
    return UIIconButton(
      iconData ?? this.iconData,
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      iconSize: iconSize ?? this.iconSize,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      props: props ?? this.props,
    );
  }

  @override
  Widget build(BuildContext context) {
    return props.build(
      onPressed: onPressed ?? () {},
      icon: icon ?? Icon(iconData, size: iconSize, color: color),
    );
  }
}
