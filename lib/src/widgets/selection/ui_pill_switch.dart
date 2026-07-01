import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/core/utils/adaptive_platform_util.dart';

/// A customizable pill-shaped toggle switch with optional ON/OFF labels.
///
/// Set [adaptive] to render a native [CupertinoSwitch] on iOS/macOS while
/// keeping the custom pill design on other platforms.
class UIPillSwitch extends StatefulWidget {
  const UIPillSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.adaptive = false,
    this.forceCupertino = false,
    this.forceMaterial = false,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.toggleColor,
    this.activeToggleColor,
    this.inactiveToggleColor,
    this.width = 70.0,
    this.height = 35.0,
    this.toggleSize = 25.0,
    this.valueFontSize = 16.0,
    this.borderRadius = 20.0,
    this.padding = 4.0,
    this.showOnOff = false,
    this.activeText,
    this.inactiveText,
    this.activeTextFontWeight,
    this.inactiveTextFontWeight,
    this.switchBorder,
    this.activeSwitchBorder,
    this.inactiveSwitchBorder,
    this.toggleBorder,
    this.activeToggleBorder,
    this.inactiveToggleBorder,
    this.activeIcon,
    this.inactiveIcon,
    this.duration = const Duration(milliseconds: 200),
    this.disabled = false,
  }) : assert(
         (switchBorder == null || activeSwitchBorder == null) &&
             (switchBorder == null || inactiveSwitchBorder == null),
         'Cannot provide switchBorder when activeSwitchBorder or '
         'inactiveSwitchBorder is set.',
       ),
       assert(
         (toggleBorder == null || activeToggleBorder == null) &&
             (toggleBorder == null || inactiveToggleBorder == null),
         'Cannot provide toggleBorder when activeToggleBorder or '
         'inactiveToggleBorder is set.',
       );

  /// Creates a [UIPillSwitch] with colors from [Theme.of(context)].
  factory UIPillSwitch.fromTheme({
    Key? key,
    required bool value,
    required ValueChanged<bool> onChanged,
    double width = 70,
    double height = 35,
    bool showOnOff = false,
    String? activeText,
    String? inactiveText,
    bool disabled = false,
    bool adaptive = false,
    bool forceCupertino = false,
    bool forceMaterial = false,
  }) {
    return UIPillSwitch(
      key: key,
      value: value,
      onChanged: onChanged,
      width: width,
      height: height,
      showOnOff: showOnOff,
      activeText: activeText,
      inactiveText: inactiveText,
      disabled: disabled,
      adaptive: adaptive,
      forceCupertino: forceCupertino,
      forceMaterial: forceMaterial,
    );
  }

  final bool value;
  final ValueChanged<bool> onChanged;

  /// When true, renders a native [CupertinoSwitch] on Apple platforms.
  final bool adaptive;

  /// Forces the Cupertino variant regardless of platform when [adaptive].
  final bool forceCupertino;

  /// Forces the Material pill variant regardless of platform when [adaptive].
  final bool forceMaterial;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? toggleColor;
  final Color? activeToggleColor;
  final Color? inactiveToggleColor;
  final double width;
  final double height;
  final double toggleSize;
  final double valueFontSize;
  final double borderRadius;
  final double padding;
  final bool showOnOff;
  final String? activeText;
  final String? inactiveText;
  final FontWeight? activeTextFontWeight;
  final FontWeight? inactiveTextFontWeight;
  final BoxBorder? switchBorder;
  final BoxBorder? activeSwitchBorder;
  final BoxBorder? inactiveSwitchBorder;
  final BoxBorder? toggleBorder;
  final BoxBorder? activeToggleBorder;
  final BoxBorder? inactiveToggleBorder;
  final Widget? activeIcon;
  final Widget? inactiveIcon;
  final Duration duration;
  final bool disabled;

  @override
  State<UIPillSwitch> createState() => _UIPillSwitchState();
}

