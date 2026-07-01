import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Expandable floating panel that grows from a corner action button.
///
/// Collapsed state shows only [toggleIconBuilder]; expanded state reveals
/// [title] and [child] inside an animated container.
class UIExpandableFloatingPanel extends StatefulWidget {
  const UIExpandableFloatingPanel({
    super.key,
    required this.title,
    required this.child,
    required this.toggleIconBuilder,
    this.backgroundColor,
    this.horizontalPadding = 16,
    this.verticalFraction = 0.7,
    this.maxWidth,
    this.animationDuration = const Duration(milliseconds: 300),
    this.borderRadius = 24,
    this.initiallyExpanded = false,
    this.expandTooltip = 'Expand',
    this.collapseTooltip = 'Collapse',
  });

  final Widget title;
  final Widget child;
  final Widget Function(bool isExpanded) toggleIconBuilder;
  final Color? backgroundColor;
  final double horizontalPadding;
  final double verticalFraction;
  final double? maxWidth;
  final Duration animationDuration;
  final double borderRadius;
  final bool initiallyExpanded;

  /// Tooltip / semantic label for the toggle button when collapsed.
  final String expandTooltip;

  /// Tooltip / semantic label for the toggle button when expanded.
  final String collapseTooltip;

  /// Theme-aware panel defaults.
  factory UIExpandableFloatingPanel.fromTheme(
    BuildContext context, {
    Key? key,
    required Widget title,
    required Widget child,
    required Widget Function(bool isExpanded) toggleIconBuilder,
    Color? backgroundColor,
    double horizontalPadding = 16,
    double verticalFraction = 0.7,
    double? maxWidth,
    Duration animationDuration = const Duration(milliseconds: 300),
    double borderRadius = 24,
    bool initiallyExpanded = false,
    String expandTooltip = 'Expand',
    String collapseTooltip = 'Collapse',
  }) {
    return UIExpandableFloatingPanel(
      key: key,
      title: title,
      toggleIconBuilder: toggleIconBuilder,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHigh,
      horizontalPadding: horizontalPadding,
      verticalFraction: verticalFraction,
      maxWidth: maxWidth,
      animationDuration: animationDuration,
      borderRadius: borderRadius,
      initiallyExpanded: initiallyExpanded,
      expandTooltip: expandTooltip,
      collapseTooltip: collapseTooltip,
      child: child,
    );
  }

  @override
  State<UIExpandableFloatingPanel> createState() =>
      _UIExpandableFloatingPanelState();
}

class _UIExpandableFloatingPanelState extends State<UIExpandableFloatingPanel> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  double _panelWidth(BuildContext context) {
    var width =
        MediaQuery.sizeOf(context).width - (widget.horizontalPadding * 2);
    final maxWidth = widget.maxWidth;
    if (maxWidth != null) {
      width = math.min(maxWidth, width);
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    final background =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHigh;

    return Material(
      color: background,
      elevation: 6,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(widget.borderRadius),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          AnimatedSize(
            duration: widget.animationDuration,
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topRight,
            child: _isExpanded ? _expandedBody(context) : const SizedBox.shrink(),
          ),
          IconButton(
            key: const Key('ui_expandable_floating_panel_toggle'),
            tooltip: _isExpanded
                ? widget.collapseTooltip
                : widget.expandTooltip,
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            icon: widget.toggleIconBuilder(_isExpanded),
          ),
        ],
      ),
    );
  }

  Widget _expandedBody(BuildContext context) {
    final maxHeight =
        MediaQuery.sizeOf(context).height * widget.verticalFraction;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: _panelWidth(context),
        maxHeight: maxHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.title,
            const SizedBox(height: 12),
            Flexible(child: SingleChildScrollView(child: widget.child)),
          ],
        ),
      ),
    );
  }
}
