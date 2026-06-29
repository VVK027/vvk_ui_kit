import 'dart:async';

import 'package:flutter/widgets.dart';

import 'ui_animation_limiter.dart';

/// Provides animation config (position, duration, delay, column count)
/// to descendant [UIAnimationConfigurator] widgets via [InheritedWidget].
class UIAnimationConfiguration extends InheritedWidget {
  const UIAnimationConfiguration._({
    super.key,
    required this.position,
    required this.duration,
    required this.delay,
    required this.columnCount,
    required super.child,
  });

  const UIAnimationConfiguration.synchronized({
    Key? key,
    Duration duration = const Duration(milliseconds: 225),
    required Widget child,
  }) : this._(
         key: key,
         position: 0,
         duration: duration,
         delay: Duration.zero,
         columnCount: 1,
         child: child,
       );

  /// Children animate with staggered delays based on list position.
  const UIAnimationConfiguration.staggeredList({
    Key? key,
    required int position,
    Duration duration = const Duration(milliseconds: 225),
    Duration? delay,
    required Widget child,
  }) : this._(
         key: key,
         position: position,
         duration: duration,
         delay: delay,
         columnCount: 1,
         child: child,
       );

  /// Children animate with staggered delays based on grid position.
  const UIAnimationConfiguration.staggeredGrid({
    Key? key,
    required int position,
    Duration duration = const Duration(milliseconds: 225),
    Duration? delay,
    required int columnCount,
    required Widget child,
  }) : this._(
         key: key,
         position: position,
         duration: duration,
         delay: delay,
         columnCount: columnCount,
         child: child,
       );

  final int position;
  final Duration duration;
  final Duration? delay;
  final int columnCount;

  /// Wraps each widget in [children] with a [staggeredList] configuration.
  static List<Widget> toStaggeredList({
    Duration duration = const Duration(milliseconds: 225),
    Duration? delay,
    required Widget Function(Widget) childAnimationBuilder,
    required List<Widget> children,
  }) => children.indexed
      .map(
        (entry) => UIAnimationConfiguration.staggeredList(
          position: entry.$1,
          duration: duration,
          delay: delay,
          child: childAnimationBuilder(entry.$2),
        ),
      )
      .toList();

  static UIAnimationConfiguration? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<UIAnimationConfiguration>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

/// Reads [UIAnimationConfiguration] from context and drives a controller.
class UIAnimationConfigurator extends StatelessWidget {
  const UIAnimationConfigurator({
    super.key,
    this.duration,
    this.delay,
    required this.animatedChildBuilder,
  });

  final Duration? duration;
  final Duration? delay;
  final Widget Function(Animation<double>) animatedChildBuilder;

  @override
  Widget build(BuildContext context) {
    final config = UIAnimationConfiguration.of(context);
    if (config == null) {
      throw FlutterError.fromParts([
        ErrorSummary('Animation not wrapped in a UIAnimationConfiguration.'),
        ErrorDescription(
          'Use a UI entrance animation only inside a UIAnimationConfiguration.',
        ),
        ErrorHint(
          'Wrap your animation(s) with UIAnimationConfiguration.synchronized, '
          'staggeredList, or staggeredGrid.',
        ),
      ]);
    }

    return _UIAnimationExecutor(
      duration: duration ?? config.duration,
      delay: _staggerDelay(
        position: config.position,
        duration: duration ?? config.duration,
        delay: delay ?? config.delay,
        columnCount: config.columnCount,
      ),
      builder: (_, controller) => animatedChildBuilder(controller!),
    );
  }

  static Duration _staggerDelay({
    required int position,
    required Duration duration,
    required Duration? delay,
    required int columnCount,
  }) {
    final delayMs = delay?.inMilliseconds ?? duration.inMilliseconds ~/ 6;
    final ms = columnCount > 1
        ? (position ~/ columnCount + position % columnCount) * delayMs
        : position * delayMs;
    return Duration(milliseconds: ms);
  }
}

class _UIAnimationExecutor extends StatefulWidget {
  const _UIAnimationExecutor({
    required this.duration,
    this.delay = Duration.zero,
    required this.builder,
  });

  final Duration duration;
  final Duration delay;
  final Widget Function(BuildContext, AnimationController?) builder;

  @override
  State<_UIAnimationExecutor> createState() => _UIAnimationExecutorState();
}

class _UIAnimationExecutorState extends State<_UIAnimationExecutor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    if (UIAnimationLimiter.shouldRunAnimation(context) ?? true) {
      _timer = Timer(widget.delay, _controller.forward);
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller),
    );
  }
}
