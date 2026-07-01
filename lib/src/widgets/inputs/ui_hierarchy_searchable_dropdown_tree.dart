part of 'ui_hierarchy_searchable_dropdown.dart';

class _InternalTreeItem extends StatefulWidget {
  const _InternalTreeItem({
    super.key,
    required this.item,
    required this.level,
    required this.searchQuery,
    required this.parentMatches,
    required this.isMultiSelect,
    required this.selectedIds,
    required this.expandedIds,
    this.itemBuilder,
    this.itemTextStyle,
    this.itemTextAlign,
    this.itemPadding,
    this.itemSpacing,
    required this.defaultIconHeight,
    required this.defaultIconWidth,
    required this.defaultIconBorderRadius,
    required this.onLeafTapped,
    required this.onGroupToggle,
    required this.onExpandToggle,
    required this.enableAnimation,
  });

  final UIHierarchyItem item;
  final int level;
  final String searchQuery;
  final bool parentMatches;
  final bool isMultiSelect;
  final Set<String> selectedIds;
  final Set<String> expandedIds;
  final UIHierarchyItemBuilder? itemBuilder;
  final TextStyle? itemTextStyle;
  final TextAlign? itemTextAlign;
  final EdgeInsets? itemPadding;
  final double? itemSpacing;
  final double defaultIconHeight;
  final double defaultIconWidth;
  final double defaultIconBorderRadius;
  final ValueChanged<UIHierarchyItem> onLeafTapped;
  final void Function(UIHierarchyItem, bool) onGroupToggle;
  final ValueChanged<String> onExpandToggle;
  final bool enableAnimation;

  @override
  State<_InternalTreeItem> createState() => _InternalTreeItemState();
}

class _InternalTreeItemState extends State<_InternalTreeItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    if (widget.enableAnimation) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isExpanded => widget.expandedIds.contains(widget.item.title);
  bool get _selfMatches =>
      widget.searchQuery.isEmpty ||
      widget.item.title.toLowerCase().contains(widget.searchQuery);
  bool get _childMatches =>
      !widget.item.isLeaf && widget.item.matchesQuery(widget.searchQuery);
  bool get _shouldShow => _selfMatches || widget.parentMatches || _childMatches;

  bool? get _triState {
    if (widget.item.isLeaf) {
      return widget.selectedIds.contains(widget.item.title);
    }
    final leaves = widget.item.allLeafTitles;
    final count = leaves.where(widget.selectedIds.contains).length;
    if (count == 0) return false;
    if (count == leaves.length) return true;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox.shrink();

    final forceExpand =
        widget.searchQuery.isNotEmpty && !_selfMatches && _childMatches;
    final isActuallyExpanded = _isExpanded || forceExpand;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.itemBuilder != null)
          widget.itemBuilder!(
            context,
            widget.item,
            widget.level,
            isActuallyExpanded,
            widget.isMultiSelect
                ? _triState
                : widget.selectedIds.contains(widget.item.title),
            () => widget.onExpandToggle(widget.item.title),
            () {
              if (widget.item.isLeaf) {
                widget.onLeafTapped(widget.item);
              } else if (widget.isMultiSelect) {
                widget.onGroupToggle(widget.item, _triState != true);
              }
            },
          )
        else
          _DefaultTreeRow(
            item: widget.item,
            level: widget.level,
            isMultiSelect: widget.isMultiSelect,
            isExpanded: isActuallyExpanded,
            triState: widget.isMultiSelect ? _triState : null,
            isSelected:
                !widget.isMultiSelect &&
                widget.selectedIds.contains(widget.item.title),
            onTap: () {
              if (!widget.item.isLeaf) {
                widget.onExpandToggle(widget.item.title);
              } else {
                widget.onLeafTapped(widget.item);
              }
            },
            onCheckboxChanged: widget.isMultiSelect
                ? (v) => widget.onGroupToggle(widget.item, v ?? false)
                : null,
            itemTextStyle: widget.itemTextStyle,
            itemTextAlign: widget.itemTextAlign,
            itemPadding: widget.itemPadding,
            itemSpacing: widget.itemSpacing,
            defaultIconHeight: widget.defaultIconHeight,
            defaultIconWidth: widget.defaultIconWidth,
            defaultIconBorderRadius: widget.defaultIconBorderRadius,
          ),
        if (!widget.item.isLeaf && isActuallyExpanded)
          ...widget.item.subItems!.map(
            (sub) => _InternalTreeItem(
              key: ValueKey(sub.title),
              item: sub,
              level: widget.level + 1,
              searchQuery: widget.searchQuery,
              parentMatches: _selfMatches || widget.parentMatches,
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
            ),
          ),
      ],
    );

    if (!widget.enableAnimation) return content;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: content),
    );
  }
}

