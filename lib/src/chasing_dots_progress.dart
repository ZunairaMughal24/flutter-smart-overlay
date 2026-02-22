import 'dart:math' as math;
import 'package:flutter/material.dart';

class ChasingDotsProgressIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final Color? secondaryColor;
  final Gradient? gradient;
  final int dotCount;
  final double dotSize;
  final Duration speed;

  const ChasingDotsProgressIndicator({
    super.key,
    this.size = 60.0,
    this.color,
    this.secondaryColor,
    this.gradient,
    this.dotCount = 2,
    this.dotSize = 6.0,
    this.speed = const Duration(milliseconds: 1800),
  });

  @override
  State<ChasingDotsProgressIndicator> createState() =>
      _ChasingDotsProgressIndicatorState();
}

class _ChasingDotsProgressIndicatorState
    extends State<ChasingDotsProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.speed)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.color ?? theme.colorScheme.primary;
    final trailColor =
        widget.secondaryColor ?? baseColor.withValues(alpha: 0.3);

    return Semantics(
      label: 'Loading indicator',
      value: 'busy',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _ChasingDotsPainter(
                animation: _controller.value,
                color: baseColor,
                trailColor: trailColor,
                gradient: widget.gradient,
                dotCount: widget.dotCount,
                dotSize: widget.dotSize,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ChasingDotsPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Color trailColor;
  final Gradient? gradient;
  final int dotCount;
  final double dotSize;

  _ChasingDotsPainter({
    required this.animation,
    required this.color,
    required this.trailColor,
    this.gradient,
    required this.dotCount,
    required this.dotSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double orbitRadius =
        (math.min(size.width, size.height) - dotSize) / 2;

    // Draw the faint orbit track
    final trackPaint = Paint()
      ..color = trailColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    canvas.drawCircle(center, orbitRadius, trackPaint);

    // Draw each chasing dot with staggered positions and eased motion
    for (int i = 0; i < dotCount; i++) {
      final double stagger = i / dotCount;

      double t = (animation + stagger) % 1.0;

      final double easeStrength = 1.0 + (i * 0.6);
      final double easedT = _asymmetricEase(t, easeStrength);

      final double angle = easedT * 2 * math.pi - (math.pi / 2);

      final Offset dotCenter = Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      );

      final double scaleFactor = 1.0 - (i * 0.15).clamp(0.0, 0.5);
      final double currentDotSize = dotSize * scaleFactor;

      final double opacity = (1.0 - (i * 0.2)).clamp(0.3, 1.0);

      final dotPaint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      if (gradient != null) {
        dotPaint.shader = gradient!.createShader(
          Rect.fromCircle(center: dotCenter, radius: currentDotSize),
        );
      }

      canvas.drawCircle(dotCenter, currentDotSize, dotPaint);

      if (i == 0) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

        canvas.drawCircle(dotCenter, currentDotSize * 1.8, glowPaint);
      }

      _drawTrail(canvas, center, orbitRadius, angle, dotPaint, currentDotSize);
    }
  }

  double _asymmetricEase(double t, double strength) {
    return (math.sin(t * math.pi - math.pi / 2) + 1) / 2 * (1 - 1 / strength) +
        t / strength;
  }

  void _drawTrail(
    Canvas canvas,
    Offset center,
    double radius,
    double headAngle,
    Paint basePaint,
    double size,
  ) {
    const int trailSegments = 8;
    const double trailArc = math.pi / 4;

    for (int s = 1; s <= trailSegments; s++) {
      final double frac = s / trailSegments;
      final double trailAngle = headAngle - (trailArc * frac);

      final Offset pos = Offset(
        center.dx + radius * math.cos(trailAngle),
        center.dy + radius * math.sin(trailAngle),
      );

      final double trailOpacity = (0.2 * (1.0 - frac)).clamp(0.0, 1.0);
      final double trailSize = size * (1.0 - frac * 0.7);

      final trailPaint = Paint()
        ..color = color.withValues(alpha: trailOpacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, trailSize, trailPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChasingDotsPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.dotSize != dotSize;
  }
}
