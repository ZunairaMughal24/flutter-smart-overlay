import 'dart:ui';
import 'package:flutter/material.dart';
import 'fluxwave_progress.dart';

/// The visual layout an overlay is rendered with.
enum SmartOverlayType {
  /// A full-screen, centered loading indicator with an optional message.
  loader,

  /// A compact, card-style toast with an icon (or indicator) beside a
  /// message.
  custom,
}

/// Configuration for a single [SmartOverlayWidget] instance, controlling
/// its colors, content, and behavior.
class OverlayOptions {
  /// The background scrim color behind the overlay content. Defaults to
  /// a semi-transparent black (for [SmartOverlayType.loader]) or white
  /// (for [SmartOverlayType.custom]).
  final Color? backgroundColor;

  /// The background color of the card used by [SmartOverlayType.custom].
  /// Defaults to white.
  final Color? boxColor;

  /// The color of the [message] text. Defaults to white for the loader
  /// style and black87 for the custom card style.
  final Color? textColor;

  /// The color of the default indicator's icon/stroke when no [indicator]
  /// is supplied.
  final Color? iconColor;

  /// A simple text message shown alongside the indicator. Ignored if
  /// [messageWidget] is supplied.
  final String? message;

  /// A custom widget shown in place of the default indicator for
  /// [SmartOverlayType.custom] overlays.
  final Widget? customWidget;

  /// If set, the overlay automatically hides itself after this duration.
  /// If `null`, the overlay stays visible until [SmartOverlayManager.hide]
  /// is called.
  final Duration? autoDismissDuration;

  /// The number of waves rendered by the default [FluxWaveProgressIndicator]
  /// when no [indicator] is supplied.
  final int? waveCount;

  /// An optional gradient applied to the default indicator.
  final Gradient? gradient;

  /// Whether to apply a background blur (glassmorphism) behind
  /// [SmartOverlayType.loader] overlays.
  final bool useBlur;

  /// A custom widget shown in place of the default progress indicator.
  final Widget? indicator;

  /// A custom widget shown in place of the simple text [message].
  final Widget? messageWidget;

  /// Creates an [OverlayOptions] configuration.
  const OverlayOptions({
    this.backgroundColor,
    this.boxColor,
    this.textColor,
    this.iconColor,
    this.message,
    this.customWidget,
    this.autoDismissDuration,
    this.waveCount,
    this.gradient,
    this.useBlur = false,
    this.indicator,
    this.messageWidget,
  });
}

/// The widget inserted into the [Overlay] by [SmartOverlayManager] to
/// render a loader or custom toast, based on [type] and [options].
///
/// This is typically not constructed directly; use [SmartOverlay.show] or
/// the [BuildContext] extensions instead.
class SmartOverlayWidget extends StatefulWidget {
  /// The visual layout to render.
  final SmartOverlayType type;

  /// The colors, content, and behavior configuration for this overlay.
  final OverlayOptions options;

  /// Creates a [SmartOverlayWidget].
  const SmartOverlayWidget({
    super.key,
    required this.type,
    required this.options,
  });

  @override
  State<SmartOverlayWidget> createState() => _SmartOverlayWidgetState();
}

class _SmartOverlayWidgetState extends State<SmartOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoader = widget.type == SmartOverlayType.loader;

    final Widget body = Container(
      color:
          widget.options.backgroundColor ??
          (isLoader
              ? Colors.black.withAlpha(200)
              : Colors.white.withAlpha(200)),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: isLoader
                ? _buildLoaderContent()
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    decoration: BoxDecoration(
                      color: widget.options.boxColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.withAlpha(50)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIconOrLoader(),
                        if (widget.options.messageWidget != null ||
                            widget.options.message != null) ...[
                          const SizedBox(width: 16),
                          Flexible(
                            child:
                                widget.options.messageWidget ??
                                Text(
                                  widget.options.message!,
                                  textAlign: TextAlign.left,
                                  style:
                                      (Theme.of(
                                        context,
                                      ).textTheme.titleMedium ??
                                      const TextStyle()).copyWith(
                                        color:
                                            widget.options.textColor ??
                                            Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );

    if (isLoader && widget.options.useBlur) {
      return Material(
        color: Colors.transparent,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: body,
          ),
        ),
      );
    }

    return Material(color: Colors.transparent, child: body);
  }

  Widget _buildLoaderContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.options.indicator ??
            FluxWaveProgressIndicator(
              color: widget.options.iconColor ?? Colors.white,
              size: 90,
              strokeWidth: 4,
              waveCount: widget.options.waveCount ?? 14,
              gradient: widget.options.gradient,
            ),
        if (widget.options.messageWidget != null ||
            widget.options.message != null) ...[
          const SizedBox(height: 24),
          widget.options.messageWidget ??
              Text(
                widget.options.message!,
                textAlign: TextAlign.center,
                style: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle())
                    .copyWith(
                      color: widget.options.textColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
              ),
        ],
      ],
    );
  }

  Widget _buildIconOrLoader() {
    if (widget.options.customWidget != null) {
      return widget.options.customWidget!;
    }

    return widget.options.indicator ??
        FluxWaveProgressIndicator(
          color: widget.options.iconColor ?? Colors.blue,
          size: 50,
          strokeWidth: 2,
          gradient: widget.options.gradient,
        );
  }
}
