import 'package:flutter/material.dart';
import '../../core/theme/ui_component_themes.dart';
import 'ui_form.dart';
import '../selection/ui_rounded_checkbox.dart';
import '../selection/ui_pill_switch.dart';
import '../text/ui_text.dart';

/// Text field integrated with [UIForm].
class UIFormTextField extends StatelessWidget {
  const UIFormTextField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.initialValue,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.onChanged,
  });

  final String name;
  final String? label;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = context.uiInputTheme;
    final scheme = theme.colorScheme;

    return UIFormField<String>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (state) {
        final fieldState = state as UIFormFieldState<String>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              UIText(label!, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
            ],
            TextFormField(
              focusNode: fieldState.focusNode,
              initialValue: state.value,
              enabled: enabled,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onChanged: (value) {
                state.didChange(value);
                onChanged?.call(value);
              },
              decoration: InputDecoration(
                hintText: hintText,
                errorText: state.errorText,
                contentPadding: inputTheme.contentPadding,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputTheme.borderRadius),
                  borderSide: BorderSide(
                    color: scheme.outlineVariant,
                    width: inputTheme.borderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputTheme.borderRadius),
                  borderSide: BorderSide(
                    color: scheme.outlineVariant,
                    width: inputTheme.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputTheme.borderRadius),
                  borderSide: BorderSide(
                    color: scheme.primary,
                    width: inputTheme.focusedBorderWidth,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Multiline field integrated with [UIForm].
class UIFormTextareaField extends StatelessWidget {
  const UIFormTextareaField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.initialValue,
    this.validator,
    this.minLines = 3,
    this.maxLines = 6,
    this.enabled = true,
    this.onChanged,
  });

  final String name;
  final String? label;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = context.uiInputTheme;
    final scheme = theme.colorScheme;

    return UIFormField<String>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (state) {
        final fieldState = state as UIFormFieldState<String>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              UIText(label!, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
            ],
            TextFormField(
              focusNode: fieldState.focusNode,
              initialValue: state.value,
              enabled: enabled,
              keyboardType: TextInputType.multiline,
              minLines: minLines,
              maxLines: maxLines,
              onChanged: (value) {
                state.didChange(value);
                onChanged?.call(value);
              },
              decoration: InputDecoration(
                hintText: hintText,
                errorText: state.errorText,
                alignLabelWithHint: true,
                contentPadding: inputTheme.contentPadding,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputTheme.borderRadius),
                  borderSide: BorderSide(
                    color: scheme.outlineVariant,
                    width: inputTheme.borderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputTheme.borderRadius),
                  borderSide: BorderSide(
                    color: scheme.outlineVariant,
                    width: inputTheme.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(inputTheme.borderRadius),
                  borderSide: BorderSide(
                    color: scheme.primary,
                    width: inputTheme.focusedBorderWidth,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Checkbox field integrated with [UIForm].
class UIFormCheckboxField extends StatelessWidget {
  const UIFormCheckboxField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue = false,
    this.validator,
    this.enabled = true,
    this.onChanged,
  });

  final String name;
  final String label;
  final bool initialValue;
  final String? Function(bool?)? validator;
  final bool enabled;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return UIFormField<bool>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIRoundedCheckbox(
              value: state.value ?? false,
              label: label,
              onChanged: enabled
                  ? (value) {
                      state.didChange(value);
                      onChanged?.call(value);
                    }
                  : null,
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Switch field integrated with [UIForm].
class UIFormSwitchField extends StatelessWidget {
  const UIFormSwitchField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue = false,
    this.enabled = true,
    this.onChanged,
  });

  final String name;
  final String label;
  final bool initialValue;
  final bool enabled;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return UIFormField<bool>(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      builder: (state) {
        return Row(
          children: [
            Expanded(child: UIText(label)),
            UIPillSwitch.fromTheme(
              value: state.value ?? false,
              onChanged: enabled
                  ? (value) {
                      state.didChange(value);
                      onChanged?.call(value);
                    }
                  : (_) {},
            ),
          ],
        );
      },
    );
  }
}
