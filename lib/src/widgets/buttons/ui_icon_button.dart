import 'package:flutter/material.dart';
import 'ui_button_props.dart';

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
    this.color,
    this.icon,
    this.props = const UIIconButtonProps(),
    this.semanticsLabel,
    this.tooltip,
  });

  /// Callback when the button is pressed.
  ///
  /// When `null`, the button renders in its disabled state.
  final VoidCallback? onPressed;

  /// Color of the icon.
  ///
  /// Defaults to the ambient [IconTheme] color when `null`, so the icon adapts
  /// to light/dark themes automatically.
  final Color? color;

  /// The icon data to display when [icon] is not provided.
  final IconData iconData;

  /// Size of the icon.
  final double? iconSize;

  /// Custom icon widget. When provided, [iconData] is ignored.
  final Widget? icon;

  /// Forwarded [IconButton] interaction and style overrides.
  final UIIconButtonProps props;

  /// Accessibility label announced by screen readers for this icon-only button.
  ///
  /// Icon buttons have no visible text, so providing a [semanticsLabel] (or
  /// [tooltip]) is strongly recommended for accessibility.
  final String? semanticsLabel;

  /// Optional tooltip shown on long-press/hover. Also used as the semantics
  /// label when [semanticsLabel] is not provided.
  final String? tooltip;

  UIIconButton copyWith({
    Key? key,
    IconData? iconData,
    VoidCallback? onPressed,
    double? iconSize,
    Color? color,
    Widget? icon,
    UIIconButtonProps? props,
    String? semanticsLabel,
    String? tooltip,
  }) {
    return UIIconButton(
      iconData ?? this.iconData,
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      iconSize: iconSize ?? this.iconSize,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      props: props ?? this.props,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = props.build(
      onPressed: onPressed,
      icon: icon ?? Icon(iconData, size: iconSize, color: color),
    );

    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }

    final label = semanticsLabel ?? tooltip;
    if (label != null) {
      result = Semantics(
        button: true,
        enabled: onPressed != null,
        label: label,
        child: result,
      );
    }

    return result;
  }
}
