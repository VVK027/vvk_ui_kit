import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// One action inside a [UIContextMenu].
class UIContextMenuItem {
  const UIContextMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.enabled = true,
    this.destructive = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;
  final bool destructive;

  /// Builds a [UIContextMenuItem] from common action fields.
  ///
  /// Used by [UISplitButtonMenuItem] and [UICommandBarItem] to avoid duplicating
  /// menu-item mapping logic.
  static UIContextMenuItem fromAction({
    required String label,
    IconData? icon,
    VoidCallback? onTap,
    bool enabled = true,
    bool destructive = false,
  }) {
    return UIContextMenuItem(
      label: label,
      icon: icon,
      onTap: onTap,
      enabled: enabled,
      destructive: destructive,
    );
  }
}

/// Shows a styled context menu at [position].
Future<void> showUIContextMenu({
  required BuildContext context,
  required Offset position,
  required List<UIContextMenuItem> items,
  double minWidth = 180,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  void close() {
    entry.remove();
  }

  entry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: close,
              behavior: HitTestBehavior.opaque,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: _UIContextMenuPanel(
              items: items,
              minWidth: minWidth,
              onClose: close,
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(entry);
  return Future<void>.value();
}

class _UIContextMenuPanel extends StatelessWidget {
  const _UIContextMenuPanel({
    required this.items,
    required this.minWidth,
    required this.onClose,
  });

  final List<UIContextMenuItem> items;
  final double minWidth;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      elevation: 8,
      color: scheme.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              _UIContextMenuRow(
                item: items[i],
                onSelected: () {
                  onClose();
                  items[i].onTap?.call();
                },
              ),
              if (i < items.length - 1)
                Divider(height: 1, color: scheme.outlineVariant),
            ],
          ],
        ),
      ),
    );
  }
}

class _UIContextMenuRow extends StatelessWidget {
  const _UIContextMenuRow({required this.item, required this.onSelected});

  final UIContextMenuItem item;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = !item.enabled
        ? scheme.outline
        : item.destructive
        ? scheme.error
        : scheme.onSurface;

    return InkWell(
      onTap: item.enabled ? onSelected : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, size: 18, color: color),
              const SizedBox(width: 10),
            ],
            UIText(
              item.label,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wraps [child] and opens a [UIContextMenu] on long-press.
class UIContextMenuRegion extends StatelessWidget {
  const UIContextMenuRegion({
    super.key,
    required this.child,
    required this.items,
    this.enabled = true,
  });

  final Widget child;
  final List<UIContextMenuItem> items;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: enabled
          ? (details) {
              showUIContextMenu(
                context: context,
                position: details.globalPosition,
                items: items,
              );
            }
          : null,
      onSecondaryTapDown: enabled
          ? (details) {
              showUIContextMenu(
                context: context,
                position: details.globalPosition,
                items: items,
              );
            }
          : null,
      child: child,
    );
  }
}
