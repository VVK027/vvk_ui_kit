/// Extensions for [Color] values and hex [String] parsing.
library;

import 'dart:ui' show Color;

import '../utils/log_util.dart';

/// Extensions for non-nullable [Color] values.
extension ColorExtensions on Color {
  /// Returns a copy with the given [opacity] applied to the alpha channel (0.0–1.0).
  Color withColorOpacity(double opacity) {
    return withValues(alpha: opacity.clamp(0.0, 1.0));
  }

  /// `true` when the alpha channel is zero.
  bool get isTransparent => a == 0.0;

  /// `true` when the alpha channel is fully opaque.
  bool get isOpaque => a == 1.0;

  /// `true` when perceived luminance is below 0.5 (suitable for light icons).
  bool get isDark => computeLuminance() < 0.5;

  /// `true` when perceived luminance is at or above 0.5.
  bool get isLight => !isDark;

  /// Calculates the contrast ratio between this color and [other] according to
  /// WCAG 2.0. The result is between 1.0 (no contrast) and 21.0 (max contrast).
  double contrastRatio(Color other) {
    final l1 = computeLuminance();
    final l2 = other.computeLuminance();
    final brightest = l1 > l2 ? l1 : l2;
    final darkest = l1 > l2 ? l2 : l1;
    return (brightest + 0.05) / (darkest + 0.05);
  }

  /// Returns this color as a hex string (e.g. `#FF112233`).
  ///
  /// Set [includeAlpha] to `false` to omit the alpha channel.
  /// Set [leadingHashSign] to `false` to omit the leading `#`.
  String toHex({bool includeAlpha = true, bool leadingHashSign = true}) {
    final buffer = StringBuffer(leadingHashSign ? '#' : '');
    if (includeAlpha) {
      buffer.write(a.toInt().toRadixString(16).padLeft(2, '0'));
    }
    buffer
      ..write(r.toInt().toRadixString(16).padLeft(2, '0'))
      ..write(g.toInt().toRadixString(16).padLeft(2, '0'))
      ..write(b.toInt().toRadixString(16).padLeft(2, '0'));
    return buffer.toString().toUpperCase();
  }
}

/// Extensions for nullable [Color] values.
extension ColorOrNullExtensions on Color? {
  /// Returns this color, or [value] when `null`.
  Color validate({Color value = const Color(0x00000000)}) => this ?? value;

  /// Applies [ColorExtensions.withColorOpacity] after resolving `null`.
  Color withColorOpacity(double opacity) =>
      validate().withColorOpacity(opacity);

  /// `true` when `null` or fully transparent.
  bool get isTransparent => this == null || validate().isTransparent;

  /// `true` when not `null` and fully opaque.
  bool get isOpaque => this != null && validate().isOpaque;

  /// Hex string for this color, or for [value] when `null`.
  String toHex({
    bool includeAlpha = true,
    bool leadingHashSign = true,
    Color value = const Color(0x00000000),
  }) => validate(
    value: value,
  ).toHex(includeAlpha: includeAlpha, leadingHashSign: leadingHashSign);
}

/// Parses hex color strings into [Color] values.
extension StringColorExtension on String {
  /// Parses `#RGB`, `#RRGGBB`, or `#AARRGGBB` (with or without `#`).
  ///
  /// Returns [defaultColor] when parsing fails.
  Color toColor({Color defaultColor = const Color(0x00000000)}) {
    try {
      var hex = replaceAll('#', '').trim();
      if (hex.length == 3) {
        hex = hex.split('').map((c) => '$c$c').join();
      }
      if (hex.length == 6) hex = 'FF$hex';
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      LogUtil.logDefaultMsg(
        'StringColorExtension',
        'toColor: parsing failed, $e',
      );
    }
    return defaultColor;
  }
}
