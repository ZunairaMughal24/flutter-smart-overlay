import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A progress indicator made of dots arranged in a circle that fade and
/// scale in sequence, chasing around the ring.
class LuminaProgressIndicator extends StatefulWidget {
  /// The width and height of the indicator's bounding box.
  final double size;

  /// The color of the dots. Defaults to the theme's primary color.
  final Color? color;

  /// An optional gradient applied to each dot, overriding [color] as a
  /// flat fill.
  final Gradient? gradient;

  /// The number of dots arranged around the ring.
  final int dotCount;

  /// How long it takes for the fade/scale effect to travel once around
  /// all dots.
  final Duration speed;

  /// The radius of each dot. Defaults to a size proportional to [size].
  final double? dotSize;

  /// The radius of the circle the dots are arranged on. Defaults to a
  /// size proportional to [size].
  final double? radius;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates a [LuminaProgressIndicator].
  const LuminaProgressIndicator({
    super.key,
    this.size = 60.0,
    this.color,
    this.gradient,
    this.dotCount = 10,
    this.speed = const Duration(milliseconds: 1200),
    this.dotSize,
    this.radius,
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  /// The easing curve applied to the dot fade/scale animation.
  final Curve curve;

  @override
  State<LuminaProgressIndicator> createState() =>
      _LuminaProgressIndicatorState();
}

class _LuminaProgressIndicatorState extends State<LuminaProgressIndicator>
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
  void didUpdateWidget(covariant LuminaProgressIndicator oldWidget) {
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
              painter: _LuminaPainter(
                animation: animatedValue,
                color: baseColor,
                gradient: widget.gradient,
                dotCount: widget.dotCount,
                dotSize: widget.dotSize,
                radius: widget.radius,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LuminaPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int dotCount;
  final double? dotSize;
  final double? radius;

  _LuminaPainter({
    required this.animation,
    required this.color,
    this.gradient,
    this.dotCount = 10,
    this.dotSize,
    this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final drawRadius = radius ?? (size.width / 2.5);
    final baseDotRadius = dotSize ?? (size.width / 12);

    for (int i = 0; i < dotCount; i++) {
      final double angle = (i * 2 * math.pi / dotCount) - (math.pi / 2);

      double dotProgress = (animation - (i / dotCount)) % 1.0;
      if (dotProgress < 0) dotProgress += 1.0;

      final double scale = 0.4 + (math.sin(dotProgress * math.pi) * 0.6);
      final double opacity = 0.2 + (math.sin(dotProgress * math.pi) * 0.8);

      final Offset dotCenter = Offset(
        center.dx + drawRadius * math.cos(angle),
        center.dy + drawRadius * math.sin(angle),
      );

      final paint = Paint()
        ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      if (gradient != null) {
        paint.shader = gradient!.createShader(
          Rect.fromCircle(center: dotCenter, radius: baseDotRadius * scale),
        );

        paint.color = color.withValues(alpha: opacity.clamp(0.0, 1.0));
      }

      canvas.drawCircle(dotCenter, baseDotRadius * scale, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LuminaPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.radius != radius;
  }
}
