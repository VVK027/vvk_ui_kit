import 'package:flutter/material.dart';

/// Keyboard accessory bar with previous, next, and done actions.
class UIKeyboardToolbar extends StatelessWidget {
  const UIKeyboardToolbar({
    super.key,
    this.doneLabel = 'Done',
    this.backgroundColor,
    this.showPrevious = true,
    this.showNext = true,
    this.showDone = true,
    this.onDone,
    this.height = 44,
  });

  final String doneLabel;
  final Color? backgroundColor;
  final bool showPrevious;
  final bool showNext;
  final bool showDone;
  final VoidCallback? onDone;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.surfaceContainerHighest;

    return Material(
      elevation: 2,
      color: bg,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          child: FocusTraversalGroup(
            descendantsAreFocusable: false,
            descendantsAreTraversable: false,
            child: Row(
              children: [
                if (showPrevious)
                  IconButton(
                    tooltip: 'Previous field',
                    onPressed: () => FocusScope.of(context).previousFocus(),
                    icon: const Icon(Icons.keyboard_arrow_up),
                  ),
                if (showNext)
                  IconButton(
                    tooltip: 'Next field',
                    onPressed: () => FocusScope.of(context).nextFocus(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                const Spacer(),
                if (showDone)
                  TextButton(
                    onPressed: onDone ?? () => FocusScope.of(context).unfocus(),
                    child: Text(doneLabel),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Host that pins [UIKeyboardToolbar] above the software keyboard.
class UIKeyboardToolbarHost extends StatelessWidget {
  const UIKeyboardToolbarHost({
    super.key,
    required this.child,
    this.toolbar = const UIKeyboardToolbar(),
    this.enabled = true,
  });

  final Widget child;
  final UIKeyboardToolbar toolbar;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final inset = MediaQuery.viewInsetsOf(context).bottom;

    return Stack(
      children: [
        child,
        if (inset > 0)
          Positioned(left: 0, right: 0, bottom: inset, child: toolbar),
      ],
    );
  }
}
