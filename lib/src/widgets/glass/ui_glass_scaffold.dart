import 'package:flutter/material.dart';
import 'ui_glass_surface.dart';
import 'ui_glass_theme.dart';

/// Scaffold with a gradient background and optional glass chrome wrappers.
///
/// Only navigation chrome is frosted — the [body] is not blurred for performance.
class UIGlassScaffold extends StatelessWidget {
  const UIGlassScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundGradient,
    this.glassTheme,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Gradient? backgroundGradient;
  final UIGlassTheme? glassTheme;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;

  factory UIGlassScaffold.fromTheme(
    BuildContext context, {
    Key? key,
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? drawer,
    Widget? endDrawer,
    Gradient? backgroundGradient,
    UIGlassTheme? glassTheme,
    bool extendBody = false,
    bool extendBodyBehindAppBar = false,
    bool? resizeToAvoidBottomInset,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UIGlassScaffold(
      key: key,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      glassTheme: glassTheme ?? UIGlassTheme.fromTheme(context),
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundGradient:
          backgroundGradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primary.withValues(alpha: 0.85),
              scheme.tertiary.withValues(alpha: 0.85),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? bottomBar = bottomNavigationBar;
    if (bottomBar != null) {
      bottomBar = UIGlassSurface(
        theme: glassTheme,
        borderRadius: 0,
        child: bottomBar,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        drawer: drawer,
        endDrawer: endDrawer,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
