import 'package:flutter/material.dart';

/// Compact theme switch — moon for dark mode, sun for light mode.
///
/// State (e.g. Riverpod, Provider, or setState) lives in the host app.
class UIThemeToggleButton extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  final String tooltipLightMode;
  final String tooltipDarkMode;

  const UIThemeToggleButton({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.tooltipLightMode,
    required this.tooltipDarkMode,
    this.size = 34,
    this.backgroundColor = const Color(0xFFF1F5F9),
    this.foregroundColor = const Color(0xFF0F172A),
    this.borderColor = const Color(0xFFDCE3F0),
  });

  UIThemeToggleButton copyWith({
    Key? key,
    ThemeMode? themeMode,
    ValueChanged<ThemeMode>? onThemeModeChanged,
    double? size,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    String? tooltipLightMode,
    String? tooltipDarkMode,
  }) {
    return UIThemeToggleButton(
      key: key ?? this.key,
      themeMode: themeMode ?? this.themeMode,
      onThemeModeChanged: onThemeModeChanged ?? this.onThemeModeChanged,
      size: size ?? this.size,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      tooltipLightMode: tooltipLightMode ?? this.tooltipLightMode,
      tooltipDarkMode: tooltipDarkMode ?? this.tooltipDarkMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;

    return Tooltip(
      message: isDark ? tooltipLightMode : tooltipDarkMode,
      child: IconButton(
        onPressed: () {
          onThemeModeChanged(isDark ? ThemeMode.light : ThemeMode.dark);
        },
        icon: Icon(
          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          size: 18,
        ),
        style: IconButton.styleFrom(
          minimumSize: Size(size, size),
          maximumSize: Size(size, size),
          fixedSize: Size(size, size),
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: const CircleBorder(),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
