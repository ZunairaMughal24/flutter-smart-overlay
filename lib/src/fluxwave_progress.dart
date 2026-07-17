import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A premium wavy progress indicator that animates a path between synchronized waves.
class FluxWaveProgressIndicator extends StatefulWidget {
  /// The determinate progress from `0.0` to `1.0`. If `null`, the indicator
  /// sweeps indeterminately instead of tracking a fixed value.
  final double? value;

  /// The thickness of the wave stroke.
  final double strokeWidth;

  /// The color of the wave stroke. Defaults to the theme's primary color.
  final Color? color;

  /// The color of the static background track. Defaults to [color] at low
  /// opacity.
  final Color? backgroundColor;

  /// The number of scallops (waves) around the ring.
  final int waveCount;

  /// The width and height of the indicator's bounding box.
  final double size;

  /// An optional gradient applied to the progress stroke, overriding
  /// [color] as a flat stroke.
  final Gradient? gradient;

  /// How long it takes for the wave pattern to complete one full rotation.
  final Duration speed;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates a [FluxWaveProgressIndicator].
  const FluxWaveProgressIndicator({
    super.key,
    this.value,
    this.strokeWidth = 1,
    this.color,
    this.backgroundColor,
    this.waveCount = 8,
    this.size = 48.0,
    this.gradient,
    this.speed = const Duration(seconds: 3),
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  /// The easing curve applied to the wave rotation.
  final Curve curve;

  @override
  State<FluxWaveProgressIndicator> createState() =>
      _FluxWaveProgressIndicatorState();
}

class _FluxWaveProgressIndicatorState extends State<FluxWaveProgressIndicator>
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
  void didUpdateWidget(covariant FluxWaveProgressIndicator oldWidget) {
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

    final trackColor =
        widget.backgroundColor ?? indicatorColor.withValues(alpha: 0.15);

    return Semantics(
      label: 'Loading indicator',
      value: 'busy',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double animatedValue = widget.curve.transform(
            _controller.value,
          );
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _FluxWavePainter(
                value: widget.value,
                rotation: animatedValue,
                strokeWidth: widget.strokeWidth,
                color: indicatorColor,
                backgroundColor: trackColor,
                waveCount: widget.waveCount,
                gradient: widget.gradient,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FluxWavePainter extends CustomPainter {
  final double? value;
  final double rotation;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;
  final int waveCount;
  final Gradient? gradient;

  _FluxWavePainter({
    required this.value,
    required this.rotation,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
    required this.waveCount,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final double amplitude = strokeWidth * 0.30;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 2 * math.pi);
    canvas.translate(-center.dx, -center.dy);

    final Path path = _createSmoothScallopedPath(center, radius, amplitude);

    final paintBase = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paintBase..color = backgroundColor);

    final progressPaint = paintBase..color = color;

    if (gradient != null) {
      progressPaint.shader = gradient!.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    }

    if (value != null) {
      _drawPartialPath(
        canvas,
        path,
        0.0,
        value!.clamp(0.0, 1.0),
        progressPaint,
      );
    } else {
      final start = (rotation * 2.0) % 1.0;
      final sweep = 0.2 + (math.sin(rotation * math.pi) * 0.1).abs();
      _drawPartialPath(canvas, path, start, sweep, progressPaint);
    }

    canvas.restore();
  }

  Path _createSmoothScallopedPath(
    Offset center,
    double radius,
    double amplitude,
  ) {
    final path = Path();
    final double innerRadius = radius - amplitude;
    final double outerRadius = radius + amplitude;

    final int totalPoints = waveCount * 2;
    final double angleStep = (2 * math.pi) / totalPoints;

    path.moveTo(
      center.dx + outerRadius * math.cos(0),
      center.dy + outerRadius * math.sin(0),
    );

    for (int i = 0; i < totalPoints; i++) {
      final double nextAngle = (i + 1) * angleStep;
      final double nextRadius = (i % 2 == 0) ? innerRadius : outerRadius;

      final double targetX = center.dx + nextRadius * math.cos(nextAngle);
      final double targetY = center.dy + nextRadius * math.sin(nextAngle);

      final double midAngle = nextAngle - (angleStep / 2);
      final double midRadius = (i % 2 == 0) ? outerRadius : innerRadius;

      final double ctrlX = center.dx + midRadius * math.cos(midAngle);
      final double ctrlY = center.dy + midRadius * math.sin(midAngle);

      path.quadraticBezierTo(ctrlX, ctrlY, targetX, targetY);
    }

    path.close();
    return path;
  }

  void _drawPartialPath(
    Canvas canvas,
    Path path,
    double start,
    double sweep,
    Paint paint,
  ) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      final double len = metric.length;
      final double startPx = start * len;
      final double sweepPx = sweep * len;

      if (startPx + sweepPx <= len) {
        canvas.drawPath(metric.extractPath(startPx, startPx + sweepPx), paint);
      } else {
        canvas.drawPath(metric.extractPath(startPx, len), paint);
        canvas.drawPath(
          metric.extractPath(0.0, (startPx + sweepPx) % len),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FluxWavePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.rotation != rotation;
  }
}
