import 'package:flutter/material.dart';

/// Theme-aware search field with clear button and optional sort/filter actions.
class UISearchBar extends StatefulWidget {
  const UISearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.hintText = 'Search',
    this.clearTooltip = 'Clear',
    this.ascendingTooltip = 'Ascending',
    this.descendingTooltip = 'Descending',
    this.filterTooltip = 'Filter',
    this.onFilterTap,
    this.onSortDirectionChanged,
    this.backgroundColor,
    this.borderRadius = 12,
    this.height = 48,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction = TextInputAction.search,
    this.onSubmitted,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String hintText;

  /// Tooltip / semantic label for the clear-text button.
  final String clearTooltip;

  /// Tooltip shown on the sort button when the current order is ascending.
  final String ascendingTooltip;

  /// Tooltip shown on the sort button when the current order is descending.
  final String descendingTooltip;

  /// Tooltip / semantic label for the filter button.
  final String filterTooltip;

  final VoidCallback? onFilterTap;
  final ValueChanged<bool>? onSortDirectionChanged;
  final Color? backgroundColor;
  final double borderRadius;
  final double height;
  final bool enabled;
  final bool autofocus;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  /// Builds a search bar using [Theme.of] colors.
  factory UISearchBar.fromTheme(
    BuildContext context, {
    Key? key,
    required ValueChanged<String> onChanged,
    TextEditingController? controller,
    String hintText = 'Search',
    String clearTooltip = 'Clear',
    String ascendingTooltip = 'Ascending',
    String descendingTooltip = 'Descending',
    String filterTooltip = 'Filter',
    VoidCallback? onFilterTap,
    ValueChanged<bool>? onSortDirectionChanged,
    Color? backgroundColor,
    double borderRadius = 12,
    double height = 48,
    bool enabled = true,
    bool autofocus = false,
    TextInputAction textInputAction = TextInputAction.search,
    ValueChanged<String>? onSubmitted,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return UISearchBar(
      key: key,
      onChanged: onChanged,
      controller: controller,
      hintText: hintText,
      clearTooltip: clearTooltip,
      ascendingTooltip: ascendingTooltip,
      descendingTooltip: descendingTooltip,
      filterTooltip: filterTooltip,
      onFilterTap: onFilterTap,
      onSortDirectionChanged: onSortDirectionChanged,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
      borderRadius: borderRadius,
      height: height,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
    );
  }

  @override
  State<UISearchBar> createState() => _UISearchBarState();
}

class _UISearchBarState extends State<UISearchBar>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final bool _ownsController;
  late final AnimationController _sortRotationController;
  bool _sortAscending = true;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleTextChanged);
    _sortRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    _sortRotationController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText == _hasText) return;
    setState(() => _hasText = hasText);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
      if (_sortAscending) {
        _sortRotationController.reverse(from: 0.5);
      } else {
        _sortRotationController.forward(from: 0);
      }
    });
    widget.onSortDirectionChanged?.call(_sortAscending);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fillColor =
        widget.backgroundColor ?? scheme.surfaceContainerHighest;
    final borderColor = scheme.outlineVariant;

    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              textInputAction: widget.textInputAction,
              onSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurface,
              ),
              cursorColor: scheme.primary,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: fillColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: scheme.onSurfaceVariant,
                ),
                suffixIcon: _hasText
                    ? IconButton(
                        key: const Key('ui_search_bar_clear'),
                        tooltip: widget.clearTooltip,
                        icon: Icon(
                          Icons.clear_rounded,
                          color: scheme.onSurfaceVariant,
                        ),
                        onPressed: widget.enabled ? _clear : null,
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(color: scheme.primary, width: 1.5),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(
                    color: borderColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          if (widget.onSortDirectionChanged != null) ...[
            const SizedBox(width: 4),
            RotationTransition(
              turns: Tween<double>(begin: 0, end: 1).animate(
                _sortRotationController,
              ),
              child: IconButton(
                key: const Key('ui_search_bar_sort'),
                tooltip: _sortAscending
                    ? widget.ascendingTooltip
                    : widget.descendingTooltip,
                onPressed: widget.enabled ? _toggleSort : null,
                icon: Icon(
                  Icons.arrow_downward_rounded,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          if (widget.onFilterTap != null) ...[
            IconButton(
              key: const Key('ui_search_bar_filter'),
              tooltip: widget.filterTooltip,
              onPressed: widget.enabled ? widget.onFilterTap : null,
              icon: Icon(
                Icons.tune_rounded,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
