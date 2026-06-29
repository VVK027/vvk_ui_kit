import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/navigation/ui_avatar_with_edit.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Default letter-to-color map for [UITextAvatar] backgrounds.
const Map<String, Color> kUITextAvatarLetterColors = {
  'a': Color.fromRGBO(226, 95, 81, 1),
  'b': Color.fromRGBO(242, 96, 145, 1),
  'c': Color.fromRGBO(187, 101, 202, 1),
  'd': Color.fromRGBO(149, 114, 207, 1),
  'e': Color.fromRGBO(120, 132, 205, 1),
  'f': Color.fromRGBO(91, 149, 249, 1),
  'g': Color.fromRGBO(72, 194, 249, 1),
  'h': Color.fromRGBO(69, 208, 226, 1),
  'i': Color.fromRGBO(38, 166, 154, 1),
  'j': Color.fromRGBO(82, 188, 137, 1),
  'k': Color.fromRGBO(155, 206, 95, 1),
  'l': Color.fromRGBO(212, 227, 74, 1),
  'm': Color.fromRGBO(254, 218, 16, 1),
  'n': Color.fromRGBO(247, 192, 0, 1),
  'o': Color.fromRGBO(255, 168, 0, 1),
  'p': Color.fromRGBO(255, 138, 96, 1),
  'q': Color.fromRGBO(194, 194, 194, 1),
  'r': Color.fromRGBO(143, 164, 175, 1),
  's': Color.fromRGBO(162, 136, 126, 1),
  't': Color.fromRGBO(163, 163, 163, 1),
  'u': Color.fromRGBO(175, 181, 226, 1),
  'v': Color.fromRGBO(179, 155, 221, 1),
  'w': Color.fromRGBO(194, 194, 194, 1),
  'x': Color.fromRGBO(124, 222, 235, 1),
  'y': Color.fromRGBO(188, 170, 164, 1),
  'z': Color.fromRGBO(173, 214, 125, 1),
};

/// Circular avatar showing initials derived from [name].
class UITextAvatar extends StatelessWidget {
  const UITextAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.uppercase = true,
    this.letterColors = kUITextAvatarLetterColors,
    this.onTap,
  });

  final String name;
  final double size;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final bool uppercase;
  final Map<String, Color> letterColors;
  final VoidCallback? onTap;

  String get _initials {
    final value = initialsFromName(name);
    if (value.isEmpty) return '';
    return uppercase ? value.toUpperCase() : value.toLowerCase();
  }

  Color _resolveBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    final key = name.trim().isEmpty ? '' : name.trim()[0].toLowerCase();
    return letterColors[key] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? size / 2;
    final fontSize = size >= 48 ? size * 0.36 : size * 0.42;

    final avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _resolveBackgroundColor(),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: UIText(
        _initials,
        maxLines: 1,
        style:
            textStyle ??
            theme.textTheme.titleMedium?.copyWith(
              color: foregroundColor ?? Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
      ),
    );

    if (onTap == null) return avatar;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: avatar,
      ),
    );
  }
}
