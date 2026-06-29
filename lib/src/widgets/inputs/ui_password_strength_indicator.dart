import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/core/utils/string_util.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Individual password requirement checked by [UIPasswordStrengthIndicator].
enum UIPasswordRule {
  /// Minimum (and optional maximum) length.
  length,

  /// At least one uppercase letter.
  uppercase,

  /// At least one lowercase letter.
  lowercase,

  /// At least one digit.
  number,

  /// At least one special character.
  symbol,
}

/// Visual strength level derived from passed [UIPasswordRule] count.
enum UIPasswordStrength { none, weak, fair, good, strong, veryStrong }

/// Segmented strength bar and checklist for password fields.
///
/// Wire to the same [TextEditingController] as your password [TextFormField].
class UIPasswordStrengthIndicator extends StatefulWidget {
  const UIPasswordStrengthIndicator({
    super.key,
    required this.controller,
    this.rules = const [
      UIPasswordRule.length,
      UIPasswordRule.uppercase,
      UIPasswordRule.lowercase,
      UIPasswordRule.number,
      UIPasswordRule.symbol,
    ],
    this.minLength = 8,
    this.maxLength,
    this.hideRules = false,
    this.barHeight = 5,
    this.ruleTextStyle,
    this.validColor,
    this.invalidColor,
    this.inactiveBarColor,
    this.validIcon,
    this.invalidIcon,
    this.validIconWidget,
    this.invalidIconWidget,
    this.ruleLabels,
  });

  final TextEditingController controller;
  final List<UIPasswordRule> rules;
  final int minLength;
  final int? maxLength;
  final bool hideRules;
  final double barHeight;
  final TextStyle? ruleTextStyle;
  final Color? validColor;
  final Color? invalidColor;
  final Color? inactiveBarColor;
  final IconData? validIcon;
  final IconData? invalidIcon;
  final Widget? validIconWidget;
  final Widget? invalidIconWidget;

  /// Optional overrides for rule label text keyed by [UIPasswordRule].
  final Map<UIPasswordRule, String>? ruleLabels;

  @override
  State<UIPasswordStrengthIndicator> createState() =>
      _UIPasswordStrengthIndicatorState();
}

class _UIPasswordStrengthIndicatorState
    extends State<UIPasswordStrengthIndicator> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(UIPasswordStrengthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  String get _password => widget.controller.text;

  int get _passedCount =>
      widget.rules.where((rule) => _isRuleValid(rule)).length;

  bool _isRuleValid(UIPasswordRule rule) {
    switch (rule) {
      case UIPasswordRule.length:
        if (widget.maxLength != null) {
          return _password.length >= widget.minLength &&
              _password.length <= widget.maxLength!;
        }
        return _password.length >= widget.minLength;
      case UIPasswordRule.uppercase:
        return StringUtils.hasUppercase(_password);
      case UIPasswordRule.lowercase:
        return StringUtils.hasLowercase(_password);
      case UIPasswordRule.number:
        return StringUtils.hasDigit(_password);
      case UIPasswordRule.symbol:
        return StringUtils.hasSpecialCharacter(_password);
    }
  }

  String _ruleLabel(UIPasswordRule rule) {
    final override = widget.ruleLabels?[rule];
    if (override != null) return override;

    return switch (rule) {
      UIPasswordRule.length =>
        widget.maxLength != null
            ? 'Between ${widget.minLength}–${widget.maxLength} characters'
            : 'At least ${widget.minLength} characters',
      UIPasswordRule.uppercase => 'At least one uppercase letter',
      UIPasswordRule.lowercase => 'At least one lowercase letter',
      UIPasswordRule.number => 'At least one number',
      UIPasswordRule.symbol => 'At least one special character',
    };
  }

  Color _activeBarColor(ThemeData theme) {
    final total = widget.rules.length;
    if (_passedCount == 0) {
      return widget.inactiveBarColor ?? theme.dividerColor;
    }
    if (total == 1) return widget.validColor ?? Colors.green;
    if (total == 2) {
      return _passedCount == 1
          ? (widget.invalidColor ?? Colors.red)
          : (widget.validColor ?? Colors.green);
    }

    return switch (_passedCount) {
      1 => widget.invalidColor ?? Colors.red,
      2 => Colors.amber,
      3 => Colors.orange,
      4 => Colors.blue,
      _ => widget.validColor ?? Colors.green,
    };
  }

  Color _boxColor(int index, ThemeData theme) {
    if (index < _passedCount) return _activeBarColor(theme);
    return widget.inactiveBarColor ?? theme.dividerColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final validColor = widget.validColor ?? Colors.green;
    final invalidColor = widget.invalidColor ?? Colors.red;
    final baseRuleStyle =
        widget.ruleTextStyle ?? theme.textTheme.bodySmall ?? const TextStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: List.generate(widget.rules.length, (index) {
            return Expanded(
              child: Container(
                height: widget.barHeight,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _boxColor(index, theme),
                  borderRadius: BorderRadius.circular(widget.barHeight / 2),
                ),
              ),
            );
          }),
        ),
        if (!widget.hideRules) ...[
          const SizedBox(height: 12),
          ...widget.rules.map((rule) {
            final valid = _isRuleValid(rule);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  valid
                      ? (widget.validIconWidget ??
                            Icon(
                              widget.validIcon ?? Icons.check,
                              color: validColor,
                              size: 16,
                            ))
                      : (widget.invalidIconWidget ??
                            Icon(
                              widget.invalidIcon ?? Icons.close,
                              color: invalidColor,
                              size: 16,
                            )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: UIText(
                      _ruleLabel(rule),
                      style: baseRuleStyle.copyWith(
                        color: valid ? validColor : invalidColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
