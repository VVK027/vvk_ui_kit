import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/src/widgets/buttons/ui_text_button.dart';
import 'package:vvk_ui_kit/src/widgets/text/ui_text.dart';
import 'package:vvk_ui_kit/src/widgets/ui_widget_props.dart';

/// Dialog for choosing an image from the gallery or camera.
class UIImagePickerDialog extends StatelessWidget {
  final String title;
  final Widget? titleChild;
  final String galleryLabel;
  final Widget? galleryLabelChild;
  final String cameraLabel;
  final Widget? cameraLabelChild;
  final String cancelLabel;
  final Widget? cancelLabelChild;
  final UIDialogProps dialog;

  const UIImagePickerDialog({
    super.key,
    required this.title,
    this.titleChild,
    required this.galleryLabel,
    this.galleryLabelChild,
    required this.cameraLabel,
    this.cameraLabelChild,
    required this.cancelLabel,
    this.cancelLabelChild,
    this.dialog = const UIDialogProps(),
  });

  UIImagePickerDialog copyWith({
    Key? key,
    String? title,
    Widget? titleChild,
    String? galleryLabel,
    Widget? galleryLabelChild,
    String? cameraLabel,
    Widget? cameraLabelChild,
    String? cancelLabel,
    Widget? cancelLabelChild,
    UIDialogProps? dialog,
  }) {
    return UIImagePickerDialog(
      key: key ?? this.key,
      title: title ?? this.title,
      titleChild: titleChild ?? this.titleChild,
      galleryLabel: galleryLabel ?? this.galleryLabel,
      galleryLabelChild: galleryLabelChild ?? this.galleryLabelChild,
      cameraLabel: cameraLabel ?? this.cameraLabel,
      cameraLabelChild: cameraLabelChild ?? this.cameraLabelChild,
      cancelLabel: cancelLabel ?? this.cancelLabel,
      cancelLabelChild: cancelLabelChild ?? this.cancelLabelChild,
      dialog: dialog ?? this.dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return dialog.build(
      defaultShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleChild ??
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: UIText(title, size: 16, textAlign: TextAlign.center),
                ),
            galleryLabelChild ??
                UITextButton(
                  text: galleryLabel,
                  size: 14,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  height: 56,
                  onPressed: () => Navigator.of(context).pop(0),
                ),
            cameraLabelChild ??
                UITextButton(
                  text: cameraLabel,
                  size: 14,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  height: 56,
                  onPressed: () => Navigator.of(context).pop(1),
                ),
            cancelLabelChild ??
                UITextButton(
                  text: cancelLabel,
                  size: 14,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  height: 56,
                  onPressed: () => Navigator.of(context).pop(),
                ),
          ],
        ),
      ),
    );
  }
}
