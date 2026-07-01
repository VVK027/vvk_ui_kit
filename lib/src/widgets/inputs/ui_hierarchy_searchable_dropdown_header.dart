part of 'ui_hierarchy_searchable_dropdown.dart';

class _DefaultHeader extends StatelessWidget {
  const _DefaultHeader({
    required this.label,
    required this.hint,
    required this.isMultiline,
    required this.isOpen,
    required this.onTap,
    this.errorText,
    this.decoration,
    this.showChips = false,
    this.selectedLabels = const [],
    this.onRemove,
    this.onReorder,
    this.chipDecoration,
    this.chipTextStyle,
    this.chipPadding,
    this.chipHeight,
    this.chipScrollDirection = Axis.horizontal,
    this.prefix,
    this.suffix,
    this.isGlassMode = false,
    this.blur = 10,
    this.connectivity = 0.1,
  });

  final String label;
  final String hint;
  final bool isMultiline;
  final bool isOpen;
  final VoidCallback onTap;
  final String? errorText;
  final BoxDecoration? decoration;
  final bool showChips;
  final List<String> selectedLabels;
  final ValueChanged<String>? onRemove;
  final ReorderCallback? onReorder;
  final BoxDecoration? chipDecoration;
  final TextStyle? chipTextStyle;
  final EdgeInsets? chipPadding;
  final double? chipHeight;
  final Axis chipScrollDirection;
  final Widget? prefix;
  final Widget? suffix;
  final bool isGlassMode;
  final double blur;
  final double connectivity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasLabel = label.isNotEmpty;
    final hasError = errorText != null;
    final useChips = showChips && selectedLabels.isNotEmpty;
    final isHorizontal = chipScrollDirection == Axis.horizontal;

    final defaultDecoration = BoxDecoration(
      color: isGlassMode ? Colors.transparent : scheme.surface,
      border: Border.all(
        color: hasError
            ? scheme.error
            : (isOpen ? scheme.primary : scheme.outlineVariant),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: isGlassMode
          ? []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GlassWrap(
          isGlassMode: isGlassMode,
          blur: blur,
          connectivity: connectivity,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: decoration ?? defaultDecoration,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child:
                      prefix ??
                      Icon(
                        Icons.checklist_rounded,
                        color: hasError
                            ? Colors.red.shade400
                            : (hasLabel
                                  ? Colors.blue.shade400
                                  : Colors.black38),
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: useChips
                      ? isMultiline
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: selectedLabels.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final text = entry.value;
                                    final chipWidget = Container(
                                      padding:
                                          chipPadding ??
                                          const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                      decoration:
                                          chipDecoration ??
                                          BoxDecoration(
                                            color: Colors.blue.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue.withValues(
                                                alpha: 0.2,
                                              ),
                                            ),
                                          ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            text,
                                            style:
                                                chipTextStyle ??
                                                const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          InkWell(
                                            onTap: () => onRemove?.call(text),
                                            child: const Icon(
                                              Icons.close_rounded,
                                              size: 14,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    return DragTarget<String>(
                                      key: ValueKey(text),
                                      onWillAcceptWithDetails: (details) {
                                        if (details.data != text) {
                                          final fromIndex = selectedLabels
                                              .indexOf(details.data);
                                          if (fromIndex != -1) {
                                            // ReorderableListView-style logic requires index + 1 for forward moves
                                            onReorder?.call(
                                              fromIndex,
                                              fromIndex < index
                                                  ? index + 1
                                                  : index,
                                            );
                                          }
                                        }
                                        return true;
                                      },
                                      onAcceptWithDetails: (details) {
                                        // Final order is already handled by live reordering
                                      },
                                      builder:
                                          (
                                            context,
                                            candidateData,
                                            rejectedData,
                                          ) {
                                            return LongPressDraggable<String>(
                                              data: text,
                                              feedback: Material(
                                                color: Colors.transparent,
                                                child: Transform.scale(
                                                  scale: 1.05,
                                                  child: chipWidget,
                                                ),
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.3,
                                                child: chipWidget,
                                              ),
                                              child: chipWidget,
                                            );
                                          },
                                    );
                                  }).toList(),
                                ),
                              )
                            : SizedBox(
                                height: isHorizontal ? (chipHeight ?? 48) : 150,
                                child: ReorderableListView.builder(
                                  scrollDirection: chipScrollDirection,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: selectedLabels.length,
                                  // ignore: deprecated_member_use
                                  onReorder: onReorder!,
                                  buildDefaultDragHandles: false,
                                  proxyDecorator: (child, index, animation) {
                                    return AnimatedBuilder(
                                      animation: animation,
                                      builder: (context, child) {
                                        final animValue = Curves.easeInOut
                                            .transform(animation.value);
                                        final scale = 1.0 + (0.05 * animValue);
                                        return Transform.scale(
                                          scale: scale,
                                          child: Material(
                                            color: Colors.white,
                                            type: MaterialType.transparency,
                                            animateColor: true,
                                            surfaceTintColor:
                                                Colors.transparent,
                                            elevation: 8 * animValue,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: child,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    final text = selectedLabels[index];
                                    return ReorderableDelayedDragStartListener(
                                      key: ValueKey(text),
                                      index: index,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Center(
                                          child: Container(
                                            padding:
                                                chipPadding ??
                                                const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 6,
                                                ),
                                            decoration:
                                                chipDecoration ??
                                                BoxDecoration(
                                                  color: Colors.blue.withValues(
                                                    alpha: 0.1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Colors.blue
                                                        .withValues(alpha: 0.2),
                                                  ),
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  text,
                                                  style:
                                                      chipTextStyle ??
                                                      const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                const SizedBox(width: 4),
                                                InkWell(
                                                  onTap: () =>
                                                      onRemove?.call(text),
                                                  child: const Icon(
                                                    Icons.close_rounded,
                                                    size: 14,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                      : GestureDetector(
                          onTap: onTap,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: isMultiline ? null : 48,
                            padding: isMultiline
                                ? const EdgeInsets.symmetric(vertical: 4)
                                : null,
                            child: Text(
                              hasLabel ? label : hint,
                              maxLines: isMultiline ? null : 1,
                              overflow: isMultiline
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: TextStyle(
                                color: hasLabel
                                    ? Colors.black87
                                    : Colors.black38,
                                fontSize: 16,
                                fontWeight: hasLabel
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                ),
                GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      suffix ??
                          AnimatedRotation(
                            turns: isOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.black45,
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
