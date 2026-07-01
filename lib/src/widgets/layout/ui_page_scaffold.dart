import 'package:flutter/material.dart';
import '../../core/theme/ui_breakpoints.dart';
import 'ui_scrollable_screen.dart';

/// Scaffold page with safe area, scrollable body, and optional max content width.
///
/// Similar to a centered app shell: full-width [topWidget], then scrollable
/// [body] constrained to [maxContentWidth].
class UIPageScaffold extends StatelessWidget {
  const UIPageScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.topWidget,
    this.maxContentWidth = UIBreakpoints.desktop,
    this.contentPadding = const EdgeInsets.all(16),
    this.removePadding = false,
    this.withRefresh = false,
    this.onRefresh,
    this.scrollPhysics,
    this.backgroundColor,
  }) : assert(!withRefresh || onRefresh != null);

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? topWidget;
  final double maxContentWidth;
  final EdgeInsetsGeometry contentPadding;
  final bool removePadding;
  final bool withRefresh;
  final Future<void> Function()? onRefresh;
  final ScrollPhysics? scrollPhysics;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final padding = removePadding ? EdgeInsets.zero : contentPadding;

    final content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(padding: padding, child: body),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ?topWidget,
            Expanded(
              child: UIScrollableScreen(
                physics: scrollPhysics,
                withRefresh: withRefresh,
                onRefresh: onRefresh,
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
