import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_button_props.dart';

/// A button that displays an image.
class UIImageButton extends StatelessWidget {
  /// Creates a [UIImageButton].
  const UIImageButton({
    super.key,
    required this.image,
    this.onPressed,
    this.material = const UIMaterialButtonProps(),
  });

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The image widget to display inside the button.
  final Widget image;

  /// Forwarded [TextButton] interaction and style overrides.
  final UIMaterialButtonProps material;

  UIImageButton copyWith({
    Key? key,
    Widget? image,
    VoidCallback? onPressed,
    UIMaterialButtonProps? material,
  }) {
    return UIImageButton(
      key: key ?? this.key,
      image: image ?? this.image,
      onPressed: onPressed ?? this.onPressed,
      material: material ?? this.material,
    );
  }

  @override
  Widget build(BuildContext context) {
    return material.text(
      onPressed: onPressed ?? () {},
      baseStyle: null,
      child: image,
    );
  }
}
