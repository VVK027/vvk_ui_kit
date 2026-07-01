import 'package:flutter/material.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

import 'common.dart';
import 'showcase_scaffold.dart';

class DialogsShowcase extends StatelessWidget {
  const DialogsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Dialogs',
      child: Column(
        children: [
          ShowcaseTile(
            name: 'showUISheet',
            child: UIPrimaryTextButton(
              text: 'Open bottom sheet',
              onPressed: () => showUISheet<void>(
                context: context,
                title: 'Filters',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const UIText('Choose filter options'),
                    const SizedBox(height: 12),
                    UIPrimaryTextButton(
                      text: 'Apply',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'showUISheet (glass)',
            child: UIPrimaryTextButton(
              text: 'Open glass sheet',
              onPressed: () => showUISheet<void>(
                context: context,
                glass: true,
                title: 'Glass sheet',
                child: const UIText(
                  'Frosted backdrop with blur — place over colorful content.',
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIAlertDialog.show',
            child: UIPrimaryTextButton(
              text: 'Alert dialog',
              onPressed: () => UIAlertDialog.show(
                context,
                title: 'Notice',
                message: 'Your session has expired. Please sign in again.',
                confirmLabel: 'OK',
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIConfirmDialog.show',
            child: UIPrimaryTextButton(
              text: 'Confirm dialog',
              onPressed: () => UIConfirmDialog.show(
                context,
                title: 'Delete item?',
                message: 'This action cannot be undone.',
                confirmLabel: 'Delete',
                cancelLabel: 'Cancel',
                onConfirm: () {},
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDialogUtil.showMsgDialog',
            child: UIPrimaryTextButton(
              text: 'Message dialog',
              onPressed: () => DialogUtil.showMsgDialog(
                context: context,
                title: 'Title',
                msg: 'This is a message dialog.',
                positiveBtn: 'OK',
                negativeBtn: 'Cancel',
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDialogUtil.showCustomMsgDialog',
            child: UIPrimaryTextButton(
              text: 'Custom message',
              onPressed: () => DialogUtil.showCustomMsgDialog(
                context: context,
                msg: 'Custom styled message',
                positiveBtn: 'Got it',
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UICustomMessageDialog.simple',
            child: UIPrimaryTextButton(
              text: 'Simple dialog widget',
              onPressed: () => DialogUtil.showWidgetAsDialog(
                context,
                UICustomMessageDialog.simple(
                  msg: 'Simple custom dialog',
                  positiveBtn: 'Close',
                  onPositiveClick: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDialogUtil.showListDialog',
            child: UIPrimaryTextButton(
              text: 'List dialog',
              onPressed: () => DialogUtil.showListDialog<String>(
                context: context,
                items: const ['Option A', 'Option B', 'Option C'],
                onItemSelected: (_) => Navigator.pop(context),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIDialogUtil.showLoader / hideLoader',
            child: UIPrimaryTextButton(
              text: 'Show loader (2s)',
              onPressed: () async {
                DialogUtil.showLoader(context);
                await Future<void>.delayed(const Duration(seconds: 2));
                if (context.mounted) DialogUtil.hideLoader(context);
              },
            ),
          ),
          ShowcaseTile(
            name: 'UIDialogUtil.showSnackBar',
            child: UIPrimaryTextButton(
              text: 'Material snackbar',
              onPressed: () =>
                  DialogUtil.showSnackBar(context, 'Saved successfully'),
            ),
          ),
          ShowcaseTile(
            name: 'UIDialogUtil.showCustomTopSnackBar',
            child: UIPrimaryTextButton(
              text: 'Top snackbar',
              onPressed: () => DialogUtil.showCustomTopSnackBar(
                context,
                'Top notification',
                msgType: 0,
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIShellDialog.copyWith',
            child: UIPrimaryTextButton(
              text: 'Shell dialog (copyWith)',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (ctx) => UIShellDialog(
                  style: shellDialogStyle(ctx),
                  title: 'Shell dialog',
                  content: 'Custom shell with actions.',
                  actions: [
                    UIShellDialogAction(
                      child: UIPrimaryTextButton(
                        text: 'Confirm',
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                  ],
                ).copyWith(dialog: const UIDialogProps(elevation: 8)),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIShellDialog',
            child: UIPrimaryTextButton(
              text: 'Shell dialog',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (ctx) => UIShellDialog(
                  style: shellDialogStyle(ctx),
                  title: 'Shell dialog',
                  content: 'Custom shell with actions.',
                  actions: [
                    UIShellDialogAction(
                      child: UIPrimaryTextButton(
                        text: 'Confirm',
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIAlertPanel',
            child: UIPrimaryTextButton(
              text: 'Alert panel',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (ctx) => UIAlertPanel(
                  title: 'Alert',
                  description: 'Something needs your attention.',
                  style: alertPanelStyle(ctx),
                  icon: const Icon(Icons.warning_amber, size: 48),
                  onClose: () => Navigator.pop(ctx),
                ),
              ),
            ),
          ),
          ShowcaseTile(
            name: 'UIImagePickerDialog',
            child: UIPrimaryTextButton(
              text: 'Image picker dialog',
              onPressed: () async {
                final result = await showDialog<int>(
                  context: context,
                  builder: (ctx) => const UIImagePickerDialog(
                    title: 'Choose source',
                    galleryLabel: 'Gallery',
                    cameraLabel: 'Camera',
                    cancelLabel: 'Cancel',
                  ),
                );
                if (context.mounted && result != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $result')));
                }
              },
            ),
          ),
          ShowcaseTile(
            name: 'showUIAdaptiveAlertDialog',
            child: UIPrimaryTextButton(
              text: 'Adaptive alert dialog',
              onPressed: () async {
                final result = await showUIAdaptiveAlertDialog<String>(
                  context: context,
                  title: 'Save changes?',
                  message: 'You have unsaved changes.',
                  actions: const [
                    UIAdaptiveDialogAction(
                      label: 'Discard',
                      value: 'discard',
                      isDestructive: true,
                    ),
                    UIAdaptiveDialogAction(
                      label: 'Save',
                      value: 'save',
                      isDefault: true,
                    ),
                  ],
                );
                if (context.mounted && result != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $result')));
                }
              },
            ),
          ),
          ShowcaseTile(
            name: 'showUIAdaptiveActionSheet',
            child: UIPrimaryTextButton(
              text: 'Adaptive action sheet',
              onPressed: () async {
                final result = await showUIAdaptiveActionSheet<String>(
                  context: context,
                  title: 'Choose an action',
                  message: 'Pick what to do with this item.',
                  actions: const [
                    UICupertinoActionSheetAction(
                      label: 'Share',
                      value: 'share',
                    ),
                    UICupertinoActionSheetAction(
                      label: 'Delete',
                      value: 'delete',
                      isDestructive: true,
                    ),
                  ],
                );
                if (context.mounted && result != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $result')));
                }
              },
            ),
          ),
          ShowcaseTile(
            name: 'showUICupertinoActionSheet',
            child: UIPrimaryTextButton(
              text: 'Cupertino action sheet',
              onPressed: () async {
                final result = await showUICupertinoActionSheet<String>(
                  context: context,
                  title: 'Choose an action',
                  actions: const [
                    UICupertinoActionSheetAction(
                      label: 'Share',
                      value: 'share',
                    ),
                    UICupertinoActionSheetAction(
                      label: 'Delete',
                      value: 'delete',
                      isDestructive: true,
                    ),
                  ],
                );
                if (context.mounted && result != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Selected: $result')));
                }
              },
            ),
          ),
          ShowcaseTile(
            name: 'UISheetDragHandle',
            child: const UISheetDragHandle(),
          ),
        ],
      ),
    );
  }
}
