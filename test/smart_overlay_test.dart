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

    testWidgets('SmartOverlayWidget should render flux loader', (
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

      expect(find.byType(FluxWaveProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets(
      'SmartOverlay.showCustom renders the custom card style, not the loader',
      (WidgetTester tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  capturedContext = context;
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        SmartOverlay.showCustom(
          context: capturedContext,
          message: 'Saved!',
          customWidget: const Icon(Icons.check_circle),
        );
        await tester.pump();

        // customWidget only renders on the `custom` type's icon slot — the
        // `loader` type ignores it entirely, so this proves showCustom
        // actually reaches SmartOverlayType.custom rather than the
        // hardcoded `.loader` that SmartOverlay.show always uses.
        expect(find.text('Saved!'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);

        SmartOverlay.hide();
      },
    );
  });
}
