import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// One action inside a [UIMenuBar] flyout.
class UIMenuBarAction {
  const UIMenuBarAction({
    required this.label,
    this.icon,
    this.onTap,
    this.enabled = true,
    this.destructive = false,
    this.children = const [],
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;
  final bool destructive;
  final List<UIMenuBarAction> children;

  bool get hasSubmenu => children.isNotEmpty;
}

/// Top-level menu in [UIMenuBar] (for example File, Edit).
class UIMenuBarItem {
  const UIMenuBarItem({
    required this.label,
    required this.actions,
  });

  final String label;
  final List<UIMenuBarAction> actions;
}

/// Horizontal desktop-style menu bar with dropdown flyouts.
class UIMenuBar extends StatefulWidget {
  const UIMenuBar({
    super.key,
    required this.items,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
    this.showBottomBorder = true,
  });

  final List<UIMenuBarItem> items;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final bool showBottomBorder;

  factory UIMenuBar.fromTheme(
    BuildContext context, {
    Key? key,
    required List<UIMenuBarItem> items,
    double height = 40,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 8),
    Color? backgroundColor,
    Color? borderColor,
    TextStyle? textStyle,
    bool showBottomBorder = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return UIMenuBar(
      key: key,
      items: items,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor ?? scheme.surfaceContainerLow,
      borderColor: borderColor ?? scheme.outlineVariant,
      textStyle: textStyle ?? theme.textTheme.labelLarge,
      showBottomBorder: showBottomBorder,
    );
  }

  @override
  State<UIMenuBar> createState() => _UIMenuBarState();
}

class _UIMenuBarState extends State<UIMenuBar> {
  final Map<String, GlobalKey> _itemKeys = {};
  OverlayEntry? _entry;
  String? _openLabel;

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  void _closeMenu() {
    _entry?.remove();
    _entry = null;
    _openLabel = null;
  }

  void _toggleMenu(UIMenuBarItem item) {
    if (_openLabel == item.label) {
      setState(_closeMenu);
      return;
    }

    _closeMenu();
    final key = _itemKeys[item.label]!;
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final offset = box.localToGlobal(Offset.zero);
    final overlay = Overlay.of(context);

    _openLabel = item.label;
    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(_closeMenu),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + box.size.height,
              child: _UIMenuBarPanel(
                actions: item.actions,
                onClose: () => setState(_closeMenu),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_entry!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    for (final item in widget.items) {
      _itemKeys.putIfAbsent(item.label, GlobalKey.new);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.showBottomBorder
            ? Border(bottom: BorderSide(color: widget.borderColor!))
            : null,
      ),
      child: SizedBox(
        height: widget.height,
        child: Padding(
          padding: widget.padding,
          child: Row(
            children: [
              for (final item in widget.items)
                _MenuBarButton(
                  key: _itemKeys[item.label],
                  label: item.label,
                  selected: _openLabel == item.label,
                  textStyle: widget.textStyle,
                  onPressed: () => _toggleMenu(item),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuBarButton extends StatelessWidget {
  const _MenuBarButton({
    super.key,
    required this.label,
    required this.selected,
    required this.textStyle,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.surfaceContainerHighest : Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: UIText(label, style: textStyle),
        ),
      ),
    );
  }
}

class _UIMenuBarPanel extends StatelessWidget {
  const _UIMenuBarPanel({
    required this.actions,
    required this.onClose,
  });

  final List<UIMenuBarAction> actions;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      color: scheme.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              _UIMenuBarActionRow(
                action: actions[i],
                onClose: onClose,
              ),
              if (i < actions.length - 1)
                Divider(height: 1, color: scheme.outlineVariant),
            ],
          ],
        ),
      ),
    );
  }
}

class _UIMenuBarActionRow extends StatefulWidget {
  const _UIMenuBarActionRow({
    required this.action,
    required this.onClose,
  });

  final UIMenuBarAction action;
  final VoidCallback onClose;

  @override
  State<_UIMenuBarActionRow> createState() => _UIMenuBarActionRowState();
}

class _UIMenuBarActionRowState extends State<_UIMenuBarActionRow> {
  OverlayEntry? _submenuEntry;

  @override
  void dispose() {
    _closeSubmenu();
    super.dispose();
  }

  void _closeSubmenu() {
    _submenuEntry?.remove();
    _submenuEntry = null;
  }

  void _openSubmenu(RenderBox anchor) {
    _closeSubmenu();
    final offset = anchor.localToGlobal(Offset.zero);
    final overlay = Overlay.of(context);

    _submenuEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              left: offset.dx + anchor.size.width - 4,
              top: offset.dy,
              child: Material(
                elevation: 8,
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 180),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final child in widget.action.children)
                        _UIMenuBarLeafRow(
                          action: child,
                          onClose: () {
                            _closeSubmenu();
                            widget.onClose();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_submenuEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final action = widget.action;
    final color = action.destructive
        ? scheme.error
        : action.enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.enabled && !action.hasSubmenu
            ? () {
                widget.onClose();
                action.onTap?.call();
              }
            : null,
        onHover: action.hasSubmenu
            ? (_) {
                final box = context.findRenderObject() as RenderBox?;
                if (box != null) _openSubmenu(box);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (action.icon != null) ...[
                Icon(action.icon, size: 18, color: color),
                const SizedBox(width: 8),
              ] else
                const SizedBox(width: 26),
              Expanded(
                child: UIText(
                  action.label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: color),
                ),
              ),
              if (action.hasSubmenu)
                Icon(Icons.chevron_right, size: 18, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _UIMenuBarLeafRow extends StatelessWidget {
  const _UIMenuBarLeafRow({
    required this.action,
    required this.onClose,
  });

  final UIMenuBarAction action;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = action.destructive
        ? scheme.error
        : action.enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);

    return InkWell(
      onTap: action.enabled
          ? () {
              onClose();
              action.onTap?.call();
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(action.icon, size: 18, color: color),
              const SizedBox(width: 8),
            ] else
              const SizedBox(width: 26),
            Expanded(
              child: UIText(
                action.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