class _UIPillSwitchState extends State<UIPillSwitch>
    with SingleTickerProviderStateMixin {
  late final Animation<Alignment> _toggleAnimation;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
      duration: widget.duration,
    );
    _toggleAnimation =
        AlignmentTween(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.linear),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UIPillSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) return;
    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (widget.adaptive &&
        useAdaptiveCupertino(
          forceCupertino: widget.forceCupertino,
          forceMaterial: widget.forceMaterial,
        )) {
      return CupertinoSwitch(
        value: widget.value,
        onChanged: widget.disabled ? null : widget.onChanged,
        activeTrackColor: widget.activeColor ?? scheme.primary,
      );
    }

    final activeColor = widget.activeColor ?? scheme.primary;
    final inactiveColor =
        widget.inactiveColor ?? scheme.surfaceContainerHighest;
    final toggleColor = widget.toggleColor ?? scheme.onPrimary;
    final activeTextColor = widget.activeTextColor ?? scheme.onPrimary;
    final inactiveTextColor =
        widget.inactiveTextColor ?? scheme.onSurfaceVariant;

    Color resolvedToggleColor;
    Color switchColor;
    Border? switchBorder;
    Border? toggleBorder;

    if (widget.value) {
      resolvedToggleColor = widget.activeToggleColor ?? toggleColor;
      switchColor = activeColor;
      switchBorder =
          widget.activeSwitchBorder as Border? ??
          widget.switchBorder as Border?;
      toggleBorder =
          widget.activeToggleBorder as Border? ??
          widget.toggleBorder as Border?;
    } else {
      resolvedToggleColor = widget.inactiveToggleColor ?? toggleColor;
      switchColor = inactiveColor;
      switchBorder =
          widget.inactiveSwitchBorder as Border? ??
          widget.switchBorder as Border?;
      toggleBorder =
          widget.inactiveToggleBorder as Border? ??
          widget.toggleBorder as Border?;
    }

    final textSpace = widget.width - widget.toggleSize;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: widget.width,
          child: Align(
            child: GestureDetector(
              onTap: () {
                if (widget.disabled) return;
                widget.onChanged(!widget.value);
              },
              child: Opacity(
                opacity: widget.disabled ? 0.6 : 1,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  padding: EdgeInsets.all(widget.padding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    color: switchColor,
                    border: switchBorder,
                  ),
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: widget.value ? 1.0 : 0.0,
                        duration: widget.duration,
                        child: Container(
                          width: textSpace,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.centerLeft,
                          child: _activeText(activeTextColor),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedOpacity(
                          opacity: !widget.value ? 1.0 : 0.0,
                          duration: widget.duration,
                          child: Container(
                            width: textSpace,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.centerRight,
                            child: _inactiveText(inactiveTextColor),
                          ),
                        ),
                      ),
                      Align(
                        alignment: _toggleAnimation.value,
                        child: Container(
                          width: widget.toggleSize,
                          height: widget.toggleSize,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: resolvedToggleColor,
                            border: toggleBorder,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Stack(
                              children: [
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: widget.value ? 1.0 : 0.0,
                                    duration: widget.duration,
                                    child: widget.activeIcon,
                                  ),
                                ),
                                Center(
                                  child: AnimatedOpacity(
                                    opacity: !widget.value ? 1.0 : 0.0,
                                    duration: widget.duration,
                                    child: widget.inactiveIcon,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _activeText(Color color) {
    if (!widget.showOnOff) return const SizedBox.shrink();
    return Text(
      widget.activeText ?? 'On',
      style: TextStyle(
        color: color,
        fontWeight: widget.activeTextFontWeight ?? FontWeight.w900,
        fontSize: widget.valueFontSize,
      ),
    );
  }

  Widget _inactiveText(Color color) {
    if (!widget.showOnOff) return const SizedBox.shrink();
    return Text(
      widget.inactiveText ?? 'Off',
      textAlign: TextAlign.right,
      style: TextStyle(
        color: color,
        fontWeight: widget.inactiveTextFontWeight ?? FontWeight.w900,
        fontSize: widget.valueFontSize,
      ),
    );
  }
}
