import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';

/// Full-screen error state with title, description, and retry action.
class UIErrorInfo extends StatelessWidget {
  const UIErrorInfo({
    super.key,
    this.title,
    this.titleChild,
    this.description,
    this.descriptionChild,
    this.button,
    this.btnText,
    required this.onPressed,
  }) : assert(
         titleChild != null || title != null,
         'Either title or titleChild must be provided.',
       ),
       assert(
         descriptionChild != null || description != null,
         'Either description or descriptionChild must be provided.',
       );

  final String? title;
  final Widget? titleChild;
  final String? description;
  final Widget? descriptionChild;
  final Widget? button;
  final String? btnText;
  final VoidCallback onPressed;

  UIErrorInfo copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    String? description,
    Widget? descriptionChild,
    Widget? button,
    String? btnText,
    VoidCallback? onPressed,
  }) {
    return UIErrorInfo(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      description: description ?? this.description,
      descriptionChild: descriptionChild ?? this.descriptionChild,
      button: button ?? this.button,
      btnText: btnText ?? this.btnText,
      onPressed: onPressed ?? this.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleWidget =
        titleChild ??
        UIText(
          title!,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        );
    final descriptionWidget =
        descriptionChild ?? UIText(description!, textAlign: TextAlign.center);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleWidget,
            const SizedBox(height: 16),
            descriptionWidget,
            const SizedBox(height: 40),
            button ??
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: colorScheme.inverseSurface,
                    foregroundColor: colorScheme.onInverseSurface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: UIText(btnText ?? ''),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
