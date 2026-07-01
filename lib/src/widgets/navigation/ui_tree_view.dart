import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Selection behavior for [UITreeView].
enum UITreeViewSelectionMode {
  /// Items cannot be selected.
  none,

  /// Only one item can be selected at a time.
  single,

  /// Multiple items can be selected with checkboxes.
  multiple,
}

/// One node in a [UITreeView] hierarchy.
class UITreeNode {
  UITreeNode({
    required this.key,
    required this.label,
    this.icon,
    this.children = const [],
    this.enabled = true,
    this.data,
  }) : assert(key.isNotEmpty, 'key must not be empty');

  final String key;
  final String label;
  final IconData? icon;
  final List<UITreeNode> children;
  final bool enabled;
  final Object? data;

  bool get hasChildren => children.isNotEmpty;

  List<String> get descendantKeys {
    final keys = <String>[];
    for (final child in children) {
      keys
        ..add(child.key)
        ..addAll(child.descendantKeys);
    }
    return keys;
  }
}

/// Hierarchical list with expand/collapse and optional selection.
class UITreeView extends StatefulWidget {
  const UITreeView({
    super.key,
    required this.nodes,
    this.selectionMode = UITreeViewSelectionMode.single,
    this.selectedKeys = const {},
    this.expandedKeys = const {},
    this.onSelectionChanged,
    this.onExpansionChanged,
    this.onItemInvoked,
    this.indent = 20,
    this.dense = false,
    this.backgroundColor,
    this.selectedColor,
    this.iconColor,
    this.textStyle,
    this.expandTooltip = 'Expand',
    this.collapseTooltip = 'Collapse',
  });

  final List<UITreeNode> nodes;
  final UITreeViewSelectionMode selectionMode;
  final Set<String> selectedKeys;
  final Set<String> expandedKeys;
  final ValueChanged<Set<String>>? onSelectionChanged;
  final ValueChanged<Set<String>>? onExpansionChanged;
  final ValueChanged<UITreeNode>? onItemInvoked;
  final double indent;
  final bool dense;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? iconColor;
  final TextStyle? textStyle;

  /// Tooltip / semantic label for a node's expand button when collapsed.
  final String expandTooltip;

  /// Tooltip / semantic label for a node's collapse button when expanded.
  final String collapseTooltip;

  factory UITreeView.fromTheme(
    BuildContext context, {
    Key? key,
    required List<UITreeNode> nodes,
    UITreeViewSelectionMode selectionMode = UITreeViewSelectionMode.single,
    Set<String> selectedKeys = const {},
    Set<String> expandedKeys = const {},
    ValueChanged<Set<String>>? onSelectionChanged,
    ValueChanged<Set<String>>? onExpansionChanged,
    ValueChanged<UITreeNode>? onItemInvoked,
    double indent = 20,
    bool dense = false,
    Color? backgroundColor,
    Color? selectedColor,
    Color? iconColor,
    TextStyle? textStyle,
    String expandTooltip = 'Expand',
    String collapseTooltip = 'Collapse',
  }) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return UITreeView(
      key: key,
      nodes: nodes,
      selectionMode: selectionMode,
      selectedKeys: selectedKeys,
      expandedKeys: expandedKeys,
      onSelectionChanged: onSelectionChanged,
      onExpansionChanged: onExpansionChanged,
      onItemInvoked: onItemInvoked,
      indent: indent,
      dense: dense,
      backgroundColor: backgroundColor ?? scheme.surface,
      selectedColor: selectedColor ?? scheme.primaryContainer,
      iconColor: iconColor ?? scheme.onSurfaceVariant,
      textStyle: textStyle ?? theme.textTheme.bodyMedium,
      expandTooltip: expandTooltip,
      collapseTooltip: collapseTooltip,
    );
  }

  @override
  State<UITreeView> createState() => _UITreeViewState();
}

class _UITreeViewState extends State<UITreeView> {
  late Set<String> _selectedKeys;
  late Set<String> _expandedKeys;

  @override
  void initState() {
    super.initState();
    _selectedKeys = Set<String>.from(widget.selectedKeys);
    _expandedKeys = Set<String>.from(widget.expandedKeys);
  }

