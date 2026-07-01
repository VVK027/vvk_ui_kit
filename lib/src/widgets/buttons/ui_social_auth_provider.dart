import 'package:vvk_ui_kit/src/widgets/buttons/ui_social_auth_button.dart'
    show UISocialAuthButton;
import 'package:vvk_ui_kit/src/icons/ui_social_auth_icon.dart'
    show UISocialAuthIcon;

/// Supported OAuth / identity providers for [UISocialAuthButton] and
/// [UISocialAuthIcon].
///
/// Each provider maps to a bundled SVG under
/// `packages/vvk_ui_kit/assets/icons/social/` via
/// `UISocialAuthAssets.packagePath`.
enum UISocialAuthProvider {
  /// Google sign-in.
  google,

  /// Apple sign-in.
  apple,

  /// Facebook sign-in.
  facebook,

  /// GitHub sign-in.
  github,

  /// Microsoft sign-in.
  microsoft,

  /// Twitter / X sign-in.
  twitter,

  /// LinkedIn sign-in.
  linkedIn,

  /// Email / magic-link sign-in.
  email,
}
