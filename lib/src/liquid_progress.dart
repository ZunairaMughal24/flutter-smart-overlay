import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiquidProgressIndicator extends StatefulWidget {
  final double? value;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double waveAmplitude;
  final double waveFrequency;

  const LiquidProgressIndicator({
    super.key,
    this.value,
    this.size = 60.0,
    this.color,
    this.backgroundColor,
    this.gradient,
    this.waveAmplitude = 4.0,
    this.waveFrequency = 1.0,
  });

  @override
  State<LiquidProgressIndicator> createState() =>
      _LiquidProgressIndicatorState();
}

class _LiquidProgressIndicatorState extends State<LiquidProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = widget.color ?? theme.colorScheme.primary;
    final bgColor =
        widget.backgroundColor ?? indicatorColor.withValues(alpha: 0.1);

    return Semantics(
      label: 'Liquid loading indicator',
      value: 'busy',
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _LiquidPainter(
                value: widget.value,
                animation: _controller.value,
                color: indicatorColor,
                backgroundColor: bgColor,
                gradient: widget.gradient,
                waveAmplitude: widget.waveAmplitude,
                waveFrequency: widget.waveFrequency,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final double? value;
  final double animation;
  final Color color;
  final Color backgroundColor;
  final Gradient? gradient;
  final double waveAmplitude;
  final double waveFrequency;

  _LiquidPainter({
    required this.value,
    required this.animation,
    required this.color,
    required this.backgroundColor,
    this.gradient,
    required this.waveAmplitude,
    required this.waveFrequency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min(size.width, size.height) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    canvas.clipPath(Path()..addOval(rect));

    final double level = 1.0 - (value ?? 0.5);
    final double waterHeight = size.height * level;

    final Path wavePath = Path();
    final double phase = animation * 2 * math.pi;

    wavePath.moveTo(0, waterHeight);

    for (double x = 0; x <= size.width; x++) {
      final double y =
          waterHeight +
          waveAmplitude *
              math.sin((x / size.width * waveFrequency * 2 * math.pi) + phase);
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (gradient != null) {
      paint.shader = gradient!.createShader(rect);
    }

    canvas.drawPath(wavePath, paint);

    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.waveAmplitude != waveAmplitude ||
        oldDelegate.waveFrequency != waveFrequency;
  }
}
