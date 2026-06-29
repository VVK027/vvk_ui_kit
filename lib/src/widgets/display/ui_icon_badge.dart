import 'package:flutter/material.dart';

/// A circular or rounded container for an icon with an accent background.
class UIIconBadge extends StatelessWidget {
  /// Creates a [UIIconBadge].
  const UIIconBadge({
    super.key,
    required this.icon,
    required this.accentColor,
    this.size = 48,
  });

  /// The icon to display.
  final Widget icon;

  /// The accent color for the background and border.
  final Color accentColor;

  /// The diameter of the badge.
  final double size;

  UIIconBadge copyWith({
    Key? key,
    Widget? icon,
    Color? accentColor,
    double? size,
  }) {
    return UIIconBadge(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
      size: size ?? this.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.22)),
      ),
      alignment: Alignment.center,
      child: icon,
    );
  }
}
