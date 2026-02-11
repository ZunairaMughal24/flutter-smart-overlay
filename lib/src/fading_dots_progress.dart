import 'dart:math' as math;
import 'package:flutter/material.dart';

class FadingDotsProgressIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final Gradient? gradient;
  final int dotCount;
  final Duration duration;
  final double? dotSize;
  final double? radius;

  const FadingDotsProgressIndicator({
    super.key,
    this.size = 60.0,
    this.color,
    this.gradient,
    this.dotCount = 10,
    this.duration = const Duration(milliseconds: 1200),
    this.dotSize,
    this.radius,
  });

  @override
  State<FadingDotsProgressIndicator> createState() =>
      _FadingDotsProgressIndicatorState();
}

class _FadingDotsProgressIndicatorState
    extends State<FadingDotsProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
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
              painter: _FadingDotsPainter(
                animation: _controller.value,
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

class _FadingDotsPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int dotCount;
  final double? dotSize;
  final double? radius;

  _FadingDotsPainter({
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
  bool shouldRepaint(covariant _FadingDotsPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.radius != radius;
  }
}
