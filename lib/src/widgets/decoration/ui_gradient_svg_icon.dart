import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/icons/ui_svg_image.dart';

/// An SVG icon that renders with a gradient fill.
class UIGradientSvgIcon extends StatelessWidget {
  /// Creates a [UIGradientSvgIcon].
  const UIGradientSvgIcon({
    required this.assetName,
    required this.gradient,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.blendMode = BlendMode.srcIn,
  });

  /// The asset path of the SVG.
  final String assetName;

  /// Optional width for the icon.
  final double? width;

  /// Optional height for the icon.
  final double? height;

  /// How the SVG should be fitted into the box.
  final BoxFit fit;

  /// The gradient to apply to the icon.
  final Gradient gradient;

  /// The blend mode to use when applying the gradient.
  final BlendMode blendMode;

  UIGradientSvgIcon copyWith({
    Key? key,
    String? assetName,
    double? width,
    double? height,
    BoxFit? fit,
    Gradient? gradient,
    BlendMode? blendMode,
  }) {
    return UIGradientSvgIcon(
      key: key ?? this.key,
      assetName: assetName ?? this.assetName,
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      gradient: gradient ?? this.gradient,
      blendMode: blendMode ?? this.blendMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: gradient.createShader,
      blendMode: blendMode,
      child: UISvgImage.asset(
        source: assetName,
        width: width,
        height: height,
        fit: fit,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
