import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../media/ui_image.dart';

part 'ui_hierarchy_searchable_dropdown_header.dart';
part 'ui_hierarchy_searchable_dropdown_panel.dart';
part 'ui_hierarchy_searchable_dropdown_tree.dart';

/// A hierarchical item for the [UIHierarchySearchableDropdown].
class UIHierarchyItem {
  const UIHierarchyItem({
    required this.title,
    this.subtitle,
    this.subItems,
    this.icon,
    this.iconPath,
    this.iconHeight,
    this.iconWidth,
    this.iconBorderRadius,
    this.prefix,
    this.suffix,
    this.data,
  });

  /// The display title of the item.
  final String title;

  /// The display subtitle of the item.
  final String? subtitle;

  /// Nested sub-items for this category.
  final List<UIHierarchyItem>? subItems;

  /// Optional icon for the item.
  final IconData? icon;

  /// Optional path for an image (network URL or asset path).
  final String? iconPath;

  /// Optional custom height for this item's icon/image.
  final double? iconHeight;

  /// Optional custom width for this item's icon/image.
  final double? iconWidth;

  /// Optional custom border radius for this item's icon/image.
  final double? iconBorderRadius;

  /// Optional custom widget to show before the title.
  final Widget? prefix;

  /// Optional custom widget to show after the title.
  final Widget? suffix;

  /// Optional custom data associated with this item.
  final dynamic data;

  /// Returns true if this is a leaf node (no sub-items).
  bool get isLeaf => subItems == null || subItems!.isEmpty;

  /// Collects all leaf titles that are marked selected in [selectedIds].
  void collectSelectedTitles(Set<String> selectedIds, List<String> out) {
    if (isLeaf) {
      if (selectedIds.contains(title)) out.add(title);
    } else {
      for (final sub in subItems!) {
        sub.collectSelectedTitles(selectedIds, out);
      }
    }
  }

  /// Returns all leaf titles under this item (for select-all).
  List<String> get allLeafTitles {
    if (isLeaf) return [title];
    return [for (final sub in subItems!) ...sub.allLeafTitles];
  }

  /// Returns true if [title] or any descendant matches [query].
  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    if (title.toLowerCase().contains(lowerQuery)) return true;
    if (subtitle != null && subtitle!.toLowerCase().contains(lowerQuery)) {
      return true;
    }
    if (!isLeaf) {
      for (final sub in subItems!) {
        if (sub.matchesQuery(query)) return true;
      }
    }
    return false;
  }
}

/// Builder for the dropdown trigger/header.
typedef UIHierarchyHeaderBuilder =
    Widget Function(
      BuildContext context,
      String label,
      bool isOpen,
      VoidCallback onTap,
    );

/// Builder for the search field.
typedef UIHierarchySearchBuilder =
    Widget Function(
      BuildContext context,
      TextEditingController controller,
      String query,
      ValueChanged<String> onChanged,
    );

/// Builder for individual tree rows.
typedef UIHierarchyItemBuilder =
    Widget Function(
      BuildContext context,
      UIHierarchyItem item,
      int level,
      bool isExpanded,
      bool? isSelected, // null for partial, true/false for leaf/group
      VoidCallback onToggleExpand,
      VoidCallback onToggleSelect,
    );

/// A premium, customizable hierarchical dropdown with search and multi-select support.
class UIHierarchySearchableDropdown extends StatefulWidget {
  const UIHierarchySearchableDropdown({
    super.key,
    required this.items,
    this.hint = 'Select items...',
    this.isMultiline = false,
    this.isMultiSelect = false,
    required this.onChanged,
    this.headerBuilder,
    this.searchBuilder,
    this.itemBuilder,
    this.dropdownDecoration,
    this.maxHeight = 500,
    this.itemTextStyle,
    this.itemTextAlign,
    this.itemPadding,
    this.listPadding,
    this.itemSpacing,
    this.defaultIconHeight = 22,
    this.defaultIconWidth = 22,
    this.defaultIconBorderRadius = 6,
    this.validator,
    this.buttonHeight,
    this.buttonWidth,
    this.dropdownHeight,
    this.dropdownWidth,
    this.offset,
    this.headerDecoration,
    this.searchDecoration,
    this.searchBoxDecoration,
    this.searchStyle,
    this.searchHintText = 'Search here...',
    this.clearSearchTooltip = 'Clear search',
    this.targetAnchor = Alignment.bottomLeft,
    this.followerAnchor = Alignment.topLeft,
    this.showChips = false,
    this.chipDecoration,
    this.chipTextStyle,
    this.chipPadding,
    this.chipHeight,
    this.searchFocusNode,
    this.autoFocusSearch = false,
    this.headerPrefix,
    this.headerSuffix,
    this.clearSearchOnClose = true,
    this.chipScrollDirection = Axis.horizontal,
    this.showSearch = true,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.loadingIndicator,
    this.enableAnimation = true,
    this.isGlassMode = false,
    this.blur = 10,
    this.connectivity = 0.1,
  });

