import 'package:flutter/material.dart';

/// Position checks for [Alignment] values.
///
/// Coordinate system: `x`/`y` range from `-1.0` (left/top) to `1.0` (right/bottom).
extension AlignmentExtension on Alignment {
  /// `true` when aligned toward the top (`y < 0`).
  bool get isTop => y < 0;

  /// `true` when aligned toward the bottom (`y > 0`).
  bool get isBottom => y > 0;

  /// `true` when vertically centered (`y == 0`).
  bool get isCenterVertical => y == 0;

  /// `true` when aligned toward the left (`x < 0`).
  bool get isLeft => x < 0;

  /// `true` when aligned toward the right (`x > 0`).
  bool get isRight => x > 0;

  /// `true` when horizontally centered (`x == 0`).
  bool get isCenterHorizontal => x == 0;
}
