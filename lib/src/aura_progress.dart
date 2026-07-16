import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A progress indicator that emits pulsing concentric ripples from a
/// central dot, similar to a sonar or radar sweep.
class AuraProgressIndicator extends StatefulWidget {
  /// The width and height of the indicator's bounding box.
  final double size;

  /// The color of the ripples and center dot. Defaults to the theme's
  /// primary color.
  final Color? color;

  /// An optional gradient applied to the ripples and center dot, overriding
  /// [color] as a flat fill.
  final Gradient? gradient;

  /// The number of ripples animating outward at once.
  final int rippleCount;

  /// Reserved for future stroke-based rendering; currently unused since
  /// ripples are filled rather than stroked.
  final double strokeWidth;

  /// How long a single ripple takes to travel from the center to the edge.
  final Duration speed;

  /// Whether to render the pulsing dot at the center of the indicator.
  final bool showCenter;

  /// Whether the animation is running. Set to `false` to freeze the
  /// indicator at its current frame — for example, once your async
  /// operation completes. Defaults to `true`.
  final bool isAnimating;

  /// Creates an [AuraProgressIndicator].
  const AuraProgressIndicator({
    super.key,
    this.size = 60.0,
    this.color,
    this.gradient,
    this.rippleCount = 3,
    this.strokeWidth = 2.0,
    this.speed = const Duration(milliseconds: 2400),
    this.showCenter = true,
    this.isAnimating = true,
    this.curve = Curves.linear,
  });

  final Curve curve;

  @override
  State<AuraProgressIndicator> createState() => _AuraProgressIndicatorState();
}

class _AuraProgressIndicatorState extends State<AuraProgressIndicator>
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
  void didUpdateWidget(covariant AuraProgressIndicator oldWidget) {
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
              painter: _AuraPainter(
                animation: animatedValue,
                color: baseColor,
                gradient: widget.gradient,
                rippleCount: widget.rippleCount,
                strokeWidth: widget.strokeWidth,
                showCenter: widget.showCenter,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuraPainter extends CustomPainter {
  final double animation;
  final Color color;
  final Gradient? gradient;
  final int rippleCount;
  final double strokeWidth;
  final bool showCenter;

  _AuraPainter({
    required this.animation,
    required this.color,
    this.gradient,
    required this.rippleCount,
    required this.strokeWidth,
    required this.showCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = math.min(size.width, size.height) / 2;

    if (showCenter) {
      final double pulse = 0.5 + 0.5 * math.sin(animation * 2 * math.pi);
      final double dotRadius = maxRadius * 0.08 + maxRadius * 0.06 * pulse;
      final double dotOpacity = (0.6 + 0.4 * pulse).clamp(0.0, 1.0);

      final dotPaint = Paint()
        ..color = color.withValues(alpha: dotOpacity)
        ..style = PaintingStyle.fill;

      if (gradient != null) {
        dotPaint.shader = gradient!.createShader(
          Rect.fromCircle(center: center, radius: dotRadius),
        );
      }

      canvas.drawCircle(center, dotRadius, dotPaint);
    }

    for (int i = 0; i < rippleCount; i++) {
      final double stagger = i / rippleCount;
      double progress = (animation + stagger) % 1.0;

      final double easedProgress = 1.0 - math.pow(1.0 - progress, 2.5);

      final double radius = maxRadius * 0.12 + maxRadius * 0.88 * easedProgress;

      final double opacity = (0.45 * (1.0 - easedProgress)).clamp(0.0, 1.0);

      final fillPaint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      if (gradient != null) {
        fillPaint.shader = gradient!.createShader(
          Rect.fromCircle(center: center, radius: radius),
        );
        fillPaint.color = color.withValues(alpha: opacity);
      }

      canvas.drawCircle(center, radius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuraPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.rippleCount != rippleCount ||
        oldDelegate.showCenter != showCenter;
  }
}