  /// The list of top-level hierarchy items.
  final List<UIHierarchyItem> items;

  /// Hint text for the dropdown trigger.
  final String hint;

  /// Whether the selected label should wrap onto multiple lines.
  final bool isMultiline;

  /// Whether to allow multiple selections with recursive logic.
  final bool isMultiSelect;

  /// Callback when the selection changes (comma-separated labels).
  final ValueChanged<String> onChanged;

  /// Optional custom builder for the dropdown trigger.
  final UIHierarchyHeaderBuilder? headerBuilder;

  /// Optional custom builder for the search field.
  final UIHierarchySearchBuilder? searchBuilder;

  /// Optional custom builder for each tree row.
  final UIHierarchyItemBuilder? itemBuilder;

  /// Optional decoration for the dropdown panel content.
  final BoxDecoration? dropdownDecoration;

  /// Maximum height of the dropdown panel.
  final double maxHeight;

  /// Optional custom text style for all items.
  final TextStyle? itemTextStyle;

  /// Optional text alignment for the item title.
  final TextAlign? itemTextAlign;

  /// Optional padding for each item row.
  final EdgeInsets? itemPadding;

  /// Optional padding for the overall list inside the dropdown.
  final EdgeInsets? listPadding;

  /// Vertical space between items.
  final double? itemSpacing;

  /// Default height for icons/images if not specified per-item.
  final double defaultIconHeight;

  /// Default width for icons/images if not specified per-item.
  final double defaultIconWidth;

  /// Default border radius for icons/images if not specified per-item.
  final double defaultIconBorderRadius;

  /// Optional validator function to validate the selection.
  final String? Function(String?)? validator;

  /// Optional custom height for the dropdown trigger/button.
  final double? buttonHeight;

  /// Optional custom width for the dropdown trigger/button.
  final double? buttonWidth;

  /// Optional custom height for the dropdown panel.
  final double? dropdownHeight;

  /// Optional custom width for the dropdown panel.
  final double? dropdownWidth;

  /// Optional offset to position the dropdown panel relative to the trigger.
  final Offset? offset;

  /// Optional custom decoration for the default header.
  final BoxDecoration? headerDecoration;

  /// Optional custom decoration for the default search field's InputDecoration.
  final InputDecoration? searchDecoration;

  /// Optional custom decoration for the search field container.
  final BoxDecoration? searchBoxDecoration;

  /// Optional custom text style for the search field.
  final TextStyle? searchStyle;

  /// Hint text shown inside the default search field.
  final String searchHintText;

  /// Tooltip / semantic label for the search field's clear button.
  final String clearSearchTooltip;

  /// Optional target anchor for the dropdown panel position.
  final Alignment targetAnchor;

  /// Optional follower anchor for the dropdown panel position.
  final Alignment followerAnchor;

  /// Whether to show selected items as chips in the header.
  final bool showChips;

  /// Optional decoration for the chips in the header.
  final BoxDecoration? chipDecoration;

  /// Optional text style for the chips in the header.
  final TextStyle? chipTextStyle;

  /// Optional padding for the chips in the header.
  final EdgeInsets? chipPadding;

  /// Optional custom height for the chips in the header.
  final double? chipHeight;

  /// Optional custom FocusNode for the search field.
  final FocusNode? searchFocusNode;

  /// Whether the search field should auto-focus when opened.
  final bool autoFocusSearch;

  /// Optional custom widget to show as prefix in the default header.
  final Widget? headerPrefix;

  /// Optional custom widget to show as suffix in the default header.
  final Widget? headerSuffix;

  /// Whether to clear the search query when the dropdown is closed.
  final bool clearSearchOnClose;

  /// The scroll direction of the chips in the header.
  final Axis chipScrollDirection;

  /// Whether to show the search bar in the dropdown panel.
  final bool showSearch;

  /// Whether we are currently loading more items at the bottom.
  final bool isLoadingMore;

  /// Callback when the user scrolls near the bottom of the list.
  final VoidCallback? onLoadMore;

  /// Optional widget to show as a loader at the bottom of the list.
  final Widget? loadingIndicator;

  /// Whether to enable entrance animations for items.
  final bool enableAnimation;

