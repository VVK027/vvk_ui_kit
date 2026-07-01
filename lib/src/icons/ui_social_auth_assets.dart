import 'package:vvk_ui_kit/src/widgets/buttons/ui_social_auth_provider.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_social_auth_button.dart'
    show UISocialAuthButton;
import 'package:vvk_ui_kit/src/icons/ui_social_auth_icon.dart'
    show UISocialAuthIcon;

/// Default SVG asset paths for [UISocialAuthProvider] icons shipped with this package.
///
/// Host apps can override per-button via [UISocialAuthButton.iconAssetPath] or
/// [UISocialAuthIcon.assetPath].
abstract final class UISocialAuthAssets {
  static const String packageName = 'vvk_ui_kit';

  static const String socialIconsRoot =
      'packages/$packageName/assets/icons/social';

  static const Map<UISocialAuthProvider, String> fileNames = {
    UISocialAuthProvider.google: 'google',
    UISocialAuthProvider.apple: 'apple',
    UISocialAuthProvider.facebook: 'facebook',
    UISocialAuthProvider.github: 'github',
    UISocialAuthProvider.microsoft: 'microsoft',
    UISocialAuthProvider.twitter: 'twitter',
    UISocialAuthProvider.linkedIn: 'linkedin',
    UISocialAuthProvider.email: 'email',
  };

  /// Package-bundled SVG path for [provider].
  static String packagePath(UISocialAuthProvider provider) {
    final fileName = fileNames[provider];
    if (fileName == null) {
      throw ArgumentError('Unknown provider: $provider');
    }
    return '$socialIconsRoot/$fileName.svg';
  }

  /// Convention-based path for host-app assets (not bundled).
  static String hostAppPath(UISocialAuthProvider provider) {
    final fileName = fileNames[provider];
    if (fileName == null) {
      throw ArgumentError('Unknown provider: $provider');
    }
    return 'assets/icons/social/$fileName.svg';
  }
}
