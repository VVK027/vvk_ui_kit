import 'package:flutter/widgets.dart';

/// Limits stagger animations to only the first build frame.
///
/// Wrap your list or grid root with this to prevent re-animation on rebuild.
class UIAnimationLimiter extends StatefulWidget {
  const UIAnimationLimiter({super.key, required this.child});

  final Widget child;

  @override
  State<UIAnimationLimiter> createState() => _UIAnimationLimiterState();

  /// Returns whether animations should run for the nearest [UIAnimationLimiter].
  static bool? shouldRunAnimation(BuildContext context) => context
      .findAncestorWidgetOfExactType<_UIAnimationLimiterProvider>()
      ?.shouldRunAnimation;
}

class _UIAnimationLimiterState extends State<UIAnimationLimiter> {
  bool _shouldRunAnimation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shouldRunAnimation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _UIAnimationLimiterProvider(
      shouldRunAnimation: _shouldRunAnimation,
      child: widget.child,
    );
  }
}

class _UIAnimationLimiterProvider extends InheritedWidget {
  const _UIAnimationLimiterProvider({
    required this.shouldRunAnimation,
    required super.child,
  });

  final bool shouldRunAnimation;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