  /// Whether to enable glassmorphism (blur background) for the dropdown panel.
  final bool isGlassMode;

  /// Blur amount for the glassmorphism effect.
  final double blur;

  /// Connectivity (white opacity) for the glassmorphism effect.
  final double connectivity;

  @override
  State<UIHierarchySearchableDropdown> createState() =>
      _UIHierarchySearchableDropdownState();
}

class _UIHierarchySearchableDropdownState
    extends State<UIHierarchySearchableDropdown> {
  final Set<String> _selectedIds = {};
  final List<String> _orderedSelectedLabels = [];
  final Set<String> _expandedIds = {};
  bool _isOpen = false;
  bool _isOpeningUpwards = false;
  double _buttonWidth = 0;
  double _maxAvailableHeight = 0;
  String _searchQuery = '';
  String? _errorText;
  final TextEditingController _searchController = TextEditingController();
  late final FocusNode _internalFocusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  Timer? _autoFocusTimer;

  FocusNode get _effectiveFocusNode =>
      widget.searchFocusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(UIHierarchySearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen) {
      if (oldWidget.items != widget.items ||
          oldWidget.isLoadingMore != widget.isLoadingMore ||
          oldWidget.isMultiSelect != widget.isMultiSelect ||
          oldWidget.showSearch != widget.showSearch) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isOpen) {
            _overlayEntry?.markNeedsBuild();
          }
        });
      }
    }
  }

  String get _selectedLabel {
    if (_selectedIds.isEmpty) return '';
    final buf = <String>[];
    for (final item in widget.items) {
      item.collectSelectedTitles(_selectedIds, buf);
    }
    return buf.join(', ');
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final overlay = Overlay.of(context);

    // Calculate available space to decide if we should open upwards
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.viewPadding.top;
    final bottomPadding = mediaQuery.viewPadding.bottom;

    final availableSpaceBelow =
        screenHeight - offset.dy - size.height - bottomPadding - 16;
    final availableSpaceAbove = offset.dy - topPadding - 16;

    // Use a small buffer (20.0) for better UI
    final dropdownHeight = widget.dropdownHeight ?? widget.maxHeight;
    _isOpeningUpwards =
        availableSpaceBelow < (dropdownHeight + 20) &&
        availableSpaceAbove > availableSpaceBelow;

    _buttonWidth = size.width;
    final rawAvailable = _isOpeningUpwards
        ? availableSpaceAbove
        : availableSpaceBelow;
    _maxAvailableHeight = rawAvailable.clamp(120.0, widget.maxHeight);

    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
    if (widget.autoFocusSearch) {
      _autoFocusTimer?.cancel();
      _autoFocusTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted) _effectiveFocusNode.requestFocus();
      });
    }
  }

  void _closeDropdown() {
    _autoFocusTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (widget.clearSearchOnClose) {
      _searchQuery = '';
      if (mounted) _searchController.clear();
    }
    if (!mounted) {
      _isOpen = false;
      return;
    }
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final targetAnchor = _isOpeningUpwards
        ? Alignment.topLeft
        : widget.targetAnchor;
    final followerAnchor = _isOpeningUpwards
        ? Alignment.bottomLeft
        : widget.followerAnchor;
    final finalOffset = _isOpeningUpwards
        ? (widget.offset?.scale(1, -1) ?? const Offset(0, -4))
        : (widget.offset ?? const Offset(0, 4));

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            offset: finalOffset,
            child: TapRegion(
              groupId: _layerLink,
              onTapOutside: (_) => _closeDropdown(),
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: widget.dropdownWidth ?? _buttonWidth,
                  height: widget.dropdownHeight,
                  child: _DropdownPanel(
                    items: widget.items,
                    isMultiSelect: widget.isMultiSelect,
                    showSearch: widget.showSearch,
                    selectedIds: _selectedIds,
                    expandedIds: _expandedIds,
                    searchQuery: _searchQuery,
                    searchController: _searchController,
                    maxHeight:
                        widget.dropdownHeight ??
                        (widget.maxHeight < _maxAvailableHeight
                                ? widget.maxHeight
                                : _maxAvailableHeight)
                            .clamp(120.0, widget.maxHeight),
                    decoration: widget.dropdownDecoration,
                    searchBuilder: widget.searchBuilder,
                    itemBuilder: widget.itemBuilder,
                    itemTextStyle: widget.itemTextStyle,
                    itemTextAlign: widget.itemTextAlign,
                    itemPadding: widget.itemPadding,
                    listPadding: widget.listPadding,
                    itemSpacing: widget.itemSpacing,
                    defaultIconHeight: widget.defaultIconHeight,
                    defaultIconWidth: widget.defaultIconWidth,
                    defaultIconBorderRadius: widget.defaultIconBorderRadius,
                    searchDecoration: widget.searchDecoration,
                    searchBoxDecoration: widget.searchBoxDecoration,
                    searchStyle: widget.searchStyle,
                    searchHintText: widget.searchHintText,
                    clearSearchTooltip: widget.clearSearchTooltip,
                    focusNode: _effectiveFocusNode,
                    autoFocus: widget.autoFocusSearch,
                    onSearchChanged: (q) {
                      setState(() => _searchQuery = q.toLowerCase());
                      _overlayEntry?.markNeedsBuild();
                    },
                    onLeafTapped: _onLeafTapped,
                    onGroupToggle: _onGroupToggle,
                    onExpandToggle: (id) {
                      _onExpandToggle(id);
                      _overlayEntry?.markNeedsBuild();
                    },
                    isLoadingMore: widget.isLoadingMore,
                    onLoadMore: widget.onLoadMore,
                    loadingIndicator: widget.loadingIndicator,
                    enableAnimation: widget.enableAnimation,
                    isGlassMode: widget.isGlassMode,
                    blur: widget.blur,
                    connectivity: widget.connectivity,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLeafTapped(UIHierarchyItem leaf) {
    setState(() {
      if (widget.isMultiSelect) {
        if (_selectedIds.contains(leaf.title)) {
          _selectedIds.remove(leaf.title);
          _orderedSelectedLabels.remove(leaf.title);
        } else {
          _selectedIds.add(leaf.title);
          _orderedSelectedLabels.add(leaf.title);
        }
      } else {
        _selectedIds
          ..clear()
          ..add(leaf.title);
        _orderedSelectedLabels
          ..clear()
          ..add(leaf.title);
        _closeDropdown();
      }
    });
    _overlayEntry?.markNeedsBuild();
    widget.onChanged(_selectedLabel);
    _validate();
  }

  void _validate() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(_selectedLabel);
      });
    }
  }

  void _onGroupToggle(UIHierarchyItem group, bool select) {
    assert(widget.isMultiSelect);
    setState(() {
      final leaves = group.allLeafTitles;
      if (select) {
        for (final leaf in leaves) {
          if (!_selectedIds.contains(leaf)) {
            _selectedIds.add(leaf);
            _orderedSelectedLabels.add(leaf);
          }
        }
      } else {
        for (final leaf in leaves) {
          _selectedIds.remove(leaf);
          _orderedSelectedLabels.remove(leaf);
        }
      }
    });
    _overlayEntry?.markNeedsBuild();
    widget.onChanged(_selectedLabel);
    _validate();
  }

  void _onExpandToggle(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  void _removeSelection(String label) {
    setState(() {
      _selectedIds.remove(label);
      _orderedSelectedLabels.remove(label);
    });
    _overlayEntry?.markNeedsBuild();
    widget.onChanged(_selectedLabel);
    _validate();
  }

  void _reorderSelections(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _orderedSelectedLabels.removeAt(oldIndex);
      _orderedSelectedLabels.insert(newIndex, item);
    });
    widget.onChanged(_selectedLabel);
  }

  @override
  void dispose() {
    _autoFocusTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = _selectedLabel;
    return TapRegion(
      groupId: _layerLink,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          width: widget.buttonWidth,
          height: widget.isMultiline ? null : widget.buttonHeight,
          child: widget.headerBuilder != null
              ? widget.headerBuilder!(context, label, _isOpen, _toggleDropdown)
              : _DefaultHeader(
                  label: label,
                  hint: widget.hint,
                  isMultiline: widget.isMultiline,
                  isOpen: _isOpen,
                  errorText: _errorText,
                  onTap: _toggleDropdown,
                  decoration: widget.headerDecoration,
                  showChips: widget.showChips,
                  selectedLabels: _orderedSelectedLabels,
                  onRemove: _removeSelection,
                  onReorder: _reorderSelections,
                  chipDecoration: widget.chipDecoration,
                  chipTextStyle: widget.chipTextStyle,
                  chipPadding: widget.chipPadding,
                  chipHeight: widget.chipHeight,
                  chipScrollDirection: widget.chipScrollDirection,
                  prefix: widget.headerPrefix,
                  suffix: widget.headerSuffix,
                  isGlassMode: widget.isGlassMode,
                  blur: widget.blur,
                  connectivity: widget.connectivity,
                ),
        ),
      ),
    );
  }
}
