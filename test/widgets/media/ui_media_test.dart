import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIImageScope', () {
    testWidgets('provides builders to descendants', (tester) async {
      var networkBuilderCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: UIImageScope(
            networkImageBuilder: (context, params) {
              networkBuilderCalled = true;
              return const Text('Network Image');
            },
            child: const Scaffold(
              body: UIImage('https://example.com/image.png'),
            ),
          ),
        ),
      );

      expect(networkBuilderCalled, isTrue);
      expect(find.text('Network Image'), findsOneWidget);
    });

    testWidgets('provides svg builder to descendants', (tester) async {
      var svgBuilderCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: UIImageScope(
            svgBuilder: (context, params) {
              svgBuilderCalled = true;
              return const Text('SVG Image');
            },
            child: const Scaffold(
              body: UIImage('https://example.com/image.svg'),
            ),
          ),
        ),
      );

      expect(svgBuilderCalled, isTrue);
      expect(find.text('SVG Image'), findsOneWidget);
    });
  });

  group('UIImage', () {
    testWidgets('renders fallback for empty source', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIImage('')),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    });

    testWidgets('renders custom fallback', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIImage('', fallback: Text('Custom Fallback')),
          ),
        ),
      );

      expect(find.text('Custom Fallback'), findsOneWidget);
    });

    testWidgets('renders base64 image', (tester) async {
      const base64Image =
          'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIImage(base64Image)),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders fallback for invalid network url', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: UIImage('not-a-valid-url')),
        ),
      );

      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    });

    testWidgets('applies borderRadius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIImage(
              '',
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('uses urlTransformer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UIImageScope(
            networkImageBuilder: (context, params) => Text('url:${params.url}'),
            child: Scaffold(
              body: UIImage(
                'https://example.com/photo.jpg',
                urlTransformer: (url) => '$url?size=large',
              ),
            ),
          ),
        ),
      );

      expect(
        find.text('url:https://example.com/photo.jpg?size=large'),
        findsOneWidget,
      );
    });

    testWidgets('renders network image without scope builder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIImage('https://example.com/photo.png'),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders asset svg via default builder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIImage('test/assets/sample.svg'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });

  group('UIImagePreviewFrame', () {
    testWidgets('renders child with aspect ratio', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIImagePreviewFrame(child: Text('Preview')),
          ),
        ),
      );

      expect(find.byType(AspectRatio), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);
    });

    testWidgets('renders with fixed height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UIImagePreviewFrame(
              height: 200,
              child: Text('Fixed'),
            ),
          ),
        ),
      );

      expect(find.text('Fixed'), findsOneWidget);
    });

    testWidgets('imagePreviewPlaceholder shows initials', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => imagePreviewPlaceholder(context, 'My App'),
            ),
          ),
        ),
      );

      expect(find.text('MA'), findsOneWidget);
    });

    testWidgets('imagePreviewImage shows placeholder for empty path', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: imagePreviewImage('', fallbackTitle: 'Test App'),
          ),
        ),
      );

      expect(find.text('TA'), findsOneWidget);
    });

    testWidgets('imagePreviewImage uses network for http url', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: imagePreviewImage(
              'https://example.com/image.png',
              fallbackTitle: 'Fallback',
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });
  });
}
