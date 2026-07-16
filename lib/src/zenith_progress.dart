import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A progress indicator depicting flower-petal shapes arranged in a ring,
/// each fading in and out in sequence like petals unfurling.
class ZenithProgressIndicator extends StatefulWidget {
  /// The width and height of the indicator's bounding box.
  final double size;

  /// The color of the petals. Defaults to the theme's primary color.
  final Color? color;

  /// An optional gradient applied to the petals, overriding [color] as a
  /// flat fill.
  final Gradient? gradient;

  /// The number of petals arranged around the ring.
  final int leafCount;

  /// Reserved for future stroke-based rendering; currently unused since
  /// petals are filled rather than stroked.
  final double strokeWidth;

  /// How long it takes for the fade sequence to travel once around all
  /// petals.
  final Duration speed;

  /// The easing curve applied to the fade sequence.
  final Curve curve;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates a [ZenithProgressIndicator].
  const ZenithProgressIndicator({
    super.key,
    this.size = 50.0,
    this.color,
    this.gradient,
    this.leafCount = 12,
    this.strokeWidth = 2.0,
    this.speed = const Duration(milliseconds: 1200),
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  @override
  State<ZenithProgressIndicator> createState() =>
      _ZenithProgressIndicatorState();
}

class _ZenithProgressIndicatorState extends State<ZenithProgressIndicator>
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
  void didUpdateWidget(covariant ZenithProgressIndicator oldWidget) {
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
              painter: _ZenithPainter(
                animation: animatedValue,
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

class _ZenithPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int leafCount;
  final double strokeWidth;

  _ZenithPainter({
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
  bool shouldRepaint(covariant _ZenithPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.leafCount != leafCount ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
