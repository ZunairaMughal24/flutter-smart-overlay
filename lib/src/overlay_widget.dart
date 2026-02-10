import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scalloped_progress.dart';

enum SmartOverlayType { loader, custom }

class OverlayOptions {
  final Color? backgroundColor;
  final Color? boxColor;
  final Color? textColor;
  final Color? iconColor;
  final String? message;
  final Widget? customWidget;
  final Duration? autoDismissDuration;
  final int? waveCount;
  final Gradient? gradient;
  final bool useBlur;

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
  });
}

class SmartOverlayWidget extends StatefulWidget {
  final SmartOverlayType type;
  final OverlayOptions options;

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
              ? Colors.black.withAlpha(200) // Darker background
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
                        if (widget.options.message != null) ...[
                          const SizedBox(width: 16),
                          Flexible(
                            child: Text(
                              widget.options.message!,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.nunito(
                                color:
                                    widget.options.textColor ?? Colors.black87,
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
        ScallopedProgressIndicator(
          color: widget.options.iconColor ?? Colors.white,
          size: 90,
          strokeWidth: 4,
          waveCount: widget.options.waveCount ?? 14,
          gradient: widget.options.gradient,
        ),
        if (widget.options.message != null) ...[
          const SizedBox(height: 24),
          Text(
            widget.options.message!,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
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

    return ScallopedProgressIndicator(
      color: widget.options.iconColor ?? Colors.blue,
      size: 50,
      strokeWidth: 2,
      gradient: widget.options.gradient,
    );
  }
}