  @override
  void didUpdateWidget(UITreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedKeys != widget.selectedKeys) {
      _selectedKeys = Set<String>.from(widget.selectedKeys);
    }
    if (oldWidget.expandedKeys != widget.expandedKeys) {
      _expandedKeys = Set<String>.from(widget.expandedKeys);
    }
  }

  void _toggleExpanded(UITreeNode node) {
    setState(() {
      if (_expandedKeys.contains(node.key)) {
        _expandedKeys.remove(node.key);
      } else {
        _expandedKeys.add(node.key);
      }
    });
    widget.onExpansionChanged?.call(Set<String>.from(_expandedKeys));
  }

  void _toggleSelection(UITreeNode node) {
    if (widget.selectionMode == UITreeViewSelectionMode.none ||
        !node.enabled) {
      return;
    }

    setState(() {
      if (widget.selectionMode == UITreeViewSelectionMode.single) {
        _selectedKeys = {node.key};
      } else {
        if (_selectedKeys.contains(node.key)) {
          _selectedKeys.remove(node.key);
          for (final key in node.descendantKeys) {
            _selectedKeys.remove(key);
          }
        } else {
          _selectedKeys.add(node.key);
          for (final key in node.descendantKeys) {
            _selectedKeys.add(key);
          }
        }
      }
    });
    widget.onSelectionChanged?.call(Set<String>.from(_selectedKeys));
  }

  void _handleTap(UITreeNode node) {
    if (!node.enabled) return;

    if (node.hasChildren) {
      _toggleExpanded(node);
    }

    if (widget.selectionMode != UITreeViewSelectionMode.none) {
      _toggleSelection(node);
    }

    widget.onItemInvoked?.call(node);
  }

  bool? _checkboxValue(UITreeNode node) {
    if (!node.hasChildren) {
      return _selectedKeys.contains(node.key);
    }

    final descendants = node.descendantKeys;
    if (descendants.isEmpty) {
      return _selectedKeys.contains(node.key);
    }

    final selectedCount =
        descendants.where((key) => _selectedKeys.contains(key)).length;
    if (selectedCount == 0 && !_selectedKeys.contains(node.key)) {
      return false;
    }
    if (selectedCount == descendants.length &&
        _selectedKeys.contains(node.key)) {
      return true;
    }
    return null;
  }

  Widget _buildNode(UITreeNode node, int depth) {
    final isExpanded = _expandedKeys.contains(node.key);
    final isSelected = _selectedKeys.contains(node.key);
    final rowHeight = widget.dense ? 36.0 : 44.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: isSelected
              ? widget.selectedColor
              : widget.backgroundColor,
          child: InkWell(
            onTap: () => _handleTap(node),
            child: SizedBox(
              height: rowHeight,
              child: Padding(
                padding: EdgeInsets.only(left: depth * widget.indent),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: node.hasChildren
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              tooltip: isExpanded
                                  ? widget.collapseTooltip
                                  : widget.expandTooltip,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              iconSize: 20,
                              onPressed: node.enabled
                                  ? () => _toggleExpanded(node)
                                  : null,
                              icon: Icon(
                                isExpanded
                                    ? Icons.expand_more
                                    : Icons.chevron_right,
                                color: widget.iconColor,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    if (widget.selectionMode ==
                        UITreeViewSelectionMode.multiple) ...[
                      Checkbox(
                        tristate: node.hasChildren,
                        value: _checkboxValue(node),
                        onChanged: node.enabled
                            ? (_) => _toggleSelection(node)
                            : null,
                      ),
                      const SizedBox(width: 4),
                    ],
                    if (node.icon != null) ...[
                      Icon(node.icon, size: 18, color: widget.iconColor),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: UIText(
                        node.label,
                        style: widget.textStyle?.copyWith(
                          color: node.enabled
                              ? widget.textStyle?.color
                              : widget.textStyle?.color
                                    ?.withValues(alpha: 0.38),
                        ),
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (node.hasChildren && isExpanded)
          for (final child in node.children) _buildNode(child, depth + 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [for (final node in widget.nodes) _buildNode(node, 0)],
        ),
      ),
    );
  }
}
