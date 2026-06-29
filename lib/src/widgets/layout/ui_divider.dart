import 'package:flutter/material.dart';

/// Horizontal or vertical divider with kit-consistent spacing defaults.
class UIDivider extends StatelessWidget {
  final double? width;
  final Color color;

  const UIDivider({super.key, required this.color, this.width});

  UIDivider copyWith({Key? key, double? width, Color? color}) {
    return UIDivider(
      key: key ?? this.key,
      width: width ?? this.width,
      color: color ?? this.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width / 1.25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Divider(height: 3.5, thickness: 3, color: color),
      ),
    );
  }
}
