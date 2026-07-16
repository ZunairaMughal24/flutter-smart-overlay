import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A progress indicator depicting one or more dots orbiting a central
/// track, each trailing a fading comet-like tail (or optional sparkles).
class OrbitProgressIndicator extends StatefulWidget {
  /// The width and height of the indicator's bounding box.
  final double size;

  /// The color of the orbiting dots. Defaults to the theme's primary color.
  final Color? color;

  /// The color of the static orbit track and dot trails. Defaults to
  /// [color] at reduced opacity.
  final Color? secondaryColor;

  /// An optional gradient applied to the orbiting dots, overriding [color]
  /// as a flat fill.
  final Gradient? gradient;

  /// The number of dots orbiting the track, each staggered evenly apart.
  final int dotCount;

  /// The radius of each orbiting dot.
  final double dotSize;

  /// How long a single dot takes to complete one full orbit.
  final Duration speed;

  /// Whether to render a trail of fading sparkles behind each dot instead
  /// of the default solid comet trail.
  final bool showSparkle;

  /// The number of sparkles drawn per dot when [showSparkle] is `true`.
  final int sparkleCount;

  /// The color of the sparkle trail. Defaults to [color].
  final Color? sparkleColor;

  /// The easing curve applied to each dot's orbital motion.
  final Curve curve;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates an [OrbitProgressIndicator].
  const OrbitProgressIndicator({
    super.key,
    this.size = 60.0,
    this.color,
    this.secondaryColor,
    this.gradient,
    this.dotCount = 2,
    this.dotSize = 6.0,
    this.speed = const Duration(milliseconds: 1800),
    this.showSparkle = false,
    this.sparkleCount = 12,
    this.sparkleColor,
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  @override
  State<OrbitProgressIndicator> createState() => _OrbitProgressIndicatorState();
}

class _OrbitProgressIndicatorState extends State<OrbitProgressIndicator>
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
  void didUpdateWidget(covariant OrbitProgressIndicator oldWidget) {
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
    final trailColor =
        widget.secondaryColor ?? baseColor.withValues(alpha: 0.3);

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
              painter: _OrbitPainter(
                animation: animatedValue,
                color: baseColor,
                trailColor: trailColor,
                gradient: widget.gradient,
                dotCount: widget.dotCount,
                dotSize: widget.dotSize,
                showSparkle: widget.showSparkle,
                sparkleCount: widget.sparkleCount,
                sparkleColor: widget.sparkleColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Color trailColor;
  final Gradient? gradient;
  final int dotCount;
  final double dotSize;
  final bool showSparkle;
  final int sparkleCount;
  final Color? sparkleColor;

  _OrbitPainter({
    required this.animation,
    required this.color,
    required this.trailColor,
    this.gradient,
    required this.dotCount,
    required this.dotSize,
    required this.showSparkle,
    required this.sparkleCount,
    this.sparkleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double orbitRadius =
        (math.min(size.width, size.height) - dotSize) / 2;

    final trackPaint = Paint()
      ..color = trailColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    canvas.drawCircle(center, orbitRadius, trackPaint);

    for (int i = 0; i < dotCount; i++) {
      final double stagger = i / dotCount;

      double t = (animation + stagger) % 1.0;

      final double easeStrength = 1.0 + (i * 0.6);
      final double easedT = _asymmetricEase(t, easeStrength);

      final double angle = easedT * 2 * math.pi - (math.pi / 2);

      final Offset dotCenter = Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      );

      final double scaleFactor = 1.0 - (i * 0.15).clamp(0.0, 0.5);
      final double currentDotSize = dotSize * scaleFactor;

      final double opacity = (1.0 - (i * 0.2)).clamp(0.3, 1.0);

      final dotPaint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      if (gradient != null) {
        dotPaint.shader = gradient!.createShader(
          Rect.fromCircle(center: dotCenter, radius: currentDotSize),
        );
      }

      if (showSparkle) {
        _drawSparkleTrail(canvas, center, orbitRadius, animation, stagger, i);
      }

      canvas.drawCircle(dotCenter, currentDotSize, dotPaint);

      if (i == 0) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

        canvas.drawCircle(dotCenter, currentDotSize * 1.8, glowPaint);
      }

      if (!showSparkle) {
        _drawTrail(
          canvas,
          center,
          orbitRadius,
          angle,
          dotPaint,
          currentDotSize,
        );
      }
    }
  }

  double _asymmetricEase(double t, double strength) {
    return (math.sin(t * math.pi - math.pi / 2) + 1) / 2 * (1 - 1 / strength) +
        t / strength;
  }

  void _drawTrail(
    Canvas canvas,
    Offset center,
    double radius,
    double headAngle,
    Paint basePaint,
    double size,
  ) {
    const int trailSegments = 8;
    const double trailArc = math.pi / 4;

    for (int s = 1; s <= trailSegments; s++) {
      final double frac = s / trailSegments;
      final double trailAngle = headAngle - (trailArc * frac);

      final Offset pos = Offset(
        center.dx + radius * math.cos(trailAngle),
        center.dy + radius * math.sin(trailAngle),
      );

      final double trailOpacity = (0.2 * (1.0 - frac)).clamp(0.0, 1.0);
      final double trailSize = size * (1.0 - frac * 0.7);

      final trailPaint = Paint()
        ..color = color.withValues(alpha: trailOpacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, trailSize, trailPaint);
    }
  }

  void _drawSparkleTrail(
    Canvas canvas,
    Offset center,
    double radius,
    double animation,
    double stagger,
    int dotIndex,
  ) {
    final sparklePaint = Paint()..style = PaintingStyle.fill;
    final math.Random random = math.Random(dotIndex);

    for (int i = 0; i < sparkleCount; i++) {
      final double sparkleProgress =
          (animation + stagger - (i / sparkleCount) * 0.15) % 1.0;
      final double t = _asymmetricEase(sparkleProgress, 1.0 + (dotIndex * 0.6));
      final double angle = t * 2 * math.pi - (math.pi / 2);

      final double opacity =
          (1.0 - (i / sparkleCount)) * (1.0 - (dotIndex * 0.3));

      final double baseSparkleSize = dotSize * 0.45;
      final double sparkleSize =
          (baseSparkleSize - (i / sparkleCount) * (baseSparkleSize * 0.7))
              .clamp(0.5, baseSparkleSize);

      final Offset sparklePos =
          center + Offset(radius * math.cos(angle), radius * math.sin(angle));

      final double jitterRange = (i / sparkleCount) * (dotSize * 0.5);
      final double jitterX = (random.nextDouble() - 0.5) * jitterRange;
      final double jitterY = (random.nextDouble() - 0.5) * jitterRange;

      final baseSparkleColor = sparkleColor ?? color;
      sparklePaint.color = baseSparkleColor.withValues(
        alpha: opacity.clamp(0.0, 1.0) * 0.5,
      );
      canvas.drawCircle(
        sparklePos + Offset(jitterX, jitterY),
        sparkleSize,
        sparklePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.showSparkle != showSparkle ||
        oldDelegate.sparkleColor != sparkleColor;
  }
}
