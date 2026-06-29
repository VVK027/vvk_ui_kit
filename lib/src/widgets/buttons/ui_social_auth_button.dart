import 'package:flutter/material.dart';

import 'package:vvk_ui_kit/src/icons/ui_social_auth_icon.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_social_auth_provider.dart';

export 'ui_social_auth_provider.dart';

/// Branded sign-in button for common OAuth providers.
///
/// Uses package SVG icons by default via [UISocialAuthIcon].
/// Pass [leading] to override the icon widget entirely.
class UISocialAuthButton extends StatelessWidget {
  const UISocialAuthButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.leading,
    this.iconAssetPath,
    this.useSvgIcons = true,
    this.usePackageAssets = true,
    this.height = 48,
    this.borderRadius = 8,
    this.enabled = true,
  });

  final UISocialAuthProvider provider;
  final VoidCallback? onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? leading;
  final String? iconAssetPath;
  final bool useSvgIcons;
  final bool usePackageAssets;
  final double height;
  final double borderRadius;
  final bool enabled;

  String get _defaultLabel => switch (provider) {
    UISocialAuthProvider.google => 'Continue with Google',
    UISocialAuthProvider.apple => 'Continue with Apple',
    UISocialAuthProvider.facebook => 'Continue with Facebook',
    UISocialAuthProvider.github => 'Continue with GitHub',
    UISocialAuthProvider.microsoft => 'Continue with Microsoft',
    UISocialAuthProvider.twitter => 'Continue with X',
    UISocialAuthProvider.linkedIn => 'Continue with LinkedIn',
    UISocialAuthProvider.email => 'Continue with Email',
  };

  (Color bg, Color fg) _colorsFor(UISocialAuthProvider p) => switch (p) {
    UISocialAuthProvider.google => (const Color(0xFF4285F4), Colors.white),
    UISocialAuthProvider.apple => (Colors.black, Colors.white),
    UISocialAuthProvider.facebook => (const Color(0xFF1877F2), Colors.white),
    UISocialAuthProvider.github => (const Color(0xFF24292F), Colors.white),
    UISocialAuthProvider.microsoft => (const Color(0xFF00A4EF), Colors.white),
    UISocialAuthProvider.twitter => (Colors.black, Colors.white),
    UISocialAuthProvider.linkedIn => (const Color(0xFF0A66C2), Colors.white),
    UISocialAuthProvider.email => (const Color(0xFF5F6368), Colors.white),
  };

  IconData _iconFor(UISocialAuthProvider p) => switch (p) {
    UISocialAuthProvider.google => Icons.g_mobiledata_rounded,
    UISocialAuthProvider.apple => Icons.apple,
    UISocialAuthProvider.facebook => Icons.facebook_rounded,
    UISocialAuthProvider.github => Icons.code_rounded,
    UISocialAuthProvider.microsoft => Icons.window_rounded,
    UISocialAuthProvider.twitter => Icons.tag_rounded,
    UISocialAuthProvider.linkedIn => Icons.work_outline_rounded,
    UISocialAuthProvider.email => Icons.mail_outline_rounded,
  };

  Widget _buildIcon(Color fg) {
    if (leading != null) return leading!;
    if (!useSvgIcons) {
      return Icon(_iconFor(provider), size: 22, color: fg);
    }
    return UISocialAuthIcon(
      provider: provider,
      size: 22,
      color: fg,
      assetPath: iconAssetPath,
      usePackageAssets: usePackageAssets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaults = _colorsFor(provider);
    final bg = backgroundColor ?? defaults.$1;
    final fg = foregroundColor ?? defaults.$2;
    final effectiveOnPressed = enabled ? onPressed : null;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: 0.5),
          disabledForegroundColor: fg.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: effectiveOnPressed,
        icon: _buildIcon(fg),
        label: Text(
          label ?? _defaultLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
