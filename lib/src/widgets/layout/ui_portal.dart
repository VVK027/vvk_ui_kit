import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Alignment pair used to position a [UIPortal] overlay relative to its anchor.
@immutable
class UIPortalAnchor {
  const UIPortalAnchor({
    this.targetAnchor = Alignment.bottomCenter,
    this.followerAnchor = Alignment.topCenter,
    this.offset = Offset.zero,
  });

  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Offset offset;

  UIPortalAnchor copyWith({
    Alignment? targetAnchor,
    Alignment? followerAnchor,
    Offset? offset,
  }) {
    return UIPortalAnchor(
      targetAnchor: targetAnchor ?? this.targetAnchor,
      followerAnchor: followerAnchor ?? this.followerAnchor,
      offset: offset ?? this.offset,
    );
  }
}

/// Anchors [child] and renders [overlay] in the root [Overlay] when [visible].
///
/// Uses [CompositedTransformTarget] / [CompositedTransformFollower] so the
/// overlay tracks the anchor during scroll and resize without extra packages.
class UIPortal extends StatefulWidget {
  const UIPortal({
    super.key,
    required this.child,
    required this.overlay,
    this.visible = false,
    this.anchor = const UIPortalAnchor(),
    this.showWhenUnlinked = false,
    this.rootOverlay = true,
  });

  final Widget child;
  final Widget overlay;
  final bool visible;
  final UIPortalAnchor anchor;
  final bool showWhenUnlinked;
  final bool rootOverlay;

  @override
  State<UIPortal> createState() => _UIPortalState();
}

class _UIPortalState extends State<UIPortal> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _scheduleOverlayUpdate();
  }

  @override
  void didUpdateWidget(UIPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible ||
        oldWidget.overlay != widget.overlay ||
        oldWidget.anchor != widget.anchor ||
        oldWidget.showWhenUnlinked != widget.showWhenUnlinked ||
        oldWidget.rootOverlay != widget.rootOverlay) {
      _scheduleOverlayUpdate();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _scheduleOverlayUpdate() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.visible) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    final overlay = Overlay.maybeOf(context, rootOverlay: widget.rootOverlay);
    if (overlay == null) return;

    _entry ??= OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: widget.showWhenUnlinked,
          targetAnchor: widget.anchor.targetAnchor,
          followerAnchor: widget.anchor.followerAnchor,
          offset: widget.anchor.offset,
          child: widget.overlay,
        );
      },
    );

    if (!_entry!.mounted) {
      overlay.insert(_entry!);
    } else {
      _entry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _link, child: widget.child);
  }
}

/// Controller for toggling a [UIAnchoredOverlay].
class UIAnchoredOverlayController extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void show() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  void hide() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}

/// Higher-level anchored overlay with optional tap-outside dismiss.
class UIAnchoredOverlay extends StatefulWidget {
  const UIAnchoredOverlay({
    super.key,
    required this.anchor,
    required this.overlay,
    this.controller,
    this.anchorAlignment = const UIPortalAnchor(),
    this.dismissOnTapOutside = true,
    this.rootOverlay = true,
  });

  final Widget anchor;
  final Widget overlay;
  final UIAnchoredOverlayController? controller;
  final UIPortalAnchor anchorAlignment;
  final bool dismissOnTapOutside;
  final bool rootOverlay;

  @override
  State<UIAnchoredOverlay> createState() => _UIAnchoredOverlayState();
}

class _UIAnchoredOverlayState extends State<UIAnchoredOverlay> {
  UIAnchoredOverlayController? _ownedController;
  late UIAnchoredOverlayController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? UIAnchoredOverlayController();
    if (widget.controller == null) {
      _ownedController = _controller;
    }
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(UIAnchoredOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      _ownedController?.dispose();
      _ownedController = null;
      _controller = widget.controller ?? UIAnchoredOverlayController();
      if (widget.controller == null) {
        _ownedController = _controller;
      }
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _ownedController?.dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  void _dismiss() {
    if (widget.dismissOnTapOutside) {
      _controller.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlay = Material(color: Colors.transparent, child: widget.overlay);

    return UIPortal(
      visible: _controller.isOpen,
      anchor: widget.anchorAlignment,
      rootOverlay: widget.rootOverlay,
      overlay: widget.dismissOnTapOutside
          ? TapRegion(onTapOutside: (_) => _dismiss(), child: overlay)
          : overlay,
      child: widget.anchor,
    );
  }
}
