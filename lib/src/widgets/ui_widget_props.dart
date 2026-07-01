import 'package:flutter/material.dart';

/// Reusable accessibility parameters shared across kit widgets.
///
/// Bundle screen-reader metadata once and forward it to any widget, keeping the
/// accessibility API consistent instead of each widget inventing its own
/// `semanticsLabel` / `semanticsHint` parameters.
///
/// ```dart
/// const props = UISemanticsProps(label: 'Save', hint: 'Saves the form');
/// props.wrap(child: myButton, enabled: true, button: true);
/// ```
@immutable
class UISemanticsProps {
  const UISemanticsProps({this.label, this.hint, this.button, this.enabled});

  /// Label announced by screen readers.
  final String? label;

  /// Hint describing the result of interacting with the widget.
  final String? hint;

  /// Whether the widget should be treated as a button.
  final bool? button;

  /// Whether the widget is currently enabled.
  final bool? enabled;

  /// Whether any semantic metadata is present.
  bool get isEmpty =>
      label == null && hint == null && button == null && enabled == null;

  UISemanticsProps copyWith({
    String? label,
    String? hint,
    bool? button,
    bool? enabled,
  }) {
    return UISemanticsProps(
      label: label ?? this.label,
      hint: hint ?? this.hint,
      button: button ?? this.button,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Wraps [child] in a [Semantics] node using these props (merged with any
  /// per-call overrides). Returns [child] unchanged when nothing is set.
  Widget wrap({required Widget child, bool? button, bool? enabled}) {
    final resolvedButton = button ?? this.button;
    final resolvedEnabled = enabled ?? this.enabled;
    if (label == null &&
        hint == null &&
        resolvedButton == null &&
        resolvedEnabled == null) {
      return child;
    }
    return Semantics(
      label: label,
      hint: hint,
      button: resolvedButton,
      enabled: resolvedEnabled,
      child: child,
    );
  }
}

/// Forwarded [Card] parameters for kit card wrappers.
@immutable
class UICardProps {
  const UICardProps({
    this.clipBehavior,
    this.shadowColor,
    this.surfaceTintColor,
    this.borderOnForeground,
    this.semanticContainer = true,
  });

  final Clip? clipBehavior;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool? borderOnForeground;
  final bool semanticContainer;

  UICardProps copyWith({
    Clip? clipBehavior,
    Color? shadowColor,
    Color? surfaceTintColor,
    bool? borderOnForeground,
    bool? semanticContainer,
  }) {
    return UICardProps(
      clipBehavior: clipBehavior ?? this.clipBehavior,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      borderOnForeground: borderOnForeground ?? this.borderOnForeground,
      semanticContainer: semanticContainer ?? this.semanticContainer,
    );
  }

  Card build({
    Key? key,
    required Widget child,
    Color? color,
    double? elevation,
    Clip? defaultClipBehavior,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
  }) {
    return Card(
      key: key,
      color: color,
      margin: margin,
      elevation: elevation,
      clipBehavior: clipBehavior ?? defaultClipBehavior ?? Clip.none,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      borderOnForeground: borderOnForeground ?? true,
      semanticContainer: semanticContainer,
      shape: shape,
      child: child,
    );
  }
}

/// Forwarded [Dialog] parameters for kit dialog wrappers.
@immutable
class UIDialogProps {
  const UIDialogProps({
    this.insetPadding,
    this.clipBehavior,
    this.shape,
    this.alignment,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
  });

  final EdgeInsets? insetPadding;
  final Clip? clipBehavior;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;

  UIDialogProps copyWith({
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
  }) {
    return UIDialogProps(
      insetPadding: insetPadding ?? this.insetPadding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      shape: shape ?? this.shape,
      alignment: alignment ?? this.alignment,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    );
  }

  Dialog build({
    Key? key,
    required Widget child,
    EdgeInsets? defaultInsetPadding,
    ShapeBorder? defaultShape,
    Color? defaultBackgroundColor,
  }) {
    return Dialog(
      key: key,
      insetPadding: insetPadding ?? defaultInsetPadding,
      clipBehavior: clipBehavior ?? Clip.none,
      shape: shape ?? defaultShape,
      alignment: alignment,
      backgroundColor: backgroundColor ?? defaultBackgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      child: child,
    );
  }
}

/// Forwarded [ListTile] parameters for kit list wrappers.
@immutable
class UIListTileProps {
  const UIListTileProps({
    this.contentPadding,
    this.dense,
    this.visualDensity,
    this.shape,
    this.style,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.leadingAndTrailingTextStyle,
    this.enabled,
    this.onTap,
    this.onLongPress,
    this.onFocusChange,
    this.mouseCursor,
    this.selected,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.hoverColor,
    this.splashColor,
    this.focusColor,
  });

  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;
  final VisualDensity? visualDensity;
  final ShapeBorder? shape;
  final ListTileStyle? style;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? leadingAndTrailingTextStyle;
  final bool? enabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final ValueChanged<bool>? onFocusChange;
  final MouseCursor? mouseCursor;
  final bool? selected;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? tileColor;
  final Color? selectedTileColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Color? focusColor;

  UIListTileProps copyWith({
    EdgeInsetsGeometry? contentPadding,
    bool? dense,
    VisualDensity? visualDensity,
    ShapeBorder? shape,
    ListTileStyle? style,
    Color? selectedColor,
    Color? iconColor,
    Color? textColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? leadingAndTrailingTextStyle,
    bool? enabled,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    ValueChanged<bool>? onFocusChange,
    MouseCursor? mouseCursor,
    bool? selected,
    FocusNode? focusNode,
    bool? autofocus,
    Color? tileColor,
    Color? selectedTileColor,
    Color? hoverColor,
    Color? splashColor,
    Color? focusColor,
  }) {
    return UIListTileProps(
      contentPadding: contentPadding ?? this.contentPadding,
      dense: dense ?? this.dense,
      visualDensity: visualDensity ?? this.visualDensity,
      shape: shape ?? this.shape,
      style: style ?? this.style,
      selectedColor: selectedColor ?? this.selectedColor,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      leadingAndTrailingTextStyle:
          leadingAndTrailingTextStyle ?? this.leadingAndTrailingTextStyle,
      enabled: enabled ?? this.enabled,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      onFocusChange: onFocusChange ?? this.onFocusChange,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      selected: selected ?? this.selected,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      tileColor: tileColor ?? this.tileColor,
      selectedTileColor: selectedTileColor ?? this.selectedTileColor,
      hoverColor: hoverColor ?? this.hoverColor,
      splashColor: splashColor ?? this.splashColor,
      focusColor: focusColor ?? this.focusColor,
    );
  }

  ListTile build({
    Key? key,
    Widget? leading,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    bool? isThreeLine,
  }) {
    return ListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: isThreeLine ?? false,
      contentPadding: contentPadding,
      dense: dense,
      visualDensity: visualDensity,
      shape: shape,
      style: style,
      selectedColor: selectedColor,
      iconColor: iconColor,
      textColor: textColor,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      leadingAndTrailingTextStyle: leadingAndTrailingTextStyle,
      enabled: enabled ?? true,
      onTap: onTap,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      mouseCursor: mouseCursor,
      selected: selected ?? false,
      focusNode: focusNode,
      autofocus: autofocus,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusColor: focusColor,
    );
  }
}

/// Forwarded [AppBar] parameters for kit app bar wrappers.
@immutable
class UIAppBarProps {
  const UIAppBarProps({
    this.actions,
    this.automaticallyImplyLeading,
    this.bottom,
    this.centerTitle,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary,
    this.titleSpacing,
    this.toolbarOpacity,
    this.bottomOpacity,
    this.leadingWidth,
    this.toolbarHeight,
    this.leading,
    this.flexibleSpace,
  });

  final List<Widget>? actions;
  final bool? automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool? primary;
  final double? titleSpacing;
  final double? toolbarOpacity;
  final double? bottomOpacity;
  final double? leadingWidth;
  final double? toolbarHeight;
  final Widget? leading;
  final Widget? flexibleSpace;

  UIAppBarProps copyWith({
    List<Widget>? actions,
    bool? automaticallyImplyLeading,
    PreferredSizeWidget? bottom,
    bool? centerTitle,
    double? elevation,
    double? scrolledUnderElevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? backgroundColor,
    Color? foregroundColor,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool? primary,
    double? titleSpacing,
    double? toolbarOpacity,
    double? bottomOpacity,
    double? leadingWidth,
    double? toolbarHeight,
    Widget? leading,
    Widget? flexibleSpace,
  }) {
    return UIAppBarProps(
      actions: actions ?? this.actions,
      automaticallyImplyLeading:
          automaticallyImplyLeading ?? this.automaticallyImplyLeading,
      bottom: bottom ?? this.bottom,
      centerTitle: centerTitle ?? this.centerTitle,
      elevation: elevation ?? this.elevation,
      scrolledUnderElevation:
          scrolledUnderElevation ?? this.scrolledUnderElevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      iconTheme: iconTheme ?? this.iconTheme,
      actionsIconTheme: actionsIconTheme ?? this.actionsIconTheme,
      primary: primary ?? this.primary,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      toolbarOpacity: toolbarOpacity ?? this.toolbarOpacity,
      bottomOpacity: bottomOpacity ?? this.bottomOpacity,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      leading: leading ?? this.leading,
      flexibleSpace: flexibleSpace ?? this.flexibleSpace,
    );
  }

  AppBar build({
    Key? key,
    required Widget title,
    bool? defaultCenterTitle,
    double? defaultElevation,
    Color? defaultBackgroundColor,
    Color? defaultForegroundColor,
  }) {
    return AppBar(
      key: key,
      title: title,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      bottom: bottom,
      centerTitle: centerTitle ?? defaultCenterTitle,
      elevation: elevation ?? defaultElevation,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      backgroundColor: backgroundColor ?? defaultBackgroundColor,
      foregroundColor: foregroundColor ?? defaultForegroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary ?? true,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity ?? 1.0,
      bottomOpacity: bottomOpacity ?? 1.0,
      leadingWidth: leadingWidth,
      toolbarHeight: toolbarHeight,
      leading: leading,
      flexibleSpace: flexibleSpace,
    );
  }
}
