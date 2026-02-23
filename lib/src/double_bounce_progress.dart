import 'dart:math' as math;
import 'package:flutter/material.dart';

class DoubleBounceProgressIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final Color? secondaryColor;
  final Gradient? gradient;
  final Duration speed;

  const DoubleBounceProgressIndicator({
    super.key,
    this.size = 60.0,
    this.color,
    this.secondaryColor,
    this.gradient,
    this.speed = const Duration(milliseconds: 2000),
    this.curve = Curves.linear,
  });

  final Curve curve;

  @override
  State<DoubleBounceProgressIndicator> createState() =>
      _DoubleBounceProgressIndicatorState();
}

class _DoubleBounceProgressIndicatorState
    extends State<DoubleBounceProgressIndicator>
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
    final primary = widget.color ?? theme.colorScheme.primary;
    final secondary = widget.secondaryColor ?? primary.withValues(alpha: 0.55);

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
              painter: _DoubleBouncePainter(
                animation: animatedValue,
                primaryColor: primary,
                secondaryColor: secondary,
                gradient: widget.gradient,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DoubleBouncePainter extends CustomPainter {
  final double animation;
  final Color primaryColor;
  final Color secondaryColor;
  final Gradient? gradient;

  _DoubleBouncePainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = math.min(size.width, size.height) / 2;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final double scale1 =
        (math.sin(animation * 2 * math.pi - math.pi / 2) + 1) / 2;
    final double scale2 =
        (math.sin(animation * 2 * math.pi + math.pi / 2) + 1) / 2;

    final double radius1 = maxRadius * (0.2 + 0.8 * scale1);
    final double radius2 = maxRadius * (0.2 + 0.8 * scale2);

    final double opacity1 = 0.3 + 0.4 * (1.0 - scale1);
    final double opacity2 = 0.3 + 0.4 * (1.0 - scale2);

    final paint1 = Paint()
      ..color = primaryColor.withValues(alpha: opacity1.clamp(0.0, 1.0))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final paint2 = Paint()
      ..color = secondaryColor.withValues(alpha: opacity2.clamp(0.0, 1.0))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    if (gradient != null) {
      paint1.shader = gradient!.createShader(rect);
      paint2.shader = gradient!.createShader(rect);
    }

    canvas.drawCircle(center, radius2, paint2);
    canvas.drawCircle(center, radius1, paint1);
  }

  @override
  bool shouldRepaint(covariant _DoubleBouncePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
