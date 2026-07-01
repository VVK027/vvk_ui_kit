import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/navigation/ui_context_menu.dart';

/// Lays out [children] in a horizontal row and moves items that do not fit
/// into an overflow control built by [overflowBuilder].
class UIDynamicOverflow extends StatefulWidget {
  const UIDynamicOverflow({
    super.key,
    required this.children,
    required this.overflowBuilder,
    this.spacing = 8,
    this.alignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.overflowReserveWidth = 44,
    this.alwaysShowOverflow = false,
    this.onHiddenChanged,
  });

  final List<Widget> children;
  final Widget Function(BuildContext context, List<int> hiddenIndices)
  overflowBuilder;
  final double spacing;
  final MainAxisAlignment alignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double overflowReserveWidth;
  final bool alwaysShowOverflow;
  final ValueChanged<List<int>>? onHiddenChanged;

  @override
  State<UIDynamicOverflow> createState() => _UIDynamicOverflowState();
}

class _UIDynamicOverflowState extends State<UIDynamicOverflow> {
  final List<GlobalKey> _childKeys = [];
  bool _measured = false;
  int _visibleCount = 0;
  List<int> _hiddenIndices = const [];

  @override
  void initState() {
    super.initState();
    _syncKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) => _remeasure());
  }

  @override
  void didUpdateWidget(UIDynamicOverflow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _syncKeys();
      _measured = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _remeasure());
    }
  }

  void _syncKeys() {
    _childKeys
      ..clear()
      ..addAll(List.generate(widget.children.length, (_) => GlobalKey()));
  }

  void _remeasure() {
    if (!mounted) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    final maxWidth = renderBox?.constraints.maxWidth;
    if (maxWidth == null || !maxWidth.isFinite) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _remeasure());
      return;
    }

    final widths = <double>[];
    for (final key in _childKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      widths.add(box?.size.width ?? 0);
    }

    if (widths.any((width) => width <= 0)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _remeasure());
      return;
    }

    final hidden = <int>[];
    var visible = widths.length;
    final reserve = widget.overflowReserveWidth + widget.spacing;

    var used = 0.0;
    for (var i = 0; i < widths.length; i++) {
      final itemWidth = widths[i] + (i == 0 ? 0 : widget.spacing);
      final hiddenAfter = widths.length - i - 1;
      final needsReserve = hiddenAfter > 0 || widget.alwaysShowOverflow;
      final budget = maxWidth - (needsReserve ? reserve : 0);
      if (used + itemWidth > budget) {
        visible = i;
        break;
      }
      used += itemWidth;
    }

    if (visible <= 0 && widths.isNotEmpty) {
      visible = 1;
    }

    for (var i = visible; i < widths.length; i++) {
      hidden.add(i);
    }

    final changed =
        !_measured ||
        visible != _visibleCount ||
        !_listEquals(hidden, _hiddenIndices);

    if (changed) {
      setState(() {
        _measured = true;
        _visibleCount = visible;
        _hiddenIndices = hidden;
      });
      widget.onHiddenChanged?.call(hidden);
    } else if (!_measured) {
      setState(() => _measured = true);
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final measureRow = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            for (var i = 0; i < widget.children.length; i++)
              Padding(
                key: _childKeys[i],
                padding: EdgeInsets.only(
                  right: i < widget.children.length - 1 ? widget.spacing : 0,
                ),
                child: widget.children[i],
              ),
          ],
        );

        if (!_measured) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Offstage(child: measureRow),
              const SizedBox(height: 40),
            ],
          );
        }

        final visibleChildren = <Widget>[
          for (var i = 0; i < _visibleCount; i++)
            Padding(
              padding: EdgeInsets.only(
                right: i < _visibleCount - 1 || _hiddenIndices.isNotEmpty
                    ? widget.spacing
                    : 0,
              ),
              child: widget.children[i],
            ),
        ];

        if (_hiddenIndices.isNotEmpty || widget.alwaysShowOverflow) {
          visibleChildren.add(widget.overflowBuilder(context, _hiddenIndices));
        }

        return Row(
          mainAxisAlignment: widget.alignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: visibleChildren,
        );
      },
    );
  }
}

/// Default overflow menu button for [UIDynamicOverflow].
class UIDynamicOverflowMenuButton extends StatelessWidget {
  const UIDynamicOverflowMenuButton({
    super.key,
    required this.hiddenIndices,
    required this.menuItems,
    this.icon = Icons.more_horiz,
    this.tooltip = 'More',
  });

  final List<int> hiddenIndices;
  final List<UIContextMenuItem> menuItems;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    if (menuItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final anchorKey = GlobalKey();
    return IconButton(
      key: anchorKey,
      tooltip: tooltip,
      onPressed: () {
        final box = anchorKey.currentContext?.findRenderObject() as RenderBox?;
        if (box == null) return;
        final offset = box.localToGlobal(Offset.zero);
        final size = box.size;
        showUIContextMenu(
          context: context,
          position: Offset(offset.dx, offset.dy + size.height + 4),
          items: menuItems,
        );
      },
      icon: Icon(icon),
    );
  }
}
