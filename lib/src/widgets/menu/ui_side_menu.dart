import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// Controller for imperatively managing [UISideMenu] open/close state.
class UISideMenuController extends ChangeNotifier {
  UISideMenuState? _state;

  void _attach(UISideMenuState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Whether the side menu is currently open.
  bool get isOpened => _state?.isOpened ?? false;

  /// Opens the side menu.
  void open() {
    _state?.openSideMenu();
    notifyListeners();
  }

  /// Closes the side menu.
  void close() {
    _state?.closeSideMenu();
    notifyListeners();
  }

  /// Toggles the side menu between open and closed states.
  void toggle() {
    if (isOpened) {
      close();
    } else {
      open();
    }
  }
}

/// Animation style for [UISideMenu].
enum UISideMenuType { slide }

/// Slide-out side menu that overlays or pushes the main [child] content.
class UISideMenu extends StatefulWidget {
  final int _inverse;
  final Widget child;
  final Color? background;
  final BorderRadius? radius;
  final Widget menu;
  final double maxMenuWidth;
  final UISideMenuType type;
  final void Function(bool isOpened)? onChange;
  final UISideMenuController? controller;

  const UISideMenu({
    super.key,
    required this.child,
    this.background,
    this.radius,
    required this.menu,
    this.type = UISideMenuType.slide,
    this.maxMenuWidth = 275.0,
    bool inverse = false,
    this.onChange,
    this.controller,
  }) : assert(maxMenuWidth > 0),
       _inverse = inverse ? -1 : 1;

  UISideMenu copyWith({
    Key? key,
    Widget? child,
    Color? background,
    BorderRadius? radius,
    Widget? menu,
    UISideMenuType? type,
    double? maxMenuWidth,
    bool? inverse,
    void Function(bool isOpened)? onChange,
    UISideMenuController? controller,
  }) {
    return UISideMenu(
      key: key ?? this.key,
      background: background ?? this.background,
      radius: radius ?? this.radius,
      menu: menu ?? this.menu,
      type: type ?? this.type,
      maxMenuWidth: maxMenuWidth ?? this.maxMenuWidth,
      inverse: inverse ?? this.inverse,
      onChange: onChange ?? this.onChange,
      controller: controller ?? this.controller,
      child: child ?? this.child,
    );
  }

  static UISideMenuState? of(BuildContext? context) {
    assert(context != null);
    return context?.findAncestorStateOfType<UISideMenuState>();
  }

  bool get inverse => _inverse == -1;

  @override
  UISideMenuState createState() => UISideMenuState();
}

/// State for [UISideMenu] with imperative open/close helpers.
class UISideMenuState extends State<UISideMenu> {
  late bool _opened;

  void openSideMenu() {
    setState(() => _opened = true);
    widget.onChange?.call(true);
  }

  void closeSideMenu() {
    setState(() => _opened = false);
    widget.onChange?.call(false);
  }

  bool get isOpened => _opened;

  @override
  void initState() {
    super.initState();
    _opened = false;
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(UISideMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final statusBarHeight = mq.padding.top;
    final theme = Theme.of(context);
    final backgroundColor =
        widget.background ?? theme.colorScheme.surfaceContainer;

    return Material(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: statusBarHeight,
            bottom: 0,
            width: size.width * 0.70 > widget.maxMenuWidth
                ? widget.maxMenuWidth
                : size.width * 0.70,
            right: widget._inverse == 1 ? null : 0,
            child: widget.menu,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastLinearToSlowEaseIn,
            alignment: Alignment.topLeft,
            transform: _getMatrix4(size),
            child: GestureDetector(
              onTap: _opened ? closeSideMenu : null,
              behavior: _opened
                  ? HitTestBehavior.opaque
                  : HitTestBehavior.deferToChild,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  Matrix4 _getMatrix4(Size size) {
    if (_opened) {
      final menuWidth = size.width * 0.70 > widget.maxMenuWidth
          ? widget.maxMenuWidth
          : size.width * 0.70;
      return Matrix4.identity()
        ..translateByDouble(menuWidth * widget._inverse, 0.0, 0.0, 1.0);
    }
    return Matrix4.identity();
  }
}
