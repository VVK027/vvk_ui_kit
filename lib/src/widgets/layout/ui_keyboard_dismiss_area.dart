import 'package:flutter/material.dart';

/// Wraps [child] and dismisses the keyboard when the user taps outside
/// focused text fields.
///
/// Place around screen bodies or form sections that should unfocus on tap.
class UIKeyboardDismissArea extends StatelessWidget {
  const UIKeyboardDismissArea({
    super.key,
    required this.child,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;

  /// How this widget participates in hit testing.
  final HitTestBehavior behavior;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
