import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/color_extension.dart';

/// Helpers for system UI: status bar, navigation bar, overlays, and orientation.
class SystemUiUtils {
  SystemUiUtils._();

  /// Sets the status bar color and optional navigation bar styling.
  ///
  /// Icon brightness is inferred from [statusBarColor] unless overridden.
  /// Use [isTransparent] for a transparent status bar (Android).
  /// Pass [delayInMilliSeconds] to defer the update during transitions.
  static Future<void> setStatusBarColor(
    Color statusBarColor, {
    Color? systemNavigationBarColor,
    Brightness? statusBarBrightness,
    Brightness? statusBarIconBrightness,
    bool isTransparent = false,
    int delayInMilliSeconds = 0,
  }) async {
    if (delayInMilliSeconds > 0) {
      await Future.delayed(Duration(milliseconds: delayInMilliSeconds));
    }

    final iconBrightness =
        statusBarIconBrightness ?? _iconBrightnessFor(statusBarColor);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isTransparent ? Colors.transparent : statusBarColor,
        systemNavigationBarColor: systemNavigationBarColor,
        statusBarIconBrightness: iconBrightness,
        statusBarBrightness:
            statusBarBrightness ?? _statusBarBrightnessForIcons(iconBrightness),
      ),
    );
  }

  /// Sets matching status bar and navigation bar colors with auto icon contrast.
  static void setSystemUI(Color color, {bool isTransparent = false}) {
    final iconBrightness = _iconBrightnessFor(color);
    final barColor = isTransparent ? Colors.transparent : color;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: barColor,
        statusBarIconBrightness: iconBrightness,
        statusBarBrightness: _statusBarBrightnessForIcons(iconBrightness),
        systemNavigationBarColor: barColor,
        systemNavigationBarIconBrightness: iconBrightness,
      ),
    );
  }

  /// Transparent status bar; icon color inferred from [colorBehindStatusBar].
  static void setTransparentStatusBar(
    Color colorBehindStatusBar, {
    Brightness? forceBrightness,
  }) {
    final iconBrightness =
        forceBrightness ?? _iconBrightnessFor(colorBehindStatusBar);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
        statusBarBrightness: _statusBarBrightnessForIcons(iconBrightness),
      ),
    );
  }

  /// Light content on dark navigation bar; dark status bar icons.
  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// Dark content on light navigation bar; light status bar icons.
  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  /// Restores system UI to match the platform light/dark setting.
  static void resetSystemUI(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }

  /// Hides the status bar and navigation bar (fullscreen).
  static Future<void> hideStatusBar() {
    return SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }

  /// Restores the status bar and navigation bar.
  static Future<void> showStatusBar() {
    return SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Locks orientation to portrait.
  static void setOrientationPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  /// Locks orientation to landscape.
  static void setOrientationLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static Brightness _iconBrightnessFor(Color color) {
    return color.isDark ? Brightness.light : Brightness.dark;
  }

  /// iOS status bar brightness uses inverted semantics vs icon brightness.
  static Brightness _statusBarBrightnessForIcons(Brightness iconBrightness) {
    return iconBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
  }
}
