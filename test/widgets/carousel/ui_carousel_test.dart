import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UICarouselWithIndicator', () {
    testWidgets('renders items and updates indicator on page change', (
      tester,
    ) async {
      int changedPage = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UICarouselWithIndicator(
              itemCount: 3,
              height: 200,
              builder: (context, index, realIndex) => Text('Page $index'),
              selectedIndicatorColor: Colors.blue,
              unSelectedIndicatorColor: Colors.grey,
              onPageChange: (index) => changedPage = index,
            ),
          ),
        ),
      );

      expect(find.text('Page 0'), findsOneWidget);

      // Swipe to next page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('Page 1'), findsOneWidget);
      expect(changedPage, 1);
    });
  });

  group('UICarousel layout helpers', () {
    test('carouselPageCount computes pages', () {
      expect(carouselPageCount(5, 2), 3);
      expect(carouselPageCount(0, 2), 0);
    });

    test('carouselPageSlice returns correct slice', () {
      expect(carouselPageSlice(['A', 'B', 'C'], 0, 2), ['A', 'B']);
      expect(carouselPageSlice(['A', 'B', 'C'], 2, 2), isEmpty);
    });

    testWidgets('UICarouselRowPage renders items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 100,
              child: UICarouselRowPage<String>(
                items: const ['A', 'B'],
                itemsPerPage: 2,
                gap: 8,
                itemBuilder: (_, item) => Text(item),
              ),
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });
  });

  group('UISectionCarousel', () {
    testWidgets('renders items and responds to controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UISectionCarousel(
              pageCount: 3,
              pageHeight: 200,
              pageBuilder: (context, index) => Text('Page $index'),
            ),
          ),
        ),
      );

      expect(find.text('Page 0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded).last);
      await tester.pumpAndSettle();

      expect(find.text('Page 1'), findsOneWidget);
    });
  });

  group('UICarouselControls', () {
    testWidgets('renders nav buttons and indicators', (tester) async {
      var page = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UICarouselControls(
              pageCount: 3,
              currentPage: page,
              onPrevious: () => page = (page - 1).clamp(0, 2),
              onNext: () => page = (page + 1).clamp(0, 2),
              onPageSelected: (index) => page = index,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      expect(page, 1);
    });
  });

  group('UICarouselControlsColors', () {
    test('copyWith overrides palette values', () {
      const colors = UICarouselControlsColors();
      final updated = colors.copyWith(accent: Colors.red);
      expect(updated.accent, Colors.red);
    });
  });
}
