import 'dart:math' as math;
import 'package:flutter/material.dart';

class LeafSpinnerProgressIndicator extends StatefulWidget {
  final double size;

  final Color? color;

  final Gradient? gradient;

  final int leafCount;

  final double strokeWidth;

  final Duration speed;

  const LeafSpinnerProgressIndicator({
    super.key,
    this.size = 50.0,
    this.color,
    this.gradient,
    this.leafCount = 12,
    this.strokeWidth = 2.0,
    this.speed = const Duration(milliseconds: 1200),
  });

  @override
  State<LeafSpinnerProgressIndicator> createState() =>
      _LeafSpinnerProgressIndicatorState();
}

class _LeafSpinnerProgressIndicatorState
    extends State<LeafSpinnerProgressIndicator>
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
              painter: _LeafSpinnerPainter(
                animation: _controller.value,
                color: baseColor,
                gradient: widget.gradient,
                leafCount: widget.leafCount,
                strokeWidth: widget.strokeWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeafSpinnerPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int leafCount;
  final double strokeWidth;

  _LeafSpinnerPainter({
    required this.animation,
    required this.color,
    this.gradient,
    required this.leafCount,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2;
    final double innerRadius = radius * 0.45;
    final double outerRadius = radius * 0.95;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < leafCount; i++) {
      final double angleStep = 2 * math.pi / leafCount;
      final double currentAngle = i * angleStep;

      final double positionProgress = i / leafCount;
      double opacityFactor = (positionProgress - animation) % 1.0;
      final double opacity = math.pow(opacityFactor, 1.5).toDouble();

      paint.color = color.withValues(alpha: opacity.clamp(0.1, 1.0));

      if (gradient != null) {
        paint.shader = gradient!.createShader(
          Rect.fromCircle(center: center, radius: radius),
        );
      }

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(currentAngle);

      canvas.rotate(math.pi / 15);

      final double leafLength = outerRadius - innerRadius;
      final double leafWidth = leafLength * 0.35;

      final path = Path();

      path.moveTo(innerRadius, 0);
      path.quadraticBezierTo(
        innerRadius + leafLength * 0.4,
        -leafWidth,
        outerRadius,
        0,
      );
      path.quadraticBezierTo(
        innerRadius + leafLength * 0.4,
        leafWidth,
        innerRadius,
        0,
      );
      path.close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LeafSpinnerPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.leafCount != leafCount ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
