import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Requires two back presses within [interval] before invoking [onExit].
///
/// Wrap a root screen to show a reminder on the first press. On the second
/// press within the interval, [onExit] is called. When [onExit] is null,
/// [SystemNavigator.pop] is used (typical Android exit behavior).
class UIDoubleBackToExit extends StatefulWidget {
  const UIDoubleBackToExit({
    super.key,
    required this.child,
    this.message = 'Press back again to exit',
    this.interval = const Duration(seconds: 2),
    this.onExit,
    this.onFirstPress,
  });

  final Widget child;
  final String message;
  final Duration interval;
  final VoidCallback? onExit;

  /// Called on the first back press while waiting for confirmation.
  final VoidCallback? onFirstPress;

  @override
  State<UIDoubleBackToExit> createState() => _UIDoubleBackToExitState();
}

class _UIDoubleBackToExitState extends State<UIDoubleBackToExit> {
  DateTime? _lastBackPress;

  void _showReminder() {
    widget.onFirstPress?.call();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(widget.message),
          duration: widget.interval,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _confirmExit() {
    if (widget.onExit != null) {
      widget.onExit!();
      return;
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        final lastPress = _lastBackPress;

        if (lastPress == null || now.difference(lastPress) > widget.interval) {
          _lastBackPress = now;
          _showReminder();
          return;
        }

        _confirmExit();
      },
      child: widget.child,
    );
  }
}
