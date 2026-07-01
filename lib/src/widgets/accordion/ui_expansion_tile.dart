import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Visual styling for `UIExpansionTile` and `UIExpansionAccordItem`.
class UIExpansionTileStyle {
  const UIExpansionTileStyle({
    required this.borderColor,
    required this.titleStyle,
    required this.iconColor,
    this.expandedTitleColor,
    this.collapsedTitleColor,
    this.borderRadius = 12,
    this.headerHeight = 48,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 8),
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.uppercaseTitle = false,
    this.useInkWell = false,
    this.animatedExpansion = false,
  });

  final Color borderColor;
  final TextStyle titleStyle;
  final Color iconColor;
  final Color? expandedTitleColor;
  final Color? collapsedTitleColor;
  final double borderRadius;
  final double headerHeight;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry headerPadding;
  final bool uppercaseTitle;
  final bool useInkWell;
  final bool animatedExpansion;

  bool get hasAccordionColors =>
      expandedTitleColor != null || collapsedTitleColor != null;

  UIExpansionTileStyle copyWith({
    Color? borderColor,
    TextStyle? titleStyle,
    Color? iconColor,
    Color? expandedTitleColor,
    Color? collapsedTitleColor,
    double? borderRadius,
    double? headerHeight,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? headerPadding,
    bool? uppercaseTitle,
    bool? useInkWell,
    bool? animatedExpansion,
  }) {
    return UIExpansionTileStyle(
      borderColor: borderColor ?? this.borderColor,
      titleStyle: titleStyle ?? this.titleStyle,
      iconColor: iconColor ?? this.iconColor,
      expandedTitleColor: expandedTitleColor ?? this.expandedTitleColor,
      collapsedTitleColor: collapsedTitleColor ?? this.collapsedTitleColor,
      borderRadius: borderRadius ?? this.borderRadius,
      headerHeight: headerHeight ?? this.headerHeight,
      contentPadding: contentPadding ?? this.contentPadding,
      headerPadding: headerPadding ?? this.headerPadding,
      uppercaseTitle: uppercaseTitle ?? this.uppercaseTitle,
      useInkWell: useInkWell ?? this.useInkWell,
      animatedExpansion: animatedExpansion ?? this.animatedExpansion,
    );
  }
}

/// Accordion-style configuration used by `UIExpansionAccordItem`.
typedef UIAccordionItemStyle = UIExpansionTileStyle;

/// Expandable tile with header, trailing icon, and collapsible body content.
class UIExpansionTile extends StatefulWidget {
  const UIExpansionTile({
    required this.title,
    required this.children,
    required this.style,
    super.key,
    this.titleChild,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.trailingIcon,
  });

  final String title;
  final Widget? titleChild;
  final bool initiallyExpanded;
  final List<Widget> children;
  final UIExpansionTileStyle style;
  final void Function(bool expanded)? onExpansionChanged;
  final Widget? trailingIcon;

  UIExpansionTile copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    bool? initiallyExpanded,
    List<Widget>? children,
    UIExpansionTileStyle? style,
    void Function(bool expanded)? onExpansionChanged,
    Widget? trailingIcon,
  }) {
    return UIExpansionTile(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      style: style ?? this.style,
      onExpansionChanged: onExpansionChanged ?? this.onExpansionChanged,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      children: children ?? this.children,
    );
  }

  @override
  State<UIExpansionTile> createState() => _UIExpansionTileState();
}

class _UIExpansionTileState extends State<UIExpansionTile> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant UIExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      setState(() => _expanded = widget.initiallyExpanded);
    }
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpansionChanged?.call(_expanded);
  }

  Color _titleColor() {
    if (!widget.style.hasAccordionColors) {
      return widget.style.titleStyle.color ?? widget.style.iconColor;
    }
    return _expanded
        ? (widget.style.expandedTitleColor ?? widget.style.iconColor)
        : (widget.style.collapsedTitleColor ?? widget.style.iconColor);
  }

  String get _displayTitle {
    return widget.style.uppercaseTitle
        ? widget.title.toUpperCase()
        : widget.title;
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = _titleColor();
    final titleWidget =
        widget.titleChild ??
        UIText(
          _displayTitle,
          style: widget.style.titleStyle.copyWith(color: titleColor),
        );
    final trailing = AnimatedRotation(
      turns: _expanded ? 0.5 : 0,
      duration: const Duration(milliseconds: 100),
      child:
          widget.trailingIcon ??
          Icon(Icons.keyboard_arrow_down, color: titleColor),
    );

    final header = widget.style.useInkWell
        ? Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(widget.style.borderRadius),
            ),
            child: InkWell(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(widget.style.borderRadius),
              ),
              onTap: _toggle,
              child: _headerRow(titleWidget, trailing),
            ),
          )
        : GestureDetector(
            onTap: _toggle,
            child: _headerRow(titleWidget, trailing),
          );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.style.borderColor),
        borderRadius: BorderRadius.circular(widget.style.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          if (widget.style.animatedExpansion)
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: ConstrainedBox(
                constraints: _expanded
                    ? const BoxConstraints()
                    : const BoxConstraints(maxHeight: 0),
                child: _content(),
              ),
            )
          else if (_expanded)
            _content(),
        ],
      ),
    );
  }

  Widget _headerRow(Widget titleWidget, Widget trailing) {
    return Container(
      height: widget.style.headerHeight,
      padding: widget.style.headerPadding,
      alignment: widget.style.useInkWell ? Alignment.centerLeft : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: titleWidget),
          trailing,
        ],
      ),
    );
  }

  Widget _content() {
    return Container(
      padding: widget.style.contentPadding,
      child: Column(children: widget.children),
    );
  }
}
