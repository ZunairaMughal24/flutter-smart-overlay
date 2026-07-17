import 'dart:async';
import 'package:flutter/material.dart';
import 'overlay_widget.dart';

/// A singleton manager that handles [OverlayEntry] insertion and removal.
class SmartOverlayManager {
  static final SmartOverlayManager _instance = SmartOverlayManager._internal();

  /// Returns the singleton [SmartOverlayManager] instance.
  factory SmartOverlayManager() => _instance;
  SmartOverlayManager._internal();

  OverlayEntry? _entry;
  Timer? _timer;

  /// Displays the overlay. Automatically hides any existing overlay first.
  void show({
    required BuildContext context,
    required SmartOverlayType type,
    required OverlayOptions options,
  }) {
    hide();

    _entry = OverlayEntry(
      builder: (context) => SmartOverlayWidget(type: type, options: options),
    );

    Overlay.of(context).insert(_entry!);

    if (options.autoDismissDuration != null) {
      _timer = Timer(options.autoDismissDuration!, () {
        hide();
      });
    }
  }

  /// Hides and disposes the currently active overlay, if any.
  void hide() {
    _timer?.cancel();
    _timer = null;

    _entry?.remove();
    _entry = null;
  }
}
