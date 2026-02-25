import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_overlay/smart_overlay.dart';

void main() {
  group('Progress Indicator Tests', () {
    testWidgets('FadingDotsProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FadingDotsProgressIndicator())),
      );
      expect(find.byType(FadingDotsProgressIndicator), findsOneWidget);
    });

    testWidgets('LiquidProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LiquidProgressIndicator())),
      );
      expect(find.byType(LiquidProgressIndicator), findsOneWidget);
    });

    testWidgets('RippleBloomProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RippleBloomProgressIndicator())),
      );
      expect(find.byType(RippleBloomProgressIndicator), findsOneWidget);
    });

    testWidgets('PulseRingProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PulseRingProgressIndicator())),
      );
      expect(find.byType(PulseRingProgressIndicator), findsOneWidget);
    });

    testWidgets('ChasingDotsProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ChasingDotsProgressIndicator())),
      );
      expect(find.byType(ChasingDotsProgressIndicator), findsOneWidget);
    });

    testWidgets('DoubleBounceProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DoubleBounceProgressIndicator()),
        ),
      );
      expect(find.byType(DoubleBounceProgressIndicator), findsOneWidget);
    });

    testWidgets('ClassicSpinnerProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ClassicSpinnerProgressIndicator()),
        ),
      );
      expect(find.byType(ClassicSpinnerProgressIndicator), findsOneWidget);
    });

    testWidgets('LeafSpinnerProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LeafSpinnerProgressIndicator())),
      );
      expect(find.byType(LeafSpinnerProgressIndicator), findsOneWidget);
    });

    testWidgets('ChasingArrowsProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ChasingArrowsProgressIndicator()),
        ),
      );
      expect(find.byType(ChasingArrowsProgressIndicator), findsOneWidget);
    });
  });

  group('Indicator Special Parameters', () {
    testWidgets('Indicators support custom colors and gradients', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                FadingDotsProgressIndicator(color: Colors.red),
                ScallopedProgressIndicator(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(FadingDotsProgressIndicator), findsOneWidget);
      expect(find.byType(ScallopedProgressIndicator), findsOneWidget);
    });
  });
}
