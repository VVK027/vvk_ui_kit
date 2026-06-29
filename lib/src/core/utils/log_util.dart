import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Utility class for logging messages to the console.
class LogUtil {
  /// Logs a default message using [debugPrint].
  static void logDefaultMsg(String tag, dynamic data) {
    if (kDebugMode) {
      debugPrint("$tag $data");
    }
  }

  /// Logs a message, optionally using [log] for longer strings.
  ///
  /// Only logs when [kDebugMode] is true.
  static void logMsg(String tag, dynamic data, [bool isLongerMsg = false]) {
    if (kDebugMode && isLongerMsg) {
      log("$tag $data");
    } else if (kDebugMode) {
      debugPrint("$tag $data");
    }
  }
}
