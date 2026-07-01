import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ui_button_props.dart';
import '../text/ui_text.dart';

/// iOS-style text button — [CupertinoButton] on Apple platforms or
/// Material [TextButton] elsewhere.
class UICupertinoTextButton extends StatelessWidget {
  const UICupertinoTextButton({
    super.key,
    required this.onPressed,
    this.title,
    this.child,
    this.material = const UIMaterialButtonProps(),
    this.cupertino = const UICupertinoButtonProps(),
  }) : assert(
         child != null || title != null,
         'Either title or child must be provided.',
       );

  final VoidCallback onPressed;
  final String? title;
  final Widget? child;
  final UIMaterialButtonProps material;
  final UICupertinoButtonProps cupertino;

  UICupertinoTextButton copyWith({
    Key? key,
    VoidCallback? onPressed,
    String? title,
    Widget? child,
    UIMaterialButtonProps? material,
    UICupertinoButtonProps? cupertino,
  }) {
    return UICupertinoTextButton(
      key: key ?? this.key,
      onPressed: onPressed ?? this.onPressed,
      title: title ?? this.title,
      material: material ?? this.material,
      cupertino: cupertino ?? this.cupertino,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = child ?? UIText(title!);
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return cupertino.build(
        onPressed: onPressed,
        child: label,
        defaultPadding: EdgeInsets.zero,
      );
    }

    return material.text(
      onPressed: onPressed,
      baseStyle: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: label,
    );
  }
}
