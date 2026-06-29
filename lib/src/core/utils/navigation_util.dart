import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/core/navigation/ui_page_transitions.dart';

/// Imperative navigation helpers using Flutter's [Navigator].
///
/// Works with [MaterialApp], [MaterialApp.router], and other widgets that
/// provide a [Navigator]. Named-route methods require [MaterialApp.routes] or
/// [MaterialApp.onGenerateRoute].
///
/// Example:
/// ```dart
/// // Named route (requires routes / onGenerateRoute)
/// NavigationUtil.push(context, '/settings', arguments: {'tab': 0});
///
/// // Widget route
/// NavigationUtil.pushPage(context, const SettingsScreen());
///
/// // Clear stack and go to login
/// NavigationUtil.pushReplaceUntil(context, '/login');
/// ```
class NavigationUtil {
  NavigationUtil._();

  // --- Widget routes ---------------------------------------------------------

  static Future<T?> pushPage<T>(
    BuildContext context,
    Widget page, {
    String? routeName,
    Object? arguments,
    bool fullscreenDialog = false,
    bool useRootNavigator = false,
    UIPageTransition transition = UIPageTransition.material,
    bool entranceVertical = true,
    bool entranceReverse = false,
    double entranceStartFrom = 0.25,
    double drillInBeginScale = 0.88,
    bool horizontalFromLeft = true,
  }) {
    return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
      _pageRoute<T>(
        builder: (_) => page,
        routeName: routeName,
        arguments: arguments,
        fullscreenDialog: fullscreenDialog,
        transition: transition,
        entranceVertical: entranceVertical,
        entranceReverse: entranceReverse,
        entranceStartFrom: entranceStartFrom,
        drillInBeginScale: drillInBeginScale,
        horizontalFromLeft: horizontalFromLeft,
      ),
    );
  }

  /// Pushes [page] with an entrance (slide + fade) transition.
  static Future<T?> pushPageWithEntrance<T>(
    BuildContext context,
    Widget page, {
    String? routeName,
    Object? arguments,
    bool fullscreenDialog = false,
    bool useRootNavigator = false,
    bool vertical = true,
    bool reverse = false,
    double startFrom = 0.25,
  }) {
    return pushPage<T>(
      context,
      page,
      routeName: routeName,
      arguments: arguments,
      fullscreenDialog: fullscreenDialog,
      useRootNavigator: useRootNavigator,
      transition: UIPageTransition.entrance,
      entranceVertical: vertical,
      entranceReverse: reverse,
      entranceStartFrom: startFrom,
    );
  }

  /// Pushes [page] with a drill-in (fade + scale) transition.
  static Future<T?> pushPageWithDrillIn<T>(
    BuildContext context,
    Widget page, {
    String? routeName,
    Object? arguments,
    bool fullscreenDialog = false,
    bool useRootNavigator = false,
    double beginScale = 0.88,
  }) {
    return pushPage<T>(
      context,
      page,
      routeName: routeName,
      arguments: arguments,
      fullscreenDialog: fullscreenDialog,
      useRootNavigator: useRootNavigator,
      transition: UIPageTransition.drillIn,
      drillInBeginScale: beginScale,
    );
  }

  static Future<T?> pushReplacementPage<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget page, {
    String? routeName,
    Object? arguments,
    TO? result,
    bool fullscreenDialog = false,
    bool useRootNavigator = false,
    UIPageTransition transition = UIPageTransition.material,
    bool entranceVertical = true,
    bool entranceReverse = false,
    double entranceStartFrom = 0.25,
    double drillInBeginScale = 0.88,
    bool horizontalFromLeft = true,
  }) {
    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).pushReplacement<T, TO>(
      _pageRoute<T>(
        builder: (_) => page,
        routeName: routeName,
        arguments: arguments,
        fullscreenDialog: fullscreenDialog,
        transition: transition,
        entranceVertical: entranceVertical,
        entranceReverse: entranceReverse,
        entranceStartFrom: entranceStartFrom,
        drillInBeginScale: drillInBeginScale,
        horizontalFromLeft: horizontalFromLeft,
      ),
      result: result,
    );
  }

  static Future<T?> pushPageAndRemoveUntil<T>(
    BuildContext context,
    Widget page,
    RoutePredicate predicate, {
    String? routeName,
    Object? arguments,
    bool fullscreenDialog = false,
    bool useRootNavigator = false,
    UIPageTransition transition = UIPageTransition.material,
    bool entranceVertical = true,
    bool entranceReverse = false,
    double entranceStartFrom = 0.25,
    double drillInBeginScale = 0.88,
    bool horizontalFromLeft = true,
  }) {
    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).pushAndRemoveUntil<T>(
      _pageRoute<T>(
        builder: (_) => page,
        routeName: routeName,
        arguments: arguments,
        fullscreenDialog: fullscreenDialog,
        transition: transition,
        entranceVertical: entranceVertical,
        entranceReverse: entranceReverse,
        entranceStartFrom: entranceStartFrom,
        drillInBeginScale: drillInBeginScale,
        horizontalFromLeft: horizontalFromLeft,
      ),
      predicate,
    );
  }

  /// Pops every route on the stack, then pushes [page] as the only route.
  static Future<T?> pushReplacementPageUntil<T>(
    BuildContext context,
    Widget page, {
    String? routeName,
    Object? arguments,
    bool fullscreenDialog = false,
    bool useRootNavigator = false,
  }) {
    return pushPageAndRemoveUntil<T>(
      context,
      page,
      (_) => false,
      routeName: routeName,
      arguments: arguments,
      fullscreenDialog: fullscreenDialog,
      useRootNavigator: useRootNavigator,
    );
  }

  // --- Named routes ----------------------------------------------------------

  static Future<T?> push<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool useRootNavigator = false,
  }) {
    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplace<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
    bool useRootNavigator = false,
  }) {
    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
    bool useRootNavigator = false,
  }) {
    return Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).pushNamedAndRemoveUntil<T>(routeName, predicate, arguments: arguments);
  }

  /// Pops every route on the stack, then pushes [routeName] as the only route.
  static Future<T?> pushReplaceUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool useRootNavigator = false,
  }) {
    return pushAndRemoveUntil<T>(
      context,
      routeName,
      (_) => false,
      arguments: arguments,
      useRootNavigator: useRootNavigator,
    );
  }

  // --- Pop -------------------------------------------------------------------

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  static Future<bool> maybePop<T>(BuildContext context, [T? result]) {
    return Navigator.of(context).maybePop<T>(result);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  static void popUntilPredicate(
    BuildContext context,
    RoutePredicate predicate,
  ) {
    Navigator.of(context).popUntil(predicate);
  }

  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  static Route<T> _pageRoute<T>({
    required WidgetBuilder builder,
    String? routeName,
    Object? arguments,
    bool fullscreenDialog = false,
    UIPageTransition transition = UIPageTransition.material,
    bool entranceVertical = true,
    bool entranceReverse = false,
    double entranceStartFrom = 0.25,
    double drillInBeginScale = 0.88,
    bool horizontalFromLeft = true,
  }) {
    final settings = RouteSettings(name: routeName, arguments: arguments);
    if (transition == UIPageTransition.material) {
      return MaterialPageRoute<T>(
        settings: settings,
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      );
    }
    return UIPageRoute<T>(
      settings: settings,
      builder: builder,
      fullscreenDialog: fullscreenDialog,
      transition: transition,
      entranceVertical: entranceVertical,
      entranceReverse: entranceReverse,
      entranceStartFrom: entranceStartFrom,
      drillInBeginScale: drillInBeginScale,
      horizontalFromLeft: horizontalFromLeft,
    );
  }
}
