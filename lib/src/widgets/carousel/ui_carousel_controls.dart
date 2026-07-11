import 'package:flutter/material.dart';

/// Color tokens for [UICarouselControls] navigation and indicators.
@immutable
class UICarouselControlsColors {
  final Color navBackground;
  final Color navBorder;
  final Color navBorderActive;
  final Color navIcon;
  final Color navIconDisabled;
  final Color indicatorActive;
  final Color indicatorInactive;
  final Color accent;

  const UICarouselControlsColors({
    this.navBackground = const Color(0xFFFFFFFF),
    this.navBorder = const Color(0xFFCBD5E1),
    this.navBorderActive = const Color(0xFF6366F1),
    this.navIcon = const Color(0xFF334155),
    this.navIconDisabled = const Color(0xFF94A3B8),
    this.indicatorActive = const Color(0xFF6366F1),
    this.indicatorInactive = const Color(0xFFCBD5E1),
    this.accent = const Color(0xFF4F46E5),
  });

  /// Derives carousel control colors from the ambient [Theme].
  ///
  /// Maps nav surfaces to the card/divider colors, and active borders,
  /// indicators, and glow to the color scheme's primary, so carousels match
  /// the rest of the kit's theme-first widgets in both light and dark mode.
  factory UICarouselControlsColors.fromTheme(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return UICarouselControlsColors(
      navBackground: theme.cardColor,
      navBorder: theme.dividerColor,
      navBorderActive: scheme.primary,
      navIcon: scheme.onSurface,
      navIconDisabled: scheme.onSurface.withValues(alpha: 0.38),
      indicatorActive: scheme.primary,
      indicatorInactive: theme.dividerColor,
      accent: scheme.primary,
    );
  }

  UICarouselControlsColors copyWith({
    Color? navBackground,
    Color? navBorder,
    Color? navBorderActive,
    Color? navIcon,
    Color? navIconDisabled,
    Color? indicatorActive,
    Color? indicatorInactive,
    Color? accent,
  }) {
    return UICarouselControlsColors(
      navBackground: navBackground ?? this.navBackground,
      navBorder: navBorder ?? this.navBorder,
      navBorderActive: navBorderActive ?? this.navBorderActive,
      navIcon: navIcon ?? this.navIcon,
      navIconDisabled: navIconDisabled ?? this.navIconDisabled,
      indicatorActive: indicatorActive ?? this.indicatorActive,
      indicatorInactive: indicatorInactive ?? this.indicatorInactive,
      accent: accent ?? this.accent,
    );
  }
}

/// Prev/next buttons and page indicators for carousels.
class UICarouselControls extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final bool loop;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<int> onPageSelected;
  final UICarouselControlsColors? colors;

  const UICarouselControls({
    super.key,
    required this.pageCount,
    required this.currentPage,
    this.loop = false,
    required this.onPrevious,
    required this.onNext,
    required this.onPageSelected,
    this.colors = const UICarouselControlsColors(),
  });

  UICarouselControls copyWith({
    Key? key,
    int? pageCount,
    int? currentPage,
    bool? loop,
    VoidCallback? onPrevious,
    VoidCallback? onNext,
    ValueChanged<int>? onPageSelected,
    UICarouselControlsColors? colors,
  }) {
    return UICarouselControls(
      key: key ?? this.key,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
      loop: loop ?? this.loop,
      onPrevious: onPrevious ?? this.onPrevious,
      onNext: onNext ?? this.onNext,
      onPageSelected: onPageSelected ?? this.onPageSelected,
      colors: colors ?? this.colors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = loop || currentPage > 0;
    final canGoForward = loop || currentPage < pageCount - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UICarouselNavButton(
          icon: Icons.chevron_left_rounded,
          enabled: canGoBack,
          highlighted: canGoBack,
          onPressed: canGoBack ? onPrevious : null,
          colors: colors,
        ),
        const SizedBox(width: 16),
        UICarouselPageIndicators(
          pageCount: pageCount,
          currentPage: currentPage,
          onPageSelected: onPageSelected,
          colors: colors,
        ),
        const SizedBox(width: 16),
        UICarouselNavButton(
          icon: Icons.chevron_right_rounded,
          enabled: canGoForward,
          highlighted: canGoForward,
          onPressed: canGoForward ? onNext : null,
          colors: colors,
        ),
      ],
    );
  }
}

/// Circular prev/next control for [UICarouselControls].
class UICarouselNavButton extends StatelessWidget {
  final IconData icon;
  final Widget? iconWidget;
  final bool enabled;
  final bool highlighted;
  final VoidCallback? onPressed;
  final UICarouselControlsColors? colors;

  const UICarouselNavButton({
    super.key,
    required this.icon,
    this.iconWidget,
    required this.enabled,
    required this.highlighted,
    required this.onPressed,
    this.colors = const UICarouselControlsColors(),
  });

  UICarouselNavButton copyWith({
    Key? key,
    IconData? icon,
    Widget? iconWidget,
    bool? enabled,
    bool? highlighted,
    VoidCallback? onPressed,
    UICarouselControlsColors? colors,
  }) {
    return UICarouselNavButton(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      iconWidget: iconWidget ?? this.iconWidget,
      enabled: enabled ?? this.enabled,
      highlighted: highlighted ?? this.highlighted,
      onPressed: onPressed ?? this.onPressed,
      colors: colors ?? this.colors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = colors ?? const UICarouselControlsColors();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.navBackground,
            border: Border.all(
              color: highlighted ? palette.navBorderActive : palette.navBorder,
              width: 1.2,
            ),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: palette.accent.withValues(alpha: 0.25),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child:
              iconWidget ??
              Icon(
                icon,
                color: enabled ? palette.navIcon : palette.navIconDisabled,
                size: 22,
              ),
        ),
      ),
    );
  }
}

/// Dot indicators showing the active page in a carousel.
class UICarouselPageIndicators extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final ValueChanged<int> onPageSelected;
  final UICarouselControlsColors? colors;

  const UICarouselPageIndicators({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.onPageSelected,
    this.colors = const UICarouselControlsColors(),
  });

  UICarouselPageIndicators copyWith({
    Key? key,
    int? pageCount,
    int? currentPage,
    ValueChanged<int>? onPageSelected,
    UICarouselControlsColors? colors,
  }) {
    return UICarouselPageIndicators(
      key: key ?? this.key,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
      onPageSelected: onPageSelected ?? this.onPageSelected,
      colors: colors ?? this.colors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = colors ?? const UICarouselControlsColors();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
          child: GestureDetector(
            onTap: () => onPageSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isActive ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isActive
                    ? palette.indicatorActive
                    : palette.indicatorInactive,
              ),
            ),
          ),
        );
      }),
    );
  }
}
