import 'package:flutter/material.dart';
import '../navigation/ui_context_menu.dart';
import '../text/ui_text.dart';

/// One action in the menu opened by [UISplitButton].
class UISplitButtonMenuItem {
  const UISplitButtonMenuItem({
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

  UIContextMenuItem toContextMenuItem() {
    return UIContextMenuItem.fromAction(
      label: label,
      icon: icon,
      onTap: onTap,
      enabled: enabled,
      destructive: destructive,
    );
  }
}

/// Button with a primary action and a chevron that opens a menu.
///
/// ```dart
/// UISplitButton.fromTheme(
///   context,
///   label: 'Save',
///   onPressed: save,
///   menuItems: [
///     UISplitButtonMenuItem(label: 'Save as draft', onTap: saveDraft),
///     UISplitButtonMenuItem(label: 'Discard', onTap: discard, destructive: true),
///   ],
/// )
/// ```
class UISplitButton extends StatefulWidget {
  UISplitButton({
    super.key,
    required this.child,
    this.onPressed,
    this.menuItems = const [],
    this.menu,
    this.enabled = true,
    this.height = 40,
    this.borderRadius = 8,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.dividerColor,
    this.menuMinWidth = 180,
    this.semanticsLabel,
    this.menuSemanticsLabel = 'More actions',
  }) : assert(
         menu != null || menuItems.isNotEmpty,
         'Provide menuItems or menu.',
       );

  final Widget child;
  final VoidCallback? onPressed;
  final List<UISplitButtonMenuItem> menuItems;
  final Widget? menu;
  final bool enabled;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final Color? dividerColor;
  final double menuMinWidth;

  /// Accessibility label for the primary action. Defaults to the visible label.
  final String? semanticsLabel;

  /// Accessibility label for the chevron that opens the menu.
  final String menuSemanticsLabel;

  factory UISplitButton.fromTheme(
    BuildContext context, {
    Key? key,
    String? label,
    Widget? child,
    VoidCallback? onPressed,
    List<UISplitButtonMenuItem> menuItems = const [],
    Widget? menu,
    bool enabled = true,
    double height = 40,
    double borderRadius = 8,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    Color? dividerColor,
    double menuMinWidth = 180,
    String? semanticsLabel,
    String menuSemanticsLabel = 'More actions',
  }) {
    final scheme = Theme.of(context).colorScheme;
    assert(
      child != null || label != null,
      'Either label or child must be provided.',
    );
    final resolvedChild =
        child ??
        UIText(
          label!,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        );
    return UISplitButton(
      key: key,
      onPressed: onPressed,
      menuItems: menuItems,
      menu: menu,
      enabled: enabled,
      height: height,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? scheme.surface,
      foregroundColor: foregroundColor ?? scheme.primary,
      borderColor: borderColor ?? scheme.outline,
      dividerColor: dividerColor ?? scheme.outlineVariant,
      menuMinWidth: menuMinWidth,
      semanticsLabel: semanticsLabel,
      menuSemanticsLabel: menuSemanticsLabel,
      child: resolvedChild,
    );
  }

  @override
  State<UISplitButton> createState() => _UISplitButtonState();
}

class _UISplitButtonState extends State<UISplitButton> {
  final _menuKey = GlobalKey();

  Future<void> _openMenu() async {
    if (!widget.enabled) return;

    if (widget.menu != null) {
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) =>
            Padding(padding: const EdgeInsets.all(16), child: widget.menu!),
      );
      return;
    }

    final box = _menuKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;
    await showUIContextMenu(
      context: context,
      position: Offset(offset.dx, offset.dy + size.height + 4),
      minWidth: widget.menuMinWidth,
      items: widget.menuItems.map((item) => item.toContextMenuItem()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final fg = widget.foregroundColor ?? Theme.of(context).colorScheme.primary;
    final border = widget.borderColor ?? Theme.of(context).colorScheme.outline;
    final divider =
        widget.dividerColor ?? Theme.of(context).colorScheme.outlineVariant;
    final radius = BorderRadius.circular(widget.borderRadius);

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.enabled ? bg : bg.withValues(alpha: 0.6),
          borderRadius: radius,
          border: Border.all(color: border),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: SizedBox(
            height: widget.height,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MaybeSemantics(
                  label: widget.semanticsLabel,
                  enabled: widget.enabled && widget.onPressed != null,
                  child: InkWell(
                    onTap: widget.enabled ? widget.onPressed : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IconTheme.merge(
                        data: IconThemeData(color: fg, size: 18),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(color: fg),
                          child: widget.child,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                  height: double.infinity,
                  child: ColoredBox(color: divider),
                ),
                _MaybeSemantics(
                  label: widget.menuSemanticsLabel,
                  enabled: widget.enabled,
                  child: InkWell(
                    key: _menuKey,
                    onTap: widget.enabled ? _openMenu : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.expand_more, color: fg, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps [child] in a [Semantics] button node only when a [label] is provided,
/// avoiding a redundant label that would concatenate with visible child text.
class _MaybeSemantics extends StatelessWidget {
  const _MaybeSemantics({
    required this.child,
    required this.enabled,
    this.label,
  });

  final Widget child;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) return child;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: child,
    );
  }
}
