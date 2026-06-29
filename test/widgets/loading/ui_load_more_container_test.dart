import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UILoadMoreContainer', () {
    testWidgets('loads and displays initial data', (tester) async {
      final items = List.generate(10, (i) => 'Item $i');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UILoadMoreContainer<String>(
              onLoadData: (page, limit) async => (items, items.length),
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
            ),
          ),
        ),
      );

      // Initially shows loader
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(); // Start loading
      await tester.pump(const Duration(milliseconds: 100)); // Complete loading

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 9'), findsOneWidget);
    });

    testWidgets('shows empty widget when no data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UILoadMoreContainer<String>(
              onLoadData: (page, limit) async => (<String>[], 0),
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
              emptyWidget: const Text('No Data Found'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No Data Found'), findsOneWidget);
    });

    testWidgets('shows error widget on failure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UILoadMoreContainer<String>(
              onLoadData: (page, limit) async =>
                  throw Exception('Fetch Failed'),
              itemBuilder: (context, item, index) =>
                  ListTile(title: Text(item)),
              errorWidget: const Text('Error Occurred'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Error Occurred'), findsOneWidget);
    });
  });
}
