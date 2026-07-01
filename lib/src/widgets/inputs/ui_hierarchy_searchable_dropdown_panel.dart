part of 'ui_hierarchy_searchable_dropdown.dart';

class _DropdownPanel extends StatefulWidget {
  const _DropdownPanel({
    required this.items,
    required this.isMultiSelect,
    required this.selectedIds,
    required this.expandedIds,
    required this.searchQuery,
    required this.searchController,
    required this.maxHeight,
    required this.showSearch,
    this.decoration,
    this.searchBuilder,
    this.itemBuilder,
    this.itemTextStyle,
    this.itemTextAlign,
    this.itemPadding,
    this.listPadding,
    this.itemSpacing,
    required this.defaultIconHeight,
    required this.defaultIconWidth,
    required this.defaultIconBorderRadius,
    this.searchDecoration,
    this.searchBoxDecoration,
    this.searchStyle,
    this.searchHintText = 'Search here...',
    this.clearSearchTooltip = 'Clear search',
    this.focusNode,
    this.autoFocus = false,
    required this.onSearchChanged,
    required this.onLeafTapped,
    required this.onGroupToggle,
    required this.onExpandToggle,
    required this.isLoadingMore,
    this.onLoadMore,
    this.loadingIndicator,
    required this.enableAnimation,
    required this.isGlassMode,
    required this.blur,
    required this.connectivity,
  });

  final List<UIHierarchyItem> items;
  final bool isMultiSelect;
  final Set<String> selectedIds;
  final Set<String> expandedIds;
  final String searchQuery;
  final TextEditingController searchController;
  final double maxHeight;
  final bool showSearch;
  final BoxDecoration? decoration;
  final UIHierarchySearchBuilder? searchBuilder;
  final UIHierarchyItemBuilder? itemBuilder;
  final TextStyle? itemTextStyle;
  final TextAlign? itemTextAlign;
  final EdgeInsets? itemPadding;
  final EdgeInsets? listPadding;
  final double? itemSpacing;
  final double defaultIconHeight;
  final double defaultIconWidth;
  final double defaultIconBorderRadius;
  final InputDecoration? searchDecoration;
  final BoxDecoration? searchBoxDecoration;
  final TextStyle? searchStyle;
  final String searchHintText;
  final String clearSearchTooltip;
  final FocusNode? focusNode;
  final bool autoFocus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<UIHierarchyItem> onLeafTapped;
  final void Function(UIHierarchyItem, bool) onGroupToggle;
  final ValueChanged<String> onExpandToggle;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final Widget? loadingIndicator;
  final bool enableAnimation;
  final bool isGlassMode;
  final double blur;
  final double connectivity;

  @override
  State<_DropdownPanel> createState() => _DropdownPanelState();
}

class _DropdownPanelState extends State<_DropdownPanel> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (widget.onLoadMore != null && !widget.isLoadingMore) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: _GlassWrap(
        isGlassMode: widget.isGlassMode,
        blur: widget.blur,
        connectivity: widget.connectivity,
        borderRadius:
            (widget.decoration?.borderRadius as BorderRadius?) ??
            BorderRadius.circular(20),
        child: Container(
          decoration:
              widget.decoration ??
              BoxDecoration(
                color: widget.isGlassMode ? Colors.transparent : Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(20),
                boxShadow: widget.isGlassMode
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showSearch)
                if (widget.searchBuilder != null)
                  widget.searchBuilder!(
                    context,
                    widget.searchController,
                    widget.searchQuery,
                    widget.onSearchChanged,
                  )
                else
                  _DefaultSearchBar(
                    controller: widget.searchController,
                    query: widget.searchQuery,
                    onChanged: widget.onSearchChanged,
                    decoration: widget.searchDecoration,
                    boxDecoration: widget.searchBoxDecoration,
                    style: widget.searchStyle,
                    hintText: widget.searchHintText,
                    clearTooltip: widget.clearSearchTooltip,
                    focusNode: widget.focusNode,
                    autoFocus: widget.autoFocus,
                  ),
              Flexible(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding:
                      widget.listPadding ??
                      const EdgeInsets.symmetric(vertical: 8),
                  itemCount:
                      widget.items.length + (widget.isLoadingMore ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == widget.items.length) {
                      return _LoadingItem(
                        indicator: widget.loadingIndicator,
                        enableAnimation: widget.enableAnimation,
                      );
                    }
                    return _InternalTreeItem(
                      key: ValueKey(widget.items[i].title),
                      item: widget.items[i],
                      level: 0,
                      searchQuery: widget.searchQuery,
                      parentMatches: false,
                      isMultiSelect: widget.isMultiSelect,
                      selectedIds: widget.selectedIds,
                      expandedIds: widget.expandedIds,
                      itemBuilder: widget.itemBuilder,
                      itemTextStyle: widget.itemTextStyle,
                      itemTextAlign: widget.itemTextAlign,
                      itemPadding: widget.itemPadding,
                      itemSpacing: widget.itemSpacing,
                      defaultIconHeight: widget.defaultIconHeight,
                      defaultIconWidth: widget.defaultIconWidth,
                      defaultIconBorderRadius: widget.defaultIconBorderRadius,
                      onLeafTapped: widget.onLeafTapped,
                      onGroupToggle: widget.onGroupToggle,
                      onExpandToggle: widget.onExpandToggle,
                      enableAnimation: widget.enableAnimation,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultSearchBar extends StatelessWidget {
  const _DefaultSearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    this.decoration,
    this.boxDecoration,
    this.style,
    this.hintText = 'Search here...',
    this.clearTooltip = 'Clear search',
    this.focusNode,
    this.autoFocus = false,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final InputDecoration? decoration;
  final BoxDecoration? boxDecoration;
  final TextStyle? style;
  final String hintText;
  final String clearTooltip;
  final FocusNode? focusNode;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.black38),
      prefixIcon: const Icon(Icons.search_rounded, color: Colors.black38),
      suffixIcon: query.isNotEmpty
          ? IconButton(
              tooltip: clearTooltip,
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.black38,
                size: 20,
              ),
              onPressed: () {
                controller.clear();
                onChanged('');
              },
            )
          : null,
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.03),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.zero,
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: boxDecoration,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          autofocus: autoFocus,
          style: style ?? const TextStyle(color: Colors.black87),
          decoration: decoration ?? defaultDecoration,
        ),
      ),
    );
  }
}
