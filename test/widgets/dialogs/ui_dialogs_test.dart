import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UICustomMessageDialog', () {
    testWidgets('responds to positive button click', (tester) async {
      var positiveClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UICustomMessageDialog.simple(
              title: 'Simple Dialog',
              msg: 'Are you sure?',
              positiveBtn: 'Yes',
              onPositiveClick: () => positiveClicked = true,
              negativeBtn: 'No',
            ),
          ),
        ),
      );

      await tester.tap(find.text('Yes'));
      expect(positiveClicked, isTrue);
    });

    testWidgets('responds to negative button click', (tester) async {
      var negativeClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UICustomMessageDialog.simple(
              title: 'Simple Dialog',
              msg: 'Are you sure?',
              positiveBtn: 'Yes',
              negativeBtn: 'No',
              onNegativeClick: () => negativeClicked = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('No'));
      expect(negativeClicked, isTrue);
    });

    testWidgets('renders dialog title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICustomMessageDialog.simple(
              title: 'Simple Dialog',
              msg: 'Are you sure?',
              positiveBtn: 'Yes',
              negativeBtn: 'No',
            ),
          ),
        ),
      );

      expect(find.text('Simple Dialog'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
    });

    testWidgets('renders custom widget as message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UICustomMessageDialog(
              title: 'Custom Content',
              msgWidget: Text('Custom Message Widget'),
              positiveBtn: 'OK',
            ),
          ),
        ),
      );

      expect(find.text('Custom Message Widget'), findsOneWidget);
    });
  });

  group('UIAlertDialog', () {
    testWidgets('confirm button calls onConfirm and pops', (tester) async {
      var confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIAlertDialog(
              title: 'Alert',
              message: 'Something happened.',
              onConfirm: () => confirmed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });

    testWidgets('show helper displays dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => UIAlertDialog.show(
                  context,
                  title: 'Alert',
                  message: 'Message body',
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Alert'), findsOneWidget);
      expect(find.text('Message body'), findsOneWidget);
    });
  });

  group('UIConfirmDialog', () {
    testWidgets('cancel invokes onCancel', (tester) async {
      var cancelled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIConfirmDialog(
              title: 'Confirm',
              message: 'Are you sure?',
              onConfirm: () {},
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      expect(cancelled, isTrue);
    });

    testWidgets('confirm invokes onConfirm', (tester) async {
      var confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIConfirmDialog(
              title: 'Confirm',
              message: 'Are you sure?',
              onConfirm: () => confirmed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(UIStyledButton, 'Confirm'));
      expect(confirmed, isTrue);
    });
  });

  group('UIShellDialogStyle', () {
    testWidgets('fromTheme uses color scheme values', (tester) async {
      UIShellDialogStyle? style;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              surface: Colors.white,
              onSurface: Colors.black,
              surfaceContainerHighest: Colors.grey,
              onSurfaceVariant: Colors.blueGrey,
            ),
          ),
          home: Builder(
            builder: (context) {
              style = UIShellDialogStyle.fromTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(style!.backgroundColor, Colors.white);
      expect(style!.closeButtonColor, Colors.grey);
      expect(style!.closeIconColor, Colors.blueGrey);
    });
  });

  group('showUICupertinoActionSheet', () {
    testWidgets('returns selected action value', (tester) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showUICupertinoActionSheet<String>(
                    context: context,
                    title: 'Choose',
                    actions: const [
                      UICupertinoActionSheetAction(
                        label: 'Option A',
                        value: 'a',
                      ),
                      UICupertinoActionSheetAction(
                        label: 'Option B',
                        value: 'b',
                      ),
                    ],
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option B'));
      await tester.pumpAndSettle();

      expect(result, 'b');
    });
  });

  group('showUIAdaptiveAlertDialog', () {
    testWidgets('returns selected action on Material', (tester) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showUIAdaptiveAlertDialog<String>(
                    context: context,
                    title: 'Title',
                    message: 'Message',
                    forceMaterial: true,
                    actions: const [
                      UIAdaptiveDialogAction(label: 'No', value: 'no'),
                      UIAdaptiveDialogAction(label: 'Yes', value: 'yes'),
                    ],
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(result, 'yes');
    });

    testWidgets('uses CupertinoAlertDialog when forced', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showUIAdaptiveAlertDialog<String>(
                  context: context,
                  title: 'Title',
                  forceCupertino: true,
                  actions: const [
                    UIAdaptiveDialogAction(label: 'OK', value: 'ok'),
                  ],
                ),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });
  });

  group('showUIAdaptiveActionSheet', () {
    testWidgets('returns selected action on Material bottom sheet', (
      tester,
    ) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showUIAdaptiveActionSheet<String>(
                    context: context,
                    title: 'Choose',
                    forceMaterial: true,
                    actions: const [
                      UICupertinoActionSheetAction(
                        label: 'Option A',
                        value: 'a',
                      ),
                      UICupertinoActionSheetAction(
                        label: 'Option B',
                        value: 'b',
                      ),
                    ],
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option B'));
      await tester.pumpAndSettle();

      expect(result, 'b');
    });
  });

  group('UISheet', () {
    testWidgets('showUISheet opens bottom sheet content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UIPrimaryTextButton(
                text: 'Open',
                onPressed: () => showUISheet<void>(
                  context: context,
                  title: 'Sheet title',
                  child: const Text('Sheet body'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet title'), findsOneWidget);
      expect(find.text('Sheet body'), findsOneWidget);
      expect(find.byType(UISheetDragHandle), findsOneWidget);
    });

    testWidgets('showUISheet glass mode uses UIGlassSurface', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: UIPrimaryTextButton(
                text: 'Open glass',
                onPressed: () => showUISheet<void>(
                  context: context,
                  glass: true,
                  title: 'Glass sheet',
                  child: const Text('Glass body'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open glass'));
      await tester.pumpAndSettle();
      expect(find.text('Glass sheet'), findsOneWidget);
      expect(find.text('Glass body'), findsOneWidget);
      expect(find.byType(UIGlassSurface), findsOneWidget);
    });
  });

  group('UIShellDialog', () {
    const style = UIShellDialogStyle(
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      contentStyle: TextStyle(color: Colors.grey),
      closeButtonColor: Colors.black12,
      closeIconColor: Colors.black,
    );

    testWidgets('renders title, content and actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIShellDialog(
              style: style,
              title: 'Shell Title',
              content: 'Shell Content',
              imageHeader: const Icon(Icons.info),
              actions: [
                UIShellDialogAction(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Action'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Shell Title'), findsOneWidget);
      expect(find.text('Shell Content'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });
  });

  group('UIListDialog', () {
    testWidgets('selects item immediately without confirm button', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 400,
              child: UIListDialog<String>(
                items: const ['Option A', 'Option B'],
                heading: 'Choose',
                onItemSelected: (item) => selected = item,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Choose'), findsOneWidget);
      await tester.tap(find.text('Option B'));
      expect(selected, 'Option B');
    });
  });

  group('UIImagePickerDialog', () {
    testWidgets('returns gallery selection', (tester) async {
      int? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showDialog<int>(
                  context: context,
                  builder: (_) => const UIImagePickerDialog(
                    title: 'Pick Image',
                    galleryLabel: 'Gallery',
                    cameraLabel: 'Camera',
                    cancelLabel: 'Cancel',
                  ),
                );
              },
              child: const Text('Pick'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Pick'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();
      expect(result, 0);
    });
  });

  group('UIAlertPanel', () {
    const style = UIAlertPanelStyle(
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      descriptionStyle: TextStyle(color: Colors.grey),
      closeButtonColor: Colors.black12,
      closeIconColor: Colors.black,
      scrimColor: Colors.black54,
    );

    testWidgets('renders title and description', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIAlertPanel(
              title: 'Alert Title',
              description: 'Alert Description',
              style: style,
            ),
          ),
        ),
      );

      expect(find.text('Alert Title'), findsOneWidget);
      expect(find.text('Alert Description'), findsOneWidget);
    });
  });

  group('UISheetDragHandle', () {
    testWidgets('renders drag handle bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UISheetDragHandle())),
      );

      expect(find.byType(UISheetDragHandle), findsOneWidget);
    });
  });
}
