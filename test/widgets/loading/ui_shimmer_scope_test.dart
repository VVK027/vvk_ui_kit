import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vvk_ui_kit/vvk_ui_kit.dart';

void main() {
  group('UIShimmerScope', () {
    testWidgets('propagates isLoading state', (tester) async {
      bool? isScopeLoading;

      await tester.pumpWidget(
        MaterialApp(
          home: UIShimmerScope(
            isLoading: true,
            child: Builder(
              builder: (context) {
                isScopeLoading = UIShimmerScope.isLoadingOf(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(isScopeLoading, isTrue);
    });
  });
}
