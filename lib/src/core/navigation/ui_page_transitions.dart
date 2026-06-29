import 'package:flutter/material.dart';

/// Built-in page transition styles for [NavigationUtil] and [UIPageRoute].
enum UIPageTransition {
  /// Platform default [MaterialPageRoute] transition.
  material,

  /// Slide up + fade — tab switches and top-level refreshes.
  entrance,

  /// Fade + scale in — drilling into detail screens.
  drillIn,

  /// Horizontal slide — sibling pages.
  horizontalSlide,
}

/// Slide + fade entrance transition inspired by Fluent entrance motion.
class UIEntrancePageTransition extends StatelessWidget {
  const UIEntrancePageTransition({
    super.key,
    required this.child,
    required this.animation,
    this.vertical = true,
    this.reverse = false,
    this.startFrom = 0.25,
  });

  final Widget child;
  final Animation<double> animation;
  final bool vertical;
  final bool reverse;
  final double startFrom;

  @override
  Widget build(BuildContext context) {
    final offset = animation.value + (reverse ? -startFrom : startFrom);
    return SlideTransition(
      position: Tween<Offset>(
        begin: vertical ? Offset(0, offset) : Offset(offset, 0),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

/// Fade + scale transition for hierarchical drill-in navigation.
class UIDrillInPageTransition extends StatelessWidget {
  const UIDrillInPageTransition({
    super.key,
    required this.child,
    required this.animation,
    this.beginScale = 0.88,
  });

  final Widget child;
  final Animation<double> animation;
  final double beginScale;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: beginScale, end: 1).animate(animation),
        child: child,
      ),
    );
  }
}

/// Horizontal slide for lateral sibling navigation.
class UIHorizontalSlidePageTransition extends StatelessWidget {
  const UIHorizontalSlidePageTransition({
    super.key,
    required this.child,
    required this.animation,
    this.fromLeft = true,
    this.distance = 0.65,
  });

  final Widget child;
  final Animation<double> animation;
  final bool fromLeft;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final begin = fromLeft
        ? Offset(-distance, 0)
        : Offset(distance, 0);
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: Offset.zero).animate(animation),
      child: child,
    );
  }
}

/// Material [PageRoute] with configurable [UIPageTransition] builders.
class UIPageRoute<T> extends MaterialPageRoute<T> {
  UIPageRoute({
    required super.builder,
    super.settings,
    super.fullscreenDialog,
    super.maintainState,
    super.allowSnapshotting,
    this.transition = UIPageTransition.material,
    this.entranceVertical = true,
    this.entranceReverse = false,
    this.entranceStartFrom = 0.25,
    this.drillInBeginScale = 0.88,
    this.horizontalFromLeft = true,
  });

  final UIPageTransition transition;
  final bool entranceVertical;
  final bool entranceReverse;
  final double entranceStartFrom;
  final double drillInBeginScale;
  final bool horizontalFromLeft;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return switch (transition) {
      UIPageTransition.material => super.buildTransitions(
          context,
          animation,
          secondaryAnimation,
          child,
        ),
      UIPageTransition.entrance => UIEntrancePageTransition(
          animation: animation,
          vertical: entranceVertical,
          reverse: entranceReverse,
          startFrom: entranceStartFrom,
          child: child,
        ),
      UIPageTransition.drillIn => UIDrillInPageTransition(
          animation: animation,
          beginScale: drillInBeginScale,
          child: child,
        ),
      UIPageTransition.horizontalSlide => UIHorizontalSlidePageTransition(
          animation: animation,
          fromLeft: horizontalFromLeft,
          child: child,
        ),
    };
  }
}
