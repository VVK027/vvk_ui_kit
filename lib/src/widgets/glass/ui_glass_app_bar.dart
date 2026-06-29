import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_surface.dart';
import 'package:vvk_ui_kit/src/widgets/glass/ui_glass_theme.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// App bar with a frosted-glass background.
class UIGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UIGlassAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions = const [],
    this.theme,
    this.toolbarHeight = kToolbarHeight,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
  }) : assert(title != null || titleWidget != null);

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget> actions;
  final UIGlassTheme? theme;
  final double toolbarHeight;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  factory UIGlassAppBar.fromTheme(
    BuildContext context, {
    Key? key,
    String? title,
    Widget? titleWidget,
    Widget? leading,
    List<Widget> actions = const [],
    UIGlassTheme? theme,
    double toolbarHeight = kToolbarHeight,
    bool centerTitle = true,
    bool automaticallyImplyLeading = true,
  }) {
    return UIGlassAppBar(
      key: key,
      title: title,
      titleWidget: titleWidget,
      leading: leading,
      actions: actions,
      theme: theme ?? UIGlassTheme.fromTheme(context),
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground =
        theme?.foregroundColor ?? UIGlassTheme.fromTheme(context).foregroundColor;

    return UIGlassSurface(
      theme: theme,
      borderRadius: 0,
      height: toolbarHeight,
      child: AppBar(
        title: titleWidget ?? (title == null ? null : UIText(title!)),
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.transparent,
        foregroundColor: foreground ?? scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
