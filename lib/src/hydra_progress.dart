import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A liquid-fill progress indicator: a circular container with an animated
/// wavy surface, like a water level rising and falling inside a glass.
class HydraProgressIndicator extends StatefulWidget {
  /// The fill level from `0.0` (empty) to `1.0` (full). If `null`, the
  /// indicator renders at a fixed half-full level to suggest indeterminate
  /// progress.
  final double? value;

  /// The width and height of the indicator's bounding box.
  final double size;

  /// The color of the liquid fill. Defaults to the theme's primary color.
  final Color? color;

  /// The color of the empty (unfilled) portion of the circle. Defaults to
  /// [color] at low opacity.
  final Color? backgroundColor;

  /// An optional gradient applied to the liquid fill, overriding [color]
  /// as a flat fill.
  final Gradient? gradient;

  /// The height, in logical pixels, of the animated wave crests.
  final double waveAmplitude;

  /// The number of wave crests visible across the width of the indicator.
  final double waveFrequency;

  /// How long it takes for the wave surface to complete one animation
  /// cycle.
  final Duration speed;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates a [HydraProgressIndicator].
  const HydraProgressIndicator({
    super.key,
    this.value,
    this.size = 60.0,
    this.color,
    this.backgroundColor,
    this.gradient,
    this.waveAmplitude = 4.0,
    this.waveFrequency = 1.0,
    this.speed = const Duration(seconds: 2),
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  final Curve curve;

  @override
  State<HydraProgressIndicator> createState() => _HydraProgressIndicatorState();
}

class _HydraProgressIndicatorState extends State<HydraProgressIndicator>
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
  void didUpdateWidget(covariant HydraProgressIndicator oldWidget) {
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
            final double animatedValue = widget.curve.transform(
              _controller.value,
            );
            return CustomPaint(
              painter: _HydraPainter(
                value: widget.value,
                animation: animatedValue,
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

class _HydraPainter extends CustomPainter {
  final double? value;
  final double animation;
  final Color color;
  final Color backgroundColor;
  final Gradient? gradient;
  final double waveAmplitude;
  final double waveFrequency;

  _HydraPainter({
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
  bool shouldRepaint(covariant _HydraPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.waveAmplitude != waveAmplitude ||
        oldDelegate.waveFrequency != waveFrequency;
  }
}
