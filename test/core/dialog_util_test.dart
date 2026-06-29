import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIDialogUtil', () {
    testWidgets('showMsgDialog displays dialog with content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DialogUtil.showMsgDialog(
                  context: context,
                  title: 'Alert',
                  msg: 'This is a message',
                  positiveBtn: 'OK',
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Alert'), findsOneWidget);
      expect(find.text('This is a message'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('showLoader displays progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DialogUtil.showLoader(context),
                child: const Text('Show Loader'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Loader'));
      await tester.pump(); // Show dialog

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('showSnackBar displays message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DialogUtil.showSnackBar(context, 'Saved'),
                child: const Text('Snack'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Snack'));
      await tester.pump();
      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('showCustomTopSnackBar displays warning type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DialogUtil.showCustomTopSnackBar(
                  context,
                  'Warning',
                  msgType: 1,
                ),
                child: const Text('Top Snack'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Top Snack'));
      await tester.pump();
      expect(find.text('Warning'), findsOneWidget);
    });

    testWidgets('showWidgetAsBottomSheet displays content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DialogUtil.showWidgetAsBottomSheet(
                  context,
                  widget: const Text('Sheet Content'),
                ),
                child: const Text('Show Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet Content'), findsOneWidget);
    });

    testWidgets('showListDialog selects item', (tester) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DialogUtil.showListDialog<String>(
                  context: context,
                  items: const ['A', 'B'],
                  onItemSelected: (item) => selected = item,
                  heading: 'Pick one',
                ),
                child: const Text('Show List'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show List'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(selected, 'B');
    });

    testWidgets('showCustomMsgDialog displays custom content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DialogUtil.showCustomMsgDialog(
                  context: context,
                  title: 'Custom',
                  msg: 'Details',
                  positiveBtn: 'OK',
                ),
                child: const Text('Custom Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Custom Dialog'));
      await tester.pumpAndSettle();
      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
    });

    testWidgets('hideLoader closes loader', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  DialogUtil.showLoader(context);
                  DialogUtil.hideLoader(context);
                },
                child: const Text('Toggle Loader'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Toggle Loader'));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
