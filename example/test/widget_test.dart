import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit_example/app.dart';

void main() {
  testWidgets('Showcase home loads catalog', (tester) async {
    await tester.pumpWidget(const FlutterUiComponentsExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('VVK UI Kit Showcase'), findsOneWidget);
    expect(find.text('VVK UI Kit Showcase'), findsOneWidget);
    expect(find.text('Glassmorphism'), findsOneWidget);
  });
}
