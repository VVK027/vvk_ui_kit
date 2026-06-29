import 'dart:async';

import 'package:flutter/material.dart';

/// Scroll behavior for [UIMarquee].
enum UIMarqueeMode {
  /// Scroll to the end, jump back to start, repeat.
  loop,

  /// Scroll to the end, then animate back to start.
  bounce,
}

/// Continuously scrolls overflowing [child] content horizontally or vertically.
class UIMarquee extends StatefulWidget {
  const UIMarquee({
    super.key,
    required this.child,
    this.direction = Axis.horizontal,
    this.textDirection,
    this.animationDuration = const Duration(seconds: 5),
    this.backDuration = const Duration(seconds: 5),
    this.pauseDuration = const Duration(seconds: 2),
    this.mode = UIMarqueeMode.bounce,
  });

  final Widget child;
  final Axis direction;
  final TextDirection? textDirection;
  final Duration animationDuration;
  final Duration backDuration;
  final Duration pauseDuration;
  final UIMarqueeMode mode;

  @override
  State<UIMarquee> createState() => _UIMarqueeState();
}

class _UIMarqueeState extends State<UIMarquee> {
  final ScrollController _controller = ScrollController();
  bool _running = true;
  Timer? _pauseTimer;
  Completer<void>? _pauseCompleter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runScrollLoop());
  }

  @override
  void dispose() {
    _running = false;
    _cancelPause();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pause(Duration duration) {
    if (!_running || !mounted) return Future<void>.value();
    _cancelPause();
    _pauseCompleter = Completer<void>();
    _pauseTimer = Timer(duration, () {
      if (!(_pauseCompleter?.isCompleted ?? true)) {
        _pauseCompleter!.complete();
      }
    });
    return _pauseCompleter!.future;
  }

  void _cancelPause() {
    _pauseTimer?.cancel();
    _pauseTimer = null;
    if (!(_pauseCompleter?.isCompleted ?? true)) {
      _pauseCompleter!.complete();
    }
    _pauseCompleter = null;
  }

  Future<void> _runScrollLoop() async {
    while (_running && mounted) {
      if (!_controller.hasClients) {
        await _pause(const Duration(milliseconds: 200));
        continue;
      }

      final position = _controller.position;
      if (position.maxScrollExtent <= 0) {
        await _pause(widget.pauseDuration);
        continue;
      }

      await _pause(widget.pauseDuration);
      if (!_running || !mounted || !_controller.hasClients) return;

      await _controller.animateTo(
        position.maxScrollExtent,
        duration: widget.animationDuration,
        curve: Curves.linear,
      );

      await _pause(widget.pauseDuration);
      if (!_running || !mounted || !_controller.hasClients) return;

      switch (widget.mode) {
        case UIMarqueeMode.loop:
          _controller.jumpTo(0);
        case UIMarqueeMode.bounce:
          await _controller.animateTo(
            0,
            duration: widget.backDuration,
            curve: Curves.linear,
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = SingleChildScrollView(
      scrollDirection: widget.direction,
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      child: widget.child,
    );

    if (widget.textDirection == null) return scrollView;
    return Directionality(
      textDirection: widget.textDirection!,
      child: scrollView,
    );
  }
}
