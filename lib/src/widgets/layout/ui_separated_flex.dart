import 'package:flutter/material.dart';

/// Column of [children] with [separatorBuilder] between items.
class UISeparatedColumn extends StatelessWidget {
  const UISeparatedColumn({
    super.key,
    required this.separatorBuilder,
    this.children = const <Widget>[],
    this.includeFirstSeparator = false,
    this.includeLastSeparator = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });

  final IndexedWidgetBuilder separatorBuilder;
  final List<Widget> children;
  final bool includeFirstSeparator;
  final bool includeLastSeparator;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    return UISeparatedFlex(
      direction: Axis.vertical,
      separatorBuilder: separatorBuilder,
      includeFirstSeparator: includeFirstSeparator,
      includeLastSeparator: includeLastSeparator,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children,
    );
  }
}

/// Row of [children] with [separatorBuilder] between items.
class UISeparatedRow extends StatelessWidget {
  const UISeparatedRow({
    super.key,
    required this.separatorBuilder,
    this.children = const <Widget>[],
    this.includeFirstSeparator = false,
    this.includeLastSeparator = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });

  final IndexedWidgetBuilder separatorBuilder;
  final List<Widget> children;
  final bool includeFirstSeparator;
  final bool includeLastSeparator;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    return UISeparatedFlex(
      direction: Axis.horizontal,
      separatorBuilder: separatorBuilder,
      includeFirstSeparator: includeFirstSeparator,
      includeLastSeparator: includeLastSeparator,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children,
    );
  }
}

/// Shared implementation for [UISeparatedColumn] and [UISeparatedRow].
class UISeparatedFlex extends StatelessWidget {
  const UISeparatedFlex({
    super.key,
    required this.direction,
    required this.separatorBuilder,
    this.children = const <Widget>[],
    this.includeFirstSeparator = false,
    this.includeLastSeparator = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });

  final Axis direction;
  final IndexedWidgetBuilder separatorBuilder;
  final List<Widget> children;
  final bool includeFirstSeparator;
  final bool includeLastSeparator;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    final separatorStartIndex = includeFirstSeparator ? 1 : 0;

    if (children.isEmpty) {
      return direction == Axis.vertical
          ? Column(
              mainAxisSize: mainAxisSize,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              textDirection: textDirection,
              verticalDirection: verticalDirection,
              textBaseline: textBaseline,
              children: items,
            )
          : Row(
              mainAxisSize: mainAxisSize,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              textDirection: textDirection,
              verticalDirection: verticalDirection,
              textBaseline: textBaseline,
              children: items,
            );
    }

    if (includeFirstSeparator) {
      items.add(separatorBuilder(context, 0));
    }

    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      final isLast = i == children.length - 1;
      if (!isLast) {
        items.add(separatorBuilder(context, i + separatorStartIndex));
      } else if (includeLastSeparator) {
        items.add(separatorBuilder(context, children.length));
      }
    }

    if (direction == Axis.vertical) {
      return Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: items,
      );
    }

    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: items,
    );
  }
}
