import 'package:flutter/material.dart';
import 'overlay_widget.dart';
import 'smart_overlay.dart';

/// Extensions on [BuildContext] for quick overlay management.
extension SmartOverlayExtension on BuildContext {
  /// Shows a loader overlay.
  void showLoader({
    String? message,
    OverlayOptions? options,
    Widget? indicator,
    Duration? autoDismissDuration,
    bool useBlur = false,
    Gradient? gradient,
    Color? backgroundColor,
    Color? textColor,
    Widget? messageWidget,
  }) {
    SmartOverlay.show(
      context: this,
      message: message,
      options: options,
      indicator: indicator,
      autoDismissDuration: autoDismissDuration,
      useBlur: useBlur,
      gradient: gradient,
      backgroundColor: backgroundColor,
      textColor: textColor,
      messageWidget: messageWidget,
    );
  }

  void hideOverlay() {
    SmartOverlay.hide();
  }
}
