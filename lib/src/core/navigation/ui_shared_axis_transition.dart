import 'package:flutter/material.dart';

/// Direction axis for [UISharedAxisPageRoute].
enum UISharedAxis { horizontal, vertical, scaled }

/// Material Motion shared axis page transition route.
class UISharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  UISharedAxisPageRoute({
    required this.builder,
    this.axis = UISharedAxis.horizontal,
    this.forward = true,
    super.settings,
    Duration duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            );

            if (axis == UISharedAxis.scaled) {
              return ScaleTransition(
                scale: Tween<double>(begin: forward ? 0.92 : 1.08, end: 1.0)
                    .animate(curvedAnimation),
                child: FadeTransition(
                  opacity: curvedAnimation,
                  child: child,
                ),
              );
            }

            final beginOffset = axis == UISharedAxis.horizontal
                ? Offset(forward ? 0.15 : -0.15, 0.0)
                : Offset(0.0, forward ? 0.15 : -0.15);

            return SlideTransition(
              position: Tween<Offset>(begin: beginOffset, end: Offset.zero)
                  .animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );

  final WidgetBuilder builder;
  final UISharedAxis axis;
  final bool forward;
}
