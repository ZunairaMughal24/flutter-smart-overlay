import 'package:flutter/material.dart';
import 'overlay_manager.dart';
import 'overlay_widget.dart';

extension SmartOverlayExtension on BuildContext {
  void showLoader({String? message, OverlayOptions? options}) {
    SmartOverlayManager().show(
      context: this,
      type: SmartOverlayType.loader,
      options: options ?? OverlayOptions(message: message),
    );
  }

  void hideOverlay() {
    SmartOverlayManager().hide();
  }
}
