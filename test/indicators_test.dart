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

  // Every indicator gets its own didUpdateWidget-driven stop/resume logic,
  // hand-added to each file individually — so each one is verified here
  // rather than trusting that a single indicator's test covers the rest.
  final Map<String, Widget Function({required bool isAnimating, required Duration speed})>
  indicatorBuilders = {
    'FluxWave': ({required isAnimating, required speed}) =>
        FluxWaveProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Lumina': ({required isAnimating, required speed}) =>
        LuminaProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Hydra': ({required isAnimating, required speed}) =>
        HydraProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Aura': ({required isAnimating, required speed}) =>
        AuraProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Nova': ({required isAnimating, required speed}) =>
        NovaProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Orbit': ({required isAnimating, required speed}) =>
        OrbitProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Eclipse': ({required isAnimating, required speed}) =>
        EclipseProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Nexus': ({required isAnimating, required speed}) =>
        NexusProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Zenith': ({required isAnimating, required speed}) =>
        ZenithProgressIndicator(isAnimating: isAnimating, speed: speed),
    'Vortex': ({required isAnimating, required speed}) =>
        VortexProgressIndicator(isAnimating: isAnimating, speed: speed),
  };

  group('isAnimating + speed control (all 10 indicators)', () {
    for (final entry in indicatorBuilders.entries) {
      testWidgets(
        '${entry.key}: animates by default, accepts a custom speed, '
        'and stops when isAnimating is false',
        (WidgetTester tester) async {
          const customSpeed = Duration(milliseconds: 500);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: entry.value(isAnimating: true, speed: customSpeed),
              ),
            ),
          );
          await tester.pump();
          expect(
            tester.binding.transientCallbackCount,
            greaterThan(0),
            reason: '${entry.key} should animate by default',
          );

          // Re-pumping the same widget subtree reuses the existing
          // Element/State and triggers didUpdateWidget, exercising the
          // stop path.
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: entry.value(isAnimating: false, speed: customSpeed),
              ),
            ),
          );
          await tester.pump();
          expect(
            tester.binding.transientCallbackCount,
            0,
            reason: '${entry.key} should stop when isAnimating is false',
          );
        },
      );
    }
  });
}
