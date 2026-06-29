import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Date pager row for detail screens.
class UIDetailDateNavigator extends StatelessWidget {
  const UIDetailDateNavigator({
    super.key,
    this.dateTitle,
    this.dateTitleChild,
    required this.isNextDisabled,
    required this.onPrevious,
    required this.onNext,
  }) : assert(
         dateTitleChild != null || dateTitle != null,
         'Either dateTitle or dateTitleChild must be provided.',
       );

  final String? dateTitle;
  final Widget? dateTitleChild;
  final bool isNextDisabled;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  UIDetailDateNavigator copyWith({
    Key? key,
    String? dateTitle,
    Widget? dateTitleChild,
    bool? isNextDisabled,
    VoidCallback? onPrevious,
    VoidCallback? onNext,
  }) {
    return UIDetailDateNavigator(
      key: key ?? this.key,
      dateTitle: dateTitle ?? this.dateTitle,
      dateTitleChild: dateTitleChild ?? this.dateTitleChild,
      isNextDisabled: isNextDisabled ?? this.isNextDisabled,
      onPrevious: onPrevious ?? this.onPrevious,
      onNext: onNext ?? this.onNext,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final titleWidget =
        dateTitleChild ??
        UIText(dateTitle!, style: Theme.of(context).textTheme.titleMedium);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 20,
          onPressed: onPrevious,
          icon: Icon(Icons.arrow_back_ios_outlined, color: onSurface),
        ),
        titleWidget,
        IconButton(
          iconSize: 20,
          onPressed: isNextDisabled ? null : onNext,
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: isNextDisabled
                ? onSurface.withValues(alpha: 0.35)
                : onSurface,
          ),
        ),
      ],
    );
  }
}
