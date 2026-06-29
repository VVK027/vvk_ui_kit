import 'package:flutter/material.dart';

/// Desktop breakpoint (width in logical pixels).
const int desktopWidth = 1024;

/// Tablet breakpoint (width in logical pixels).
const int tabletWidth = 768;

/// Mobile breakpoint (width in logical pixels).
const int mobileWidth = 600;

/// Minimum mobile width breakpoint.
const int mobileLowestWidth = 320;

/// Information about the current device's screen size and form factor.
@immutable
class Responsive {
  /// The absolute size of the screen.
  final Size size;

  /// Whether the device is considered a mobile phone.
  final bool isMobile;

  /// Whether the device is a small tablet.
  final bool isSmallerTablet;

  /// Whether the device is a tablet.
  final bool isTablet;

  /// Whether the device is a desktop.
  final bool isDesktop;

  /// Creates a [Responsive] instance.
  const Responsive({
    required this.size,
    required this.isMobile,
    required this.isSmallerTablet,
    required this.isTablet,
    required this.isDesktop,
  });

  /// Convenience getter for mobile or small tablet.
  bool get isMobileOrSmallerTablet => isMobile || isSmallerTablet;

  /// Creates a [Responsive] instance from the given [context].
  factory Responsive.fromContext(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double w = size.width;
    return Responsive(
      size: size,
      isMobile: w <= mobileWidth,
      isSmallerTablet: w >= mobileWidth && w < tabletWidth,
      isTablet: w >= mobileWidth && w < desktopWidth,
      isDesktop: w >= desktopWidth,
    );
  }

  /// Retrieves the [Responsive] data from the nearest [ResponsiveScope].
  static Responsive of(BuildContext context) {
    final ResponsiveScope? scope = context
        .dependOnInheritedWidgetOfExactType<ResponsiveScope>();
    return scope?.data ?? Responsive.fromContext(context);
  }

  /// Returns true if the current context is mobile.
  static bool isMobileContext(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= mobileWidth;

  /// Returns true if the current context is a smaller tablet.
  static bool isSmallerTabletContext(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    return w >= mobileWidth && w < tabletWidth;
  }

  /// Returns true if the current context is a tablet.
  static bool isTabletContext(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    return w >= mobileWidth && w < desktopWidth;
  }

  /// Returns true if the current context is desktop.
  static bool isDesktopContext(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopWidth;
}

/// An [InheritedWidget] that provides [Responsive] data to its descendants.
class ResponsiveScope extends InheritedWidget {
  /// Creates a [ResponsiveScope].
  const ResponsiveScope({super.key, required this.data, required super.child});

  /// The responsive data to provide.
  final Responsive data;

  @override
  bool updateShouldNotify(covariant ResponsiveScope oldWidget) {
    return oldWidget.data.size != data.size;
  }
}

/// A provider widget that automatically calculates and provides [Responsive] data.
class ResponsiveProvider extends StatelessWidget {
  /// Creates a [ResponsiveProvider].
  const ResponsiveProvider({super.key, required this.child});

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScope(data: Responsive.fromContext(context), child: child);
  }
}

/// Picks [mobile], [tablet], or [desktop] based on viewport width.
class ResponsiveLayout extends StatelessWidget {
  /// Creates a [ResponsiveLayout].
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    this.useLayoutBuilder = false,
  });

  /// Widget to show on mobile.
  final Widget mobile;

  /// Widget to show on tablet.
  final Widget tablet;

  /// Widget to show on desktop.
  final Widget desktop;

  /// When true, uses [LayoutBuilder] constraints instead of [MediaQuery].
  final bool useLayoutBuilder;

  @override
  Widget build(BuildContext context) {
    if (useLayoutBuilder) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= desktopWidth) {
            return desktop;
          }
          if (constraints.maxWidth >= tabletWidth) {
            return tablet;
          }
          return mobile;
        },
      );
    }

    if (Responsive.isDesktopContext(context)) {
      return desktop;
    }
    if (Responsive.isTabletContext(context)) {
      return tablet;
    }
    return mobile;
  }
}
