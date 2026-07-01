import 'package:flutter/material.dart';
import '../ui_widget_props.dart';

/// A styled card widget that provides consistent elevation and corner radius.
///
/// [UICard] is a wrapper around the Material [Card] widget with sensible
/// defaults aligned with the UI kit's design language.
class UICard extends StatelessWidget {
  /// The widget to display inside the card.
  final Widget child;

  /// Optional background color. Defaults to the theme's card color.
  final Color? color;

  /// Corner radius for the card. Defaults to 16.
  final double borderRadius;

  /// Elevation of the card.
  final double elevation;

  /// How to clip the card's content.
  final Clip clipBehavior;

  /// Outer margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Inner padding within the card.
  final EdgeInsetsGeometry? padding;

  /// Forwarded Card parameters such as shadowColor and surfaceTintColor.
  final UICardProps card;

  const UICard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = 16,
    this.elevation = 4.0,
    this.clipBehavior = Clip.antiAlias,
    this.margin,
    this.padding,
    this.card = const UICardProps(),
  });

  UICard copyWith({
    Key? key,
    Widget? child,
    Color? color,
    double? borderRadius,
    double? elevation,
    Clip? clipBehavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    UICardProps? card,
  }) {
    return UICard(
      key: key ?? this.key,
      color: color ?? this.color,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      card: card ?? this.card,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = padding == null
        ? child
        : Padding(padding: padding!, child: child);

    return card.build(
      key: key,
      color: color,
      margin: margin ?? EdgeInsets.zero,
      elevation: elevation,
      defaultClipBehavior: clipBehavior,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: content,
    );
  }
}