class _DefaultTreeRow extends StatelessWidget {
  const _DefaultTreeRow({
    required this.item,
    required this.level,
    required this.isMultiSelect,
    required this.isExpanded,
    required this.triState,
    required this.isSelected,
    required this.onTap,
    required this.onCheckboxChanged,
    this.itemTextStyle,
    this.itemTextAlign,
    this.itemPadding,
    this.itemSpacing,
    required this.defaultIconHeight,
    required this.defaultIconWidth,
    required this.defaultIconBorderRadius,
  });

  final UIHierarchyItem item;
  final int level;
  final bool isMultiSelect;
  final bool isExpanded;
  final bool? triState;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final TextStyle? itemTextStyle;
  final TextAlign? itemTextAlign;
  final EdgeInsets? itemPadding;
  final double? itemSpacing;
  final double defaultIconHeight;
  final double defaultIconWidth;
  final double defaultIconBorderRadius;

  @override
  Widget build(BuildContext context) {
    final hasChildren = !item.isLeaf;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding:
              itemPadding ??
              EdgeInsets.only(
                left: 8.0 + level * 24.0,
                right: 16,
                top: 4 + (itemSpacing ?? 0) / 2,
                bottom: 4 + (itemSpacing ?? 0) / 2,
              ),
          child: Row(
            children: [
              if (item.prefix != null) ...[
                item.prefix!,
                const SizedBox(width: 8),
              ],
              if (hasChildren)
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.arrow_right_rounded,
                    color: Colors.black45,
                    size: 24,
                  ),
                )
              else
                const SizedBox(width: 24),
              if (isMultiSelect)
                Transform.scale(
                  scale: 0.85,
                  child: Checkbox(
                    value: triState,
                    tristate: true,
                    onChanged: onCheckboxChanged,
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.black26, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              // else if (isSelected)
              //   Padding(
              //     padding: const EdgeInsets.only(right: 8, left: 4),
              //     child: Icon(Icons.check_circle_rounded,
              //         color: Colors.blue, size: 18),
              //   )
              else
                const SizedBox(width: 8),
              // Icon/Image
              _TreeItemIcon(
                item: item,
                defaultHeight: defaultIconHeight,
                defaultWidth: defaultIconWidth,
                defaultBorderRadius: defaultIconBorderRadius,
              ),
              if (item.icon != null ||
                  item.iconPath != null ||
                  (item.subItems != null && item.subItems!.isNotEmpty))
                const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  textAlign: itemTextAlign,
                  style:
                      itemTextStyle ??
                      TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: hasChildren
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                ),
              ),
              if (item.suffix != null) ...[
                const SizedBox(width: 8),
                item.suffix!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TreeItemIcon extends StatelessWidget {
  const _TreeItemIcon({
    required this.item,
    required this.defaultHeight,
    required this.defaultWidth,
    required this.defaultBorderRadius,
  });

  final UIHierarchyItem item;
  final double defaultHeight;
  final double defaultWidth;
  final double defaultBorderRadius;

  @override
  Widget build(BuildContext context) {
    if (item.iconPath != null) {
      final path = item.iconPath!;
      return SizedBox(
        width: item.iconWidth ?? defaultWidth,
        height: item.iconHeight ?? defaultHeight,
        child: UIImage(
          path,
          isAsset: !path.startsWith('http'),
          width: item.iconWidth ?? defaultWidth,
          height: item.iconHeight ?? defaultHeight,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(
            item.iconBorderRadius ?? defaultBorderRadius,
          ),
          fallback: Icon(
            Icons.broken_image_rounded,
            color: Colors.black12,
            size: (item.iconWidth ?? defaultWidth) * 0.7,
          ),
        ),
      );
    }

    if (item.icon != null) {
      return Icon(
        item.icon,
        color: item.subItems != null && item.subItems!.isNotEmpty
            ? Colors.amber.shade400
            : Colors.blue.shade400,
        size: 18,
      );
    }

    // Default icon for folders if no custom icon/path is provided
    if (item.subItems != null && item.subItems!.isNotEmpty) {
      return Icon(Icons.folder_rounded, color: Colors.amber.shade400, size: 18);
    }

    return const SizedBox.shrink();
  }
}

class _LoadingItem extends StatefulWidget {
  const _LoadingItem({this.indicator, required this.enableAnimation});

  final Widget? indicator;
  final bool enableAnimation;

  @override
  State<_LoadingItem> createState() => _LoadingItemState();
}

class _LoadingItemState extends State<_LoadingItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    if (widget.enableAnimation) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child =
        widget.indicator ??
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),
        );

    if (!widget.enableAnimation) return child;

    return FadeTransition(opacity: _fadeAnimation, child: child);
  }
}

class _GlassWrap extends StatelessWidget {
  final Widget child;
  final bool isGlassMode;
  final double blur;
  final double connectivity;
  final BorderRadius? borderRadius;

  const _GlassWrap({
    required this.child,
    this.isGlassMode = false,
    this.blur = 10,
    this.connectivity = 0.1,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (!isGlassMode) return child;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: connectivity),
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
