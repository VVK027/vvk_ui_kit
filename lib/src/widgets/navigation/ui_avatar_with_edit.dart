import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Derives up to two uppercase initials from a display name.
String initialsFromName(String? name) {
  if (name == null || name.trim().isEmpty) return '';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '';
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

class UIAvatarWithEdit extends StatelessWidget {
  final Widget? image;
  final String? displayName;
  final String? initials;
  final String? editLabel;
  final double size;
  final bool showEditOverlay;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
  final Color? initialsColor;
  final Color? borderColor;
  final Color? editOverlayColor;
  final Color? editTextColor;

  const UIAvatarWithEdit({
    super.key,
    this.image,
    this.displayName,
    this.initials,
    this.editLabel,
    this.size = 150.0,
    this.showEditOverlay = false,
    this.onTap,
    this.gradientColors,
    this.initialsColor,
    this.borderColor,
    this.editOverlayColor,
    this.editTextColor,
  });

  String get _resolvedInitials => initials ?? initialsFromName(displayName);

  UIAvatarWithEdit copyWith({
    Key? key,
    Widget? image,
    String? displayName,
    String? initials,
    String? editLabel,
    double? size,
    bool? showEditOverlay,
    VoidCallback? onTap,
    List<Color>? gradientColors,
    Color? initialsColor,
    Color? borderColor,
    Color? editOverlayColor,
    Color? editTextColor,
  }) {
    return UIAvatarWithEdit(
      key: key ?? this.key,
      image: image ?? this.image,
      displayName: displayName ?? this.displayName,
      initials: initials ?? this.initials,
      editLabel: editLabel ?? this.editLabel,
      size: size ?? this.size,
      showEditOverlay: showEditOverlay ?? this.showEditOverlay,
      onTap: onTap ?? this.onTap,
      gradientColors: gradientColors ?? this.gradientColors,
      initialsColor: initialsColor ?? this.initialsColor,
      borderColor: borderColor ?? this.borderColor,
      editOverlayColor: editOverlayColor ?? this.editOverlayColor,
      editTextColor: editTextColor ?? this.editTextColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double radius = size / 2;
    final double fontSize = size >= 150 ? size / 3 : size / 2.4;
    final List<Color> resolvedGradient =
        gradientColors ??
        [colorScheme.primary.withValues(alpha: 0.55), colorScheme.primary];

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        onTap: onTap,
        child: Stack(
          children: [
            if (image != null)
              SizedBox(width: size, height: size, child: image)
            else
              Container(
                height: size,
                width: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: resolvedGradient,
                  ),
                  border: Border.all(
                    color:
                        borderColor ??
                        colorScheme.onPrimary.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.16),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: UIText(
                  _resolvedInitials,
                  size: fontSize,
                  color: initialsColor ?? colorScheme.onPrimary,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            if (showEditOverlay && editLabel != null)
              Positioned(
                bottom: 0,
                child: Container(
                  width: size,
                  height: 35,
                  alignment: Alignment.center,
                  color:
                      editOverlayColor ??
                      colorScheme.shadow.withValues(alpha: 0.35),
                  child: UIText(
                    editLabel!,
                    size: 16,
                    color: editTextColor ?? colorScheme.onPrimary,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
