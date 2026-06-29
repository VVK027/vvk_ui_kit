import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Interaction and style overrides forwarded to Material text-family buttons
/// ([TextButton], [OutlinedButton], [ElevatedButton]).
@immutable
class UIMaterialButtonProps {
  const UIMaterialButtonProps({
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.style,
  });

  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final ButtonStyle? style;

  UIMaterialButtonProps copyWith({
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    ButtonStyle? style,
  }) {
    return UIMaterialButtonProps(
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      statesController: statesController ?? this.statesController,
      style: style ?? this.style,
    );
  }

  ButtonStyle? mergeStyle(ButtonStyle? base) {
    if (style == null) return base;
    if (base == null) return style;
    return base.merge(style);
  }

  TextButton text({
    Key? key,
    required VoidCallback? onPressed,
    required ButtonStyle? baseStyle,
    required Widget child,
  }) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      style: mergeStyle(baseStyle),
      child: child,
    );
  }

  OutlinedButton outlined({
    Key? key,
    required VoidCallback? onPressed,
    required ButtonStyle baseStyle,
    required Widget child,
  }) {
    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      style: mergeStyle(baseStyle),
      child: child,
    );
  }

  ElevatedButton elevated({
    Key? key,
    required VoidCallback? onPressed,
    required ButtonStyle baseStyle,
    required Widget child,
  }) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      style: mergeStyle(baseStyle),
      child: child,
    );
  }

  ElevatedButton elevatedIcon({
    Key? key,
    required VoidCallback? onPressed,
    required ButtonStyle baseStyle,
    required Widget icon,
    required Widget label,
  }) {
    return ElevatedButton.icon(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      style: mergeStyle(baseStyle),
      icon: icon,
      label: label,
    );
  }
}

/// Interaction and layout overrides forwarded to [CupertinoButton].
@immutable
class UICupertinoButtonProps {
  const UICupertinoButtonProps({
    this.padding,
    this.minimumSize,
    this.pressedOpacity,
    this.alignment,
    this.focusNode,
    this.autofocus = false,
  });

  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final double? pressedOpacity;
  final AlignmentGeometry? alignment;
  final FocusNode? focusNode;
  final bool autofocus;

  UICupertinoButtonProps copyWith({
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    double? pressedOpacity,
    AlignmentGeometry? alignment,
    FocusNode? focusNode,
    bool? autofocus,
  }) {
    return UICupertinoButtonProps(
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      pressedOpacity: pressedOpacity ?? this.pressedOpacity,
      alignment: alignment ?? this.alignment,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
    );
  }

  CupertinoButton build({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? defaultPadding,
  }) {
    return CupertinoButton(
      key: key,
      onPressed: onPressed,
      padding: padding ?? defaultPadding ?? EdgeInsets.zero,
      minimumSize: minimumSize,
      pressedOpacity: pressedOpacity ?? 0.4,
      alignment: alignment ?? Alignment.center,
      focusNode: focusNode,
      autofocus: autofocus,
      child: child,
    );
  }
}

/// Interaction and style overrides forwarded to [IconButton].
@immutable
class UIIconButtonProps {
  const UIIconButtonProps({
    this.onLongPress,
    this.onHover,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.isSelected = false,
    this.selectedIcon,
    this.tooltip,
    this.statesController,
  });

  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isSelected;
  final Widget? selectedIcon;
  final String? tooltip;
  final WidgetStatesController? statesController;

  UIIconButtonProps copyWith({
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    bool? isSelected,
    Widget? selectedIcon,
    String? tooltip,
    WidgetStatesController? statesController,
  }) {
    return UIIconButtonProps(
      onLongPress: onLongPress ?? this.onLongPress,
      onHover: onHover ?? this.onHover,
      style: style ?? this.style,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      isSelected: isSelected ?? this.isSelected,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      tooltip: tooltip ?? this.tooltip,
      statesController: statesController ?? this.statesController,
    );
  }

  Widget build({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
  }) {
    return IconButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      isSelected: isSelected,
      selectedIcon: selectedIcon,
      statesController: statesController,
      tooltip: tooltip,
      icon: icon,
    );
  }
}
