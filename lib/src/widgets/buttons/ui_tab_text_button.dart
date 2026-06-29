import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_button_props.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Text button styled for use inside tab bars or segmented controls.
class UITabTextButton extends StatelessWidget {
  final String title;
  final String value;
  final bool isActive;
  final bool isCompact;
  final VoidCallback? onPressed;
  final UIMaterialButtonProps material;

  const UITabTextButton({
    super.key,
    required this.title,
    required this.value,
    required this.isActive,
    this.isCompact = false,
    this.onPressed,
    this.material = const UIMaterialButtonProps(),
  });

  UITabTextButton copyWith({
    Key? key,
    String? title,
    String? value,
    bool? isActive,
    bool? isCompact,
    VoidCallback? onPressed,
    UIMaterialButtonProps? material,
  }) {
    return UITabTextButton(
      key: key ?? this.key,
      title: title ?? this.title,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
      isCompact: isCompact ?? this.isCompact,
      onPressed: onPressed ?? this.onPressed,
      material: material ?? this.material,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inactiveColor = colorScheme.onSurface;
    return material.text(
      onPressed: onPressed,
      baseStyle: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        foregroundColor: isActive ? Colors.white : inactiveColor,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 6 : 8,
          vertical: isCompact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                )
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UIText(
              title,
              color: isActive ? Colors.white : inactiveColor,
              fontWeight: FontWeight.w500,
              size: isCompact ? 12.0 : 14.0,
            ),
            SizedBox(width: isCompact ? 4 : 6),
            UIText(
              value,
              color: isActive ? Colors.white : inactiveColor,
              fontWeight: FontWeight.w600,
              size: isCompact ? 12.0 : 14.0,
            ),
          ],
        ),
      ),
    );
  }
}
