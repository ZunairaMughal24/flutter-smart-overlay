import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A progress indicator made of radial tick marks (like a clock face)
/// whose opacity sweeps around the circle.
class NexusProgressIndicator extends StatefulWidget {
  /// The width and height of the indicator's bounding box.
  final double size;

  /// The color of the tick marks. Defaults to the theme's primary color.
  final Color? color;

  /// An optional gradient applied to the tick marks, overriding [color]
  /// as a flat stroke.
  final Gradient? gradient;

  /// The number of tick marks arranged around the circle.
  final int barCount;

  /// The thickness of each tick mark.
  final double strokeWidth;

  /// How long it takes for the opacity sweep to travel once around all
  /// tick marks.
  final Duration speed;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates a [NexusProgressIndicator].
  const NexusProgressIndicator({
    super.key,
    this.size = 50.0,
    this.color,
    this.gradient,
    this.barCount = 12,
    this.strokeWidth = 3.5,
    this.speed = const Duration(milliseconds: 1000),
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  /// The easing curve applied to the opacity sweep.
  final Curve curve;

  @override
  State<NexusProgressIndicator> createState() => _NexusProgressIndicatorState();
}

class _NexusProgressIndicatorState extends State<NexusProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.speed);
    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NexusProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.speed != oldWidget.speed) {
      _controller.duration = widget.speed;
    }
    if (widget.isAnimating != oldWidget.isAnimating) {
      widget.isAnimating ? _controller.repeat() : _controller.stop();
    }
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
              painter: _NexusPainter(
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

class _NexusPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int barCount;
  final double strokeWidth;

  _NexusPainter({
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
  bool shouldRepaint(covariant _NexusPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.barCount != barCount ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
