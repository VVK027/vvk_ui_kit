import 'package:flutter/foundation.dart';

/// Web-safe platform detection using Flutter's compile-time target flags.
///
/// Prefer these getters over `dart:io` Platform checks so code works on web.
class PlatformUtil {
  PlatformUtil._();

  /// `true` when running on Android.
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;

  /// `true` when running on iOS.
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// `true` when running on Windows.
  static bool get isWindows => defaultTargetPlatform == TargetPlatform.windows;

  /// `true` when running on macOS.
  static bool get isMacOS => defaultTargetPlatform == TargetPlatform.macOS;

  /// `true` when running on Linux.
  static bool get isLinux => defaultTargetPlatform == TargetPlatform.linux;

  /// `true` when running on Fuchsia.
  static bool get isFuchsia => defaultTargetPlatform == TargetPlatform.fuchsia;

  /// `true` when compiled for web.
  static bool get isWeb => kIsWeb;

  /// `true` on Android or iOS (native mobile targets).
  static bool get isMobile => isAndroid || isIOS;

  /// `true` on Windows, macOS, or Linux (desktop targets).
  static bool get isDesktop => isWindows || isMacOS || isLinux;
}
