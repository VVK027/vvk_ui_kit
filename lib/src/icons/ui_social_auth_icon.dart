import 'package:flutter/material.dart';

import 'ui_svg_image.dart';
import '../widgets/buttons/ui_social_auth_provider.dart';

import 'ui_social_auth_assets.dart';

/// Renders a provider brand icon from a package or host-app SVG asset.
///
/// Falls back to a Material [Icon] when the SVG cannot be loaded.
class UISocialAuthIcon extends StatelessWidget {
  const UISocialAuthIcon({
    super.key,
    required this.provider,
    this.size = 22,
    this.color,
    this.assetPath,
    this.fallbackIcon,
    this.usePackageAssets = true,
  });

  final UISocialAuthProvider provider;
  final double size;
  final Color? color;
  final String? assetPath;
  final IconData? fallbackIcon;
  final bool usePackageAssets;

  IconData get _fallbackIconData =>
      fallbackIcon ??
      switch (provider) {
        UISocialAuthProvider.google => Icons.g_mobiledata_rounded,
        UISocialAuthProvider.apple => Icons.apple,
        UISocialAuthProvider.facebook => Icons.facebook_rounded,
        UISocialAuthProvider.github => Icons.code_rounded,
        UISocialAuthProvider.microsoft => Icons.window_rounded,
        UISocialAuthProvider.twitter => Icons.tag_rounded,
        UISocialAuthProvider.linkedIn => Icons.work_outline_rounded,
        UISocialAuthProvider.email => Icons.mail_outline_rounded,
      };

  String get _resolvedAssetPath =>
      assetPath ??
      (usePackageAssets
          ? UISocialAuthAssets.packagePath(provider)
          : UISocialAuthAssets.hostAppPath(provider));

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color ?? Colors.white;
    final fallback = Icon(_fallbackIconData, size: size, color: iconColor);

    return UISvgImage.asset(
      source: _resolvedAssetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: iconColor,
      placeholder: () => fallback,
    );
  }
}
