import 'package:flutter/material.dart';

/// When [UIForm] should auto-validate its fields.
enum UIAutovalidateMode { disabled, always, onUserInteraction }

/// A form wrapper that tracks named fields and exposes aggregate values.
class UIForm extends StatefulWidget {
  const UIForm({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode = UIAutovalidateMode.onUserInteraction,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onChanged;
  final UIAutovalidateMode autovalidateMode;
  final bool enabled;

  @override
  State<UIForm> createState() => UIFormState();

  static UIFormState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<UIFormState>();
  }

  static UIFormState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'No UIForm found in context');
    return state!;
  }
}

class UIFormState extends State<UIForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  final Map<String, UIFormFieldState<dynamic>> _fields = {};
  bool _hasInteracted = false;

  AutovalidateMode get _materialAutovalidateMode {
    return switch (widget.autovalidateMode) {
      UIAutovalidateMode.disabled => AutovalidateMode.disabled,
      UIAutovalidateMode.always => AutovalidateMode.always,
      UIAutovalidateMode.onUserInteraction =>
        _hasInteracted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
    };
  }

  void registerField(String name, UIFormFieldState<dynamic> field) {
    _fields[name] = field;
    widget.onChanged?.call();
  }

  void unregisterField(String name) {
    _fields.remove(name);
    _values.remove(name);
    widget.onChanged?.call();
  }

  void setFieldValue(String name, dynamic value) {
    _values[name] = value;
    _hasInteracted = true;
    widget.onChanged?.call();
  }

  Map<String, dynamic> get values => Map.unmodifiable(_values);

  bool validate() => _formKey.currentState?.validate() ?? false;

  void save() => _formKey.currentState?.save();

  void reset() {
    _formKey.currentState?.reset();
    _values.clear();
    _hasInteracted = false;
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return _UIFormScope(
      enabled: widget.enabled,
      registerField: registerField,
      unregisterField: unregisterField,
      setFieldValue: setFieldValue,
      child: Form(
        key: _formKey,
        autovalidateMode: _materialAutovalidateMode,
        onChanged: widget.onChanged,
        child: widget.child,
      ),
    );
  }
}

class _UIFormScope extends InheritedWidget {
  const _UIFormScope({
    required this.enabled,
    required this.registerField,
    required this.unregisterField,
    required this.setFieldValue,
    required super.child,
  });

  final bool enabled;
  final void Function(String name, UIFormFieldState<dynamic> field)
  registerField;
  final void Function(String name) unregisterField;
  final void Function(String name, dynamic value) setFieldValue;

  static _UIFormScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_UIFormScope>();
  }

  @override
  bool updateShouldNotify(_UIFormScope oldWidget) =>
      enabled != oldWidget.enabled;
}

/// Base form field integrated with [UIForm] value tracking.
class UIFormField<T> extends FormField<T> {
  UIFormField({
    super.key,
    required this.name,
    super.initialValue,
    super.validator,
    super.enabled = true,
    super.autovalidateMode,
    super.onSaved,
    required super.builder,
  });

  final String name;

  @override
  FormFieldState<T> createState() => UIFormFieldState<T>();
}

class UIFormFieldState<T> extends FormFieldState<T> {
  UIFormField<T> get _field => widget as UIFormField<T>;
  _UIFormScope? _scope;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _register());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextScope = _UIFormScope.maybeOf(context);
    if (_scope != nextScope) {
      _scope?.unregisterField(_field.name);
      _scope = nextScope;
      _register();
    }
  }

  @override
  void dispose() {
    _scope?.unregisterField(_field.name);
    super.dispose();
  }

  void _register() {
    _scope?.registerField(_field.name, this as UIFormFieldState<dynamic>);
    if (value != null) {
      _scope?.setFieldValue(_field.name, value);
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    _scope?.setFieldValue(_field.name, value);
  }
}
