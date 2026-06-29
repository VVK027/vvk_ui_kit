import 'dart:async';

import 'package:flutter/material.dart';

/// Prevents duplicate taps while an async [onTap] is running.
///
/// Pass the callback from [builder] to your button or ink well.
class UITapGuard extends StatefulWidget {
  const UITapGuard({
    super.key,
    required this.builder,
    this.onTap,
    this.cooldown,
    this.waitBuilder,
  });

  /// Disables further taps after one successful invocation.
  static const Duration never = Duration(days: 365000);

  final Widget Function(BuildContext context, Future<void> Function()? onTap)
  builder;

  final Future<void> Function()? onTap;

  /// Optional delay applied after [onTap] completes.
  final Duration? cooldown;

  /// Optional wrapper shown while the guarded action is running.
  final Widget Function(BuildContext context, Widget child)? waitBuilder;

  @override
  State<UITapGuard> createState() => _UITapGuardState();
}

class _UITapGuardState extends State<UITapGuard> {
  final _handler = _TapGuardHandler();

  @override
  void dispose() {
    _handler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _handler.busyStream,
      builder: (context, snapshot) {
        final isBusy = snapshot.data ?? false;

        if (!isBusy) {
          final onTap = widget.onTap;
          return widget.builder(
            context,
            onTap == null
                ? null
                : () => _handler.run(() async {
                    await onTap();
                    final cooldown = widget.cooldown;
                    if (cooldown != null) {
                      await Future<void>.delayed(cooldown);
                    }
                  }),
          );
        }

        final disabledChild = widget.builder(context, null);
        final waitBuilder = widget.waitBuilder;
        if (waitBuilder == null) return disabledChild;
        return waitBuilder(context, disabledChild);
      },
    );
  }
}

class _TapGuardHandler {
  _TapGuardHandler() : _controller = StreamController<bool>.broadcast() {
    _controller.add(false);
  }

  final StreamController<bool> _controller;

  Stream<bool> get busyStream => _controller.stream;

  Future<void> run(Future<void> Function() action) async {
    if (_controller.isClosed) return;
    _controller.add(true);
    try {
      await action();
    } finally {
      if (!_controller.isClosed) {
        _controller.add(false);
      }
    }
  }

  void dispose() => _controller.close();
}
