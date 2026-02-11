import 'package:flutter/material.dart';
import 'overlay_manager.dart';
import 'overlay_widget.dart';

/// This class provides static methods to show and hide overlays.

class SmartOverlay {
  /// Shows a loader overlay with the specified [context].

  /// The [message] or [messageWidget] provides the feedback content.
  /// [indicator] allows for a custom progress widget.
  /// [autoDismissDuration] makes the overlay temporary.
  /// [useBlur] toggles glassmorphism.
  static void show({
    required BuildContext context,
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
    SmartOverlayManager().show(
      context: context,
      type: SmartOverlayType.loader,
      options:
          options ??
          OverlayOptions(
            message: message,
            indicator: indicator,
            autoDismissDuration: autoDismissDuration,
            useBlur: useBlur,
            gradient: gradient,
            backgroundColor: backgroundColor,
            textColor: textColor,
            messageWidget: messageWidget,
          ),
    );
  }

  /// Hides the currently active overlay.
  static void hide() {
    SmartOverlayManager().hide();
  }
}
