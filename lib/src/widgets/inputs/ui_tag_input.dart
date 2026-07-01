import 'package:flutter/material.dart';
import '../text/ui_text.dart';

/// Chip-style tag input that lets users add and remove string tags.
class UITagInput extends StatefulWidget {
  const UITagInput({
    super.key,
    this.initialTags = const [],
    required this.onTagsChanged,
    this.hint = 'Add tag…',
    this.maxTags,
    this.enabled = true,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  final List<String> initialTags;
  final ValueChanged<List<String>> onTagsChanged;
  final String hint;
  final int? maxTags;
  final bool enabled;
  final double spacing;
  final double runSpacing;

  @override
  State<UITagInput> createState() => _UITagInputState();
}

class _UITagInputState extends State<UITagInput> {
  late final TextEditingController _controller;
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _tags = List<String>.from(widget.initialTags);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canAddMore =>
      widget.maxTags == null || _tags.length < widget.maxTags!;

  void _addTag(String raw) {
    final tag = raw.trim();
    if (tag.isEmpty || _tags.contains(tag) || !_canAddMore) return;
    setState(() => _tags.add(tag));
    _controller.clear();
    widget.onTagsChanged(List<String>.from(_tags));
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
    widget.onTagsChanged(List<String>.from(_tags));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final tag in _tags)
          InputChip(
            key: ValueKey('ui_tag_input_chip_$tag'),
            label: UIText(tag),
            onDeleted: widget.enabled ? () => _removeTag(tag) : null,
            deleteIcon: const Icon(Icons.close, size: 16),
          ),
        if (_canAddMore && widget.enabled)
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120, maxWidth: 220),
            child: TextField(
              key: const Key('ui_tag_input_field'),
              controller: _controller,
              enabled: widget.enabled,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: scheme.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              onSubmitted: _addTag,
              textInputAction: TextInputAction.done,
            ),
          ),
      ],
    );
  }
}
