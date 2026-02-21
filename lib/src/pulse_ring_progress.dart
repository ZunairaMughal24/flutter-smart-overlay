import 'dart:math' as math;
import 'package:flutter/material.dart';

class PulseRingProgressIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final Gradient? gradient;
  final int ringCount;
  final double strokeWidth;
  final Duration speed;
  final int petalCount;

  const PulseRingProgressIndicator({
    super.key,
    this.size = 60.0,
    this.color,
    this.gradient,
    this.ringCount = 3,
    this.strokeWidth = 2.0,
    this.speed = const Duration(milliseconds: 2400),
    this.petalCount = 6,
  });

  @override
  State<PulseRingProgressIndicator> createState() =>
      _PulseRingProgressIndicatorState();
}

class _PulseRingProgressIndicatorState extends State<PulseRingProgressIndicator>
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
              painter: _PulseRingPainter(
                animation: _controller.value,
                color: baseColor,
                gradient: widget.gradient,
                ringCount: widget.ringCount,
                strokeWidth: widget.strokeWidth,
                petalCount: widget.petalCount,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PulseRingPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int ringCount;
  final double strokeWidth;
  final int petalCount;

  _PulseRingPainter({
    required this.animation,
    required this.color,
    this.gradient,
    required this.ringCount,
    required this.strokeWidth,
    required this.petalCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = math.min(size.width, size.height) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: maxRadius);

    final double pulse = 0.5 + 0.5 * math.sin(animation * 2 * math.pi);
    final double dotRadius = maxRadius * 0.06 + maxRadius * 0.04 * pulse;
    final double dotOpacity = (0.6 + 0.4 * pulse).clamp(0.0, 1.0);

    final dotPaint = Paint()
      ..color = color.withValues(alpha: dotOpacity)
      ..style = PaintingStyle.fill;

    if (gradient != null) {
      dotPaint.shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: dotRadius),
      );
    }

    canvas.drawCircle(center, dotRadius, dotPaint);

    for (int i = 0; i < ringCount; i++) {
      final double stagger = i / ringCount;
      double progress = (animation + stagger) % 1.0;

      final double easedProgress = 1.0 - math.pow(1.0 - progress, 2.5);

      final double radius = maxRadius * 0.15 + maxRadius * 0.85 * easedProgress;

      final double opacity = (1.0 - easedProgress).clamp(0.0, 1.0);

      final double dynamicStroke = strokeWidth * (1.0 - easedProgress * 0.6);

      final ringPaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = dynamicStroke
        ..isAntiAlias = true;

      if (gradient != null) {
        ringPaint.shader = gradient!.createShader(rect);
        ringPaint.color = color.withValues(alpha: opacity * 0.8);
      }

      canvas.drawCircle(center, radius, ringPaint);

      if (petalCount > 0 && easedProgress > 0.1 && easedProgress < 0.85) {
        _drawPetals(canvas, center, radius, opacity, dynamicStroke, rect);
      }
    }
  }

  void _drawPetals(
    Canvas canvas,
    Offset center,
    double radius,
    double opacity,
    double stroke,
    Rect bounds,
  ) {
    final double petalAngle = math.pi / 12;
    final double rotation = animation * 2 * math.pi;

    final petalPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 0.7
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    if (gradient != null) {
      petalPaint.shader = gradient!.createShader(bounds);
      petalPaint.color = color.withValues(alpha: opacity * 0.5);
    }

    for (int p = 0; p < petalCount; p++) {
      final double baseAngle = (p * 2 * math.pi / petalCount) + rotation;

      final Path petal = Path();
      petal.addArc(
        Rect.fromCircle(center: center, radius: radius),
        baseAngle - petalAngle / 2,
        petalAngle,
      );

      canvas.drawPath(petal, petalPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PulseRingPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.ringCount != ringCount ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.petalCount != petalCount;
  }
}
