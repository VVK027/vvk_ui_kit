import 'package:flutter/material.dart';

import '../icons/ui_svg_image.dart';

/// Renders an SVG asset using a lightweight custom painter.
///
/// The SVG file must be declared in the host app's or this package's
/// `pubspec.yaml` assets. Social brand icons ship under
/// `packages/vvk_ui_kit/assets/icons/social/`.
///
/// Example:
/// ```dart
/// UISvgAssetIcon(
///   assetPath: 'assets/icons/home.svg',
///   size: 32,
///   color: Colors.blue,
/// )
/// ```
class UISvgAssetIcon extends StatelessWidget {
  /// Creates a [UISvgAssetIcon].
  const UISvgAssetIcon({
    super.key,
    required this.assetPath,
    this.size = 24,
    this.color,
  });

  /// Path to the SVG asset in the host application.
  final String assetPath;

  /// Width and height of the icon.
  final double size;

  /// Color to tint the SVG path.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return UISvgImage.asset(
      source: assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color ?? IconTheme.of(context).color ?? Colors.white,
      placeholder: () => SizedBox(width: size, height: size),
    );
  }
}
