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
///
/// ## Capabilities & limitations
///
/// This is a **lightweight** SVG renderer built on the kit's own path parser —
/// not a full [`flutter_svg`](https://pub.dev/packages/flutter_svg) replacement.
/// It is tuned for simple, single-color icons (paths + basic shapes) such as
/// brand/monochrome glyphs. Complex SVGs — gradients, masks, filters, embedded
/// images, text nodes, or multi-color artwork — may render incorrectly or not
/// at all.
///
/// Choosing a renderer:
///
/// * **`UISvgAssetIcon`** — simple, uniformly tinted icons where you want zero
///   extra dependencies.
/// * **`UIImage` + `UIImageScope`** — everything else. Wire a `flutter_svg`
///   (or `cached_network_image`) builder through `UIImageScope` so `UIImage`
///   handles complex/remote SVGs, caching, and error states consistently.
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
