import 'package:flutter/material.dart';

/// One swipe-revealed action behind [UISwipeActionTile].
class UISwipeAction {
  const UISwipeAction({
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
    this.label,
  });

  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;
  final String? label;
}

/// List tile that reveals trailing actions when swiped left.
class UISwipeActionTile extends StatefulWidget {
  const UISwipeActionTile({
    super.key,
    required this.child,
    required this.actions,
    this.actionWidth = 80,
    this.animationDuration = const Duration(milliseconds: 200),
    this.actionThreshold = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
  }) : assert(actions.length > 0, 'At least one action is required.');

  final Widget child;
  final List<UISwipeAction> actions;
  final double actionWidth;
  final Duration animationDuration;
  final double actionThreshold;
  final BorderRadius borderRadius;
  final Color? backgroundColor;

  @override
  State<UISwipeActionTile> createState() => _UISwipeActionTileState();
}

class _UISwipeActionTileState extends State<UISwipeActionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragExtent = 0;
  double _maxSlide = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maxSlide = widget.actionWidth * widget.actions.length;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragExtent = _maxSlide * _controller.value;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    _dragExtent = (_dragExtent - delta).clamp(0.0, _maxSlide);
    _controller.value = _dragExtent / _maxSlide;
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 0) {
      _controller.reverse();
    } else if (velocity < 0) {
      _controller.forward();
    } else if (_controller.value > widget.actionThreshold) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _resetPosition() {
    _controller.reverse();
  }

  void _handleActionTap(UISwipeAction action) {
    action.onTap();
    _resetPosition();
  }

  BorderRadius _actionBorderRadius(int index) {
    final isFirst = index == 0;
    final isLast = index == widget.actions.length - 1;

    return BorderRadius.only(
      topLeft: isLast ? widget.borderRadius.topLeft : Radius.zero,
      bottomLeft: isLast ? widget.borderRadius.bottomLeft : Radius.zero,
      topRight: isFirst ? widget.borderRadius.topRight : Radius.zero,
      bottomRight: isFirst ? widget.borderRadius.bottomRight : Radius.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.surface;

    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var index = 0; index < widget.actions.length; index++)
                    _ActionButton(
                      action: widget.actions[index],
                      width: widget.actionWidth,
                      borderRadius: _actionBorderRadius(index),
                      onTap: () => _handleActionTap(widget.actions[index]),
                    ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Transform.translate(
                offset: Offset(-_maxSlide * _animation.value, 0),
                child: GestureDetector(
                  onTap: _resetPosition,
                  onHorizontalDragStart: _handleDragStart,
                  onHorizontalDragUpdate: _handleDragUpdate,
                  onHorizontalDragEnd: _handleDragEnd,
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: widget.borderRadius,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    required this.width,
    required this.borderRadius,
    required this.onTap,
  });

  final UISwipeAction action;
  final double width;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: action.backgroundColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: Colors.white, size: 20),
              if (action.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  action.label!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
