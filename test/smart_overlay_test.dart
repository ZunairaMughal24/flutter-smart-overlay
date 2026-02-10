import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_overlay/smart_overlay.dart';
import 'package:smart_overlay/src/overlay_widget.dart';

void main() {
  group('SmartOverlay Tests', () {
    test('SmartOverlayManager should be a singleton', () {
      final instance1 = SmartOverlayManager();
      final instance2 = SmartOverlayManager();
      expect(instance1, same(instance2));
    });

    test('SmartOverlayType enum should have expected values', () {
      expect(SmartOverlayType.values, [
        SmartOverlayType.loader,
        SmartOverlayType.custom,
      ]);
    });

    testWidgets('SmartOverlayWidget should render scalloped loader', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SmartOverlayWidget(
              type: SmartOverlayType.loader,
              options: OverlayOptions(message: 'Loading...'),
            ),
          ),
        ),
      );

      expect(find.byType(ScallopedProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });
  });
}
