import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Header row for `UICard` with title, optional "view all" action, and icon.
class UICardTopContainer extends StatelessWidget {
  final Color? color;
  final String? title;
  final Widget? titleChild;
  final bool isViewAll;
  final String? viewAllLabel;
  final Widget? viewAllChild;
  final IconData iconData;

  const UICardTopContainer({
    super.key,
    this.title,
    this.titleChild,
    required this.isViewAll,
    this.viewAllLabel,
    this.viewAllChild,
    this.color,
    required this.iconData,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       );

  UICardTopContainer copyWith({
    Key? key,
    Color? color,
    String? title,
    Widget? titleChild,
    bool? isViewAll,
    String? viewAllLabel,
    Widget? viewAllChild,
    IconData? iconData,
  }) {
    return UICardTopContainer(
      key: key ?? this.key,
      color: color ?? this.color,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      isViewAll: isViewAll ?? this.isViewAll,
      viewAllLabel: viewAllLabel ?? this.viewAllLabel,
      viewAllChild: viewAllChild ?? this.viewAllChild,
      iconData: iconData ?? this.iconData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          color: Colors.white,
          size: 16,
          fontWeight: FontWeight.w500,
        );
    final viewAllWidget =
        viewAllChild ??
        (viewAllLabel != null
            ? UIText(
                viewAllLabel!,
                color: Colors.white,
                size: 14,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              )
            : null);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: Colors.white),
              const SizedBox(width: 8),
              titleWidget,
            ],
          ),
          if (isViewAll && viewAllWidget != null) viewAllWidget,
        ],
      ),
    );
  }
}
