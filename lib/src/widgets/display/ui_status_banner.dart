import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

/// Card-style status row with a leading widget, title, subtitle, and optional tap.
class UIStatusBanner extends StatelessWidget {
  /// Creates a [UIStatusBanner].
  const UIStatusBanner({
    super.key,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    required this.leading,
    this.trailing,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.listTile = const UIListTileProps(),
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       ),
       assert(
         subtitleChild != null || subtitle != null,
         'Either subtitle or subtitleChild must be provided.',
       );

  final String? title;
  final String? subtitle;
  final Widget? titleChild;
  final Widget? subtitleChild;
  final Widget leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;
  final UIListTileProps listTile;

  UIStatusBanner copyWith({
    Key? key,
    String? title,
    String? subtitle,
    Widget? titleChild,
    Widget? subtitleChild,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? margin,
    UIListTileProps? listTile,
  }) {
    return UIStatusBanner(
      key: key ?? this.key,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      titleChild: titleChild ?? this.titleChild,
      subtitleChild: subtitleChild ?? this.subtitleChild,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      onTap: onTap ?? this.onTap,
      margin: margin ?? this.margin,
      listTile: listTile ?? this.listTile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget = titleChild ?? UIText(title!);
    final subtitleWidget = subtitleChild ?? UIText(subtitle!);

    return RepaintBoundary(
      child: Card(
        margin: margin,
        child: listTile
            .copyWith(onTap: onTap)
            .build(
              leading: leading,
              title: titleWidget,
              subtitle: subtitleWidget,
              trailing: trailing,
            ),
      ),
    );
  }
}
