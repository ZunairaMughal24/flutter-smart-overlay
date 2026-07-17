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

  /// Shows a compact, card-style toast. See [SmartOverlay.showCustom].
  void showCustom({
    String? message,
    OverlayOptions? options,
    Widget? messageWidget,
    Widget? customWidget,
    Widget? indicator,
    Color? backgroundColor,
    Color? boxColor,
    Color? textColor,
    Color? iconColor,
    Gradient? gradient,
    Duration? autoDismissDuration,
  }) {
    SmartOverlay.showCustom(
      context: this,
      message: message,
      options: options,
      messageWidget: messageWidget,
      customWidget: customWidget,
      indicator: indicator,
      backgroundColor: backgroundColor,
      boxColor: boxColor,
      textColor: textColor,
      iconColor: iconColor,
      gradient: gradient,
      autoDismissDuration: autoDismissDuration,
    );
  }

  void hideOverlay() {
    SmartOverlay.hide();
  }
}
