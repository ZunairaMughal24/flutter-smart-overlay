import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClassicSpinnerProgressIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final Gradient? gradient;
  final int barCount;
  final double strokeWidth;
  final Duration speed;

  const ClassicSpinnerProgressIndicator({
    super.key,
    this.size = 50.0,
    this.color,
    this.gradient,
    this.barCount = 12,
    this.strokeWidth = 3.5,
    this.speed = const Duration(milliseconds: 1000),
    this.curve = Curves.linear,
  });

  final Curve curve;

  @override
  State<ClassicSpinnerProgressIndicator> createState() =>
      _ClassicSpinnerProgressIndicatorState();
}

class _ClassicSpinnerProgressIndicatorState
    extends State<ClassicSpinnerProgressIndicator>
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
            final double animatedValue = widget.curve.transform(
              _controller.value,
            );
            return CustomPaint(
              painter: _ClassicSpinnerPainter(
                animation: animatedValue,
                color: baseColor,
                gradient: widget.gradient,
                barCount: widget.barCount,
                strokeWidth: widget.strokeWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ClassicSpinnerPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int barCount;
  final double strokeWidth;

  _ClassicSpinnerPainter({
    required this.animation,
    required this.color,
    this.gradient,
    required this.barCount,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2;
    final double innerRadius = radius * 0.55;
    final double outerRadius = radius * 0.9;

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < barCount; i++) {
      final double angleStep = 2 * math.pi / barCount;
      final double currentAngle = i * angleStep;

      final double positionProgress = i / barCount;

      double opacityFactor = (positionProgress - animation) % 1.0;

      final double opacity = math.pow(opacityFactor, 1.5).toDouble();

      paint.color = color.withValues(alpha: opacity.clamp(0.1, 1.0));

      if (gradient != null) {
        paint.shader = gradient!.createShader(
          Rect.fromCircle(center: center, radius: radius),
        );
      }

      final double x1 = center.dx + innerRadius * math.cos(currentAngle);
      final double y1 = center.dy + innerRadius * math.sin(currentAngle);
      final double x2 = center.dx + outerRadius * math.cos(currentAngle);
      final double y2 = center.dy + outerRadius * math.sin(currentAngle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ClassicSpinnerPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.barCount != barCount ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
