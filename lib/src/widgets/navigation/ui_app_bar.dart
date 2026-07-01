import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_image_button.dart';
import 'package:vvk_ui_kit/src/widgets/media/ui_image.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

/// Visual style variants for [UIAppBar].
enum UIAppBarVariant {
  /// Standard Material app bar.
  standard,

  /// Accent-colored header variant.
  accent,

  /// Brand header with logo and custom layout.
  brand,
}

/// Custom app bar with standard, accent, and brand layout variants.
class UIAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UIAppBar({
    super.key,
    this.variant = UIAppBarVariant.standard,
    this.titleWidget,
    this.titleChild,
    this.showBackButton,
    this.backIconPath,
    this.title,
    this.logoPath,
    this.actionWidgets,
    this.onBackPressed,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.fontSize,
    this.fontWeight,
    this.centerTitle = true,
    this.toolbarHeight = 70,
    this.accentColor,
    this.leading,
    this.actions = const [],
    this.onBack,
    this.bottom,
    this.appBarProps,
    this.backTooltip,
  });

  const UIAppBar.accent({
    Key? key,
    required String title,
    required Color accentColor,
    List<Widget> actions = const [],
    VoidCallback? onBack,
    PreferredSizeWidget? bottom,
    Widget? titleChild,
    UIAppBarProps? appBarProps,
    String? backTooltip,
  }) : this(
         key: key,
         variant: UIAppBarVariant.accent,
         title: title,
         titleChild: titleChild,
         accentColor: accentColor,
         actionWidgets: actions,
         onBack: onBack,
         bottom: bottom,
         appBarProps: appBarProps,
         backTooltip: backTooltip,
         centerTitle: true,
       );

  const UIAppBar.brand({
    Key? key,
    required String title,
    Widget? leading,
    List<Widget> actions = const [],
    Widget? titleChild,
    UIAppBarProps? appBarProps,
    String? backTooltip,
  }) : this(
         key: key,
         variant: UIAppBarVariant.brand,
         title: title,
         titleChild: titleChild,
         leading: leading,
         actionWidgets: actions,
         appBarProps: appBarProps,
         backTooltip: backTooltip,
         centerTitle: true,
       );

  final UIAppBarVariant variant;
  final Widget? titleWidget;
  final Widget? titleChild;
  final bool? showBackButton;
  final String? backIconPath;
  final String? title;
  final String? logoPath;
  final List<Widget>? actionWidgets;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool centerTitle;
  final double toolbarHeight;
  final Color? accentColor;
  final Widget? leading;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final PreferredSizeWidget? bottom;
  final UIAppBarProps? appBarProps;

  /// Tooltip / semantic label for the back button.
  ///
  /// When null, falls back to the locale-aware
  /// [MaterialLocalizations.backButtonTooltip].
  final String? backTooltip;

  UIAppBar copyWith({
    Key? key,
    UIAppBarVariant? variant,
    Widget? titleWidget,
    Widget? titleChild,
    bool? showBackButton,
    String? backIconPath,
    String? title,
    String? logoPath,
    List<Widget>? actionWidgets,
    VoidCallback? onBackPressed,
    Color? backgroundColor,
    Color? iconColor,
    Color? titleColor,
    double? fontSize,
    FontWeight? fontWeight,
    bool? centerTitle,
    double? toolbarHeight,
    Color? accentColor,
    Widget? leading,
    List<Widget>? actions,
    VoidCallback? onBack,
    PreferredSizeWidget? bottom,
    UIAppBarProps? appBarProps,
    String? backTooltip,
  }) {
    return UIAppBar(
      key: key ?? this.key,
      variant: variant ?? this.variant,
      titleWidget: titleWidget ?? this.titleWidget,
      titleChild: titleChild ?? this.titleChild,
      showBackButton: showBackButton ?? this.showBackButton,
      backIconPath: backIconPath ?? this.backIconPath,
      title: title ?? this.title,
      logoPath: logoPath ?? this.logoPath,
      actionWidgets: actionWidgets ?? this.actionWidgets,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      titleColor: titleColor ?? this.titleColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      centerTitle: centerTitle ?? this.centerTitle,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      accentColor: accentColor ?? this.accentColor,
      leading: leading ?? this.leading,
      actions: actions ?? this.actions,
      onBack: onBack ?? this.onBack,
      bottom: bottom ?? this.bottom,
      appBarProps: appBarProps ?? this.appBarProps,
      backTooltip: backTooltip ?? this.backTooltip,
    );
  }

  static Color contrastOn(Color background) {
    return background.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
  }

  @override
  Size get preferredSize {
    if (variant == UIAppBarVariant.accent) {
      final bottomHeight = bottom?.preferredSize.height ?? 0;
      return Size.fromHeight(kToolbarHeight + bottomHeight);
    }
    if (variant == UIAppBarVariant.brand) {
      return const Size.fromHeight(kToolbarHeight);
    }
    return Size.fromHeight(toolbarHeight);
  }

  Widget? _resolveTitle(
    BuildContext context, {
    Color? color,
    double? size,
    FontWeight? weight,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return titleChild ??
        titleWidget ??
        (title != null
            ? UIText(
                title!,
                size: size ?? fontSize,
                color: color ?? titleColor,
                fontWeight: weight ?? fontWeight,
                textAlign: textAlign ?? TextAlign.left,
                maxLines: maxLines,
                style: style,
              )
            : (logoPath != null
                  ? UIImage(logoPath!, width: 100, height: 30)
                  : null));
  }

  UIAppBarProps _mergedProps(UIAppBarProps defaults) {
    return (appBarProps ?? const UIAppBarProps()).copyWith(
      actions: appBarProps?.actions ?? defaults.actions,
      automaticallyImplyLeading:
          appBarProps?.automaticallyImplyLeading ??
          defaults.automaticallyImplyLeading,
      bottom: appBarProps?.bottom ?? defaults.bottom,
      centerTitle: appBarProps?.centerTitle ?? defaults.centerTitle,
      elevation: appBarProps?.elevation ?? defaults.elevation,
      scrolledUnderElevation:
          appBarProps?.scrolledUnderElevation ??
          defaults.scrolledUnderElevation,
      shadowColor: appBarProps?.shadowColor ?? defaults.shadowColor,
      surfaceTintColor:
          appBarProps?.surfaceTintColor ?? defaults.surfaceTintColor,
      backgroundColor: appBarProps?.backgroundColor ?? defaults.backgroundColor,
      foregroundColor: appBarProps?.foregroundColor ?? defaults.foregroundColor,
      iconTheme: appBarProps?.iconTheme ?? defaults.iconTheme,
      actionsIconTheme:
          appBarProps?.actionsIconTheme ?? defaults.actionsIconTheme,
      primary: appBarProps?.primary ?? defaults.primary,
      titleSpacing: appBarProps?.titleSpacing ?? defaults.titleSpacing,
      toolbarOpacity: appBarProps?.toolbarOpacity ?? defaults.toolbarOpacity,
      bottomOpacity: appBarProps?.bottomOpacity ?? defaults.bottomOpacity,
      leadingWidth: appBarProps?.leadingWidth ?? defaults.leadingWidth,
      toolbarHeight: appBarProps?.toolbarHeight ?? defaults.toolbarHeight,
      leading: appBarProps?.leading ?? defaults.leading,
      flexibleSpace: appBarProps?.flexibleSpace ?? defaults.flexibleSpace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      UIAppBarVariant.accent => _buildAccent(context),
      UIAppBarVariant.brand => _buildBrand(context),
      UIAppBarVariant.standard => _buildStandard(context),
    };
  }

  Widget _buildStandard(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final resolvedTitle = _resolveTitle(
      context,
      color: titleColor ?? Theme.of(context).colorScheme.onSurface,
      size: fontSize ?? 22,
      weight: fontWeight ?? FontWeight.w800,
      maxLines: 1,
    );

    return SafeArea(
      child:
          _mergedProps(
            UIAppBarProps(
              toolbarHeight: toolbarHeight,
              backgroundColor: bg,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: showBackButton == true,
              leading: showBackButton == true
                  ? Tooltip(
                      message:
                          backTooltip ??
                          MaterialLocalizations.of(context).backButtonTooltip,
                      child: UIImageButton(
                        image: backIconPath != null
                            ? UIImage(
                                backIconPath!,
                                width: 21,
                                height: 21,
                                fit: BoxFit.fill,
                                color: iconColor,
                              )
                            : Icon(
                                Icons.arrow_back_ios_new,
                                size: 21,
                                color:
                                    iconColor ??
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                        onPressed:
                            onBackPressed ?? () => Navigator.maybePop(context),
                      ),
                    )
                  : null,
              centerTitle: centerTitle,
              actions: actionWidgets,
            ),
          ).build(
            title: resolvedTitle ?? const SizedBox.shrink(),
            defaultElevation: 0,
          ),
    );
  }

  Widget _buildAccent(BuildContext context) {
    final color = accentColor ?? Theme.of(context).colorScheme.primary;
    final onBar = contrastOn(color);
    final resolvedTitle = _resolveTitle(
      context,
      color: onBar,
      size: 18,
      weight: FontWeight.w700,
      style: const TextStyle(letterSpacing: -0.2),
    );

    return _mergedProps(
      UIAppBarProps(
        elevation: 0,
        scrolledUnderElevation: 3,
        shadowColor: color.withValues(alpha: 0.35),
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip:
              backTooltip ??
              MaterialLocalizations.of(context).backButtonTooltip,
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: onBar, size: 20),
          onPressed:
              onBack ?? onBackPressed ?? () => Navigator.of(context).pop(),
        ),
        foregroundColor: onBar,
        iconTheme: IconThemeData(color: onBar),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, Color.lerp(color, Colors.black, 0.12)!],
            ),
          ),
        ),
        backgroundColor: color,
        actions: actionWidgets ?? actions,
        bottom: bottom,
      ),
    ).build(title: resolvedTitle ?? const SizedBox.shrink());
  }

  Widget _buildBrand(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final resolvedTitle = _resolveTitle(
      context,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    );

    return _mergedProps(
      UIAppBarProps(
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: centerTitle,
        automaticallyImplyLeading: false,
        leading: leading,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary.withValues(alpha: 0.08),
                theme.scaffoldBackgroundColor,
              ],
            ),
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        actions: actionWidgets ?? actions,
      ),
    ).build(
      title: resolvedTitle ?? const SizedBox.shrink(),
      defaultCenterTitle: centerTitle,
    );
  }
}


