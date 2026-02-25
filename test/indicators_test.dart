import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_overlay/smart_overlay.dart';

void main() {
  group('Progress Indicator Tests', () {
    testWidgets('LuminaProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LuminaProgressIndicator())),
      );
      expect(find.byType(LuminaProgressIndicator), findsOneWidget);
    });

    testWidgets('HydraProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HydraProgressIndicator())),
      );
      expect(find.byType(HydraProgressIndicator), findsOneWidget);
    });

    testWidgets('AuraProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AuraProgressIndicator())),
      );
      expect(find.byType(AuraProgressIndicator), findsOneWidget);
    });

    testWidgets('NovaProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NovaProgressIndicator())),
      );
      expect(find.byType(NovaProgressIndicator), findsOneWidget);
    });

    testWidgets('OrbitProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: OrbitProgressIndicator())),
      );
      expect(find.byType(OrbitProgressIndicator), findsOneWidget);
    });

    testWidgets('EclipseProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EclipseProgressIndicator())),
      );
      expect(find.byType(EclipseProgressIndicator), findsOneWidget);
    });

    testWidgets('NexusProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NexusProgressIndicator())),
      );
      expect(find.byType(NexusProgressIndicator), findsOneWidget);
    });

    testWidgets('ZenithProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ZenithProgressIndicator())),
      );
      expect(find.byType(ZenithProgressIndicator), findsOneWidget);
    });

    testWidgets('VortexProgressIndicator renders correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VortexProgressIndicator())),
      );
      expect(find.byType(VortexProgressIndicator), findsOneWidget);
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
                LuminaProgressIndicator(color: Colors.red),
                FluxWaveProgressIndicator(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(LuminaProgressIndicator), findsOneWidget);
      expect(find.byType(FluxWaveProgressIndicator), findsOneWidget);
    });
  });
}
