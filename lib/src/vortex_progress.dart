import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A progress indicator depicting arrow-tipped arcs chasing each other
/// around a circular track, like a vortex being pulled inward.
class VortexProgressIndicator extends StatefulWidget {
  /// The width and height of the indicator's bounding box.
  final double size;

  /// The color of the arcs and arrowheads. Defaults to the theme's
  /// primary color.
  final Color? color;

  /// An optional gradient applied to the arcs and arrowheads, overriding
  /// [color] as a flat fill/stroke.
  final Gradient? gradient;

  /// The number of arrow-tipped arcs arranged around the track.
  final int arrowCount;

  /// The stroke width of each arc.
  final double strokeWidth;

  /// How long it takes for the arcs to complete one full rotation.
  final Duration speed;

  /// The easing curve applied to the rotation.
  final Curve curve;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates a [VortexProgressIndicator].
  const VortexProgressIndicator({
    super.key,
    this.size = 50.0,
    this.color,
    this.gradient,
    this.arrowCount = 3,
    this.strokeWidth = 3.5,
    this.speed = const Duration(milliseconds: 1500),
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  @override
  State<VortexProgressIndicator> createState() =>
      _VortexProgressIndicatorState();
}

class _VortexProgressIndicatorState extends State<VortexProgressIndicator>
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
  void didUpdateWidget(covariant VortexProgressIndicator oldWidget) {
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
              painter: _VortexPainter(
                animation: animatedValue,
                color: baseColor,
                gradient: widget.gradient,
                arrowCount: widget.arrowCount,
                strokeWidth: widget.strokeWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VortexPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int arrowCount;
  final double strokeWidth;

  _VortexPainter({
    required this.animation,
    required this.color,
    this.gradient,
    required this.arrowCount,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - (strokeWidth * 4)) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    if (gradient != null) {
      final shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
      paint.shader = shader;
      fillPaint.shader = shader;
    }

    final double rotationOffset = animation * 2 * math.pi;
    final double sweepAngle = (2 * math.pi / arrowCount) * 0.6;

    for (int i = 0; i < arrowCount; i++) {
      final double startAngle = rotationOffset + (i * 2 * math.pi / arrowCount);

      const int segments = 15;
      for (int j = 0; j < segments; j++) {
        final double segmentStart = startAngle + (j / segments) * sweepAngle;
        final double segmentSweep = sweepAngle / segments;

        final double currentStroke =
            strokeWidth * (0.3 + (0.7 * (j / segments)));

        paint.strokeWidth = currentStroke;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          segmentStart,
          segmentSweep,
          false,
          paint,
        );
      }

      final double tipAngle = startAngle + sweepAngle;
      final double tipX = center.dx + radius * math.cos(tipAngle);
      final double tipY = center.dy + radius * math.sin(tipAngle);

      canvas.save();
      canvas.translate(tipX, tipY);

      canvas.rotate(tipAngle + math.pi / 2);

      final double headWidth = strokeWidth * 2.8;
      final double headLength = strokeWidth * 2.2;

      final path = Path();

      path.moveTo(headLength, 0);

      path.lineTo(0, -headWidth / 2);
      path.lineTo(0, headWidth / 2);
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _VortexPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.arrowCount != arrowCount ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
