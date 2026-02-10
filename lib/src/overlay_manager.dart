import 'dart:async';
import 'package:flutter/material.dart';
import 'overlay_widget.dart';


class SmartOverlayManager {
  static final SmartOverlayManager _instance = SmartOverlayManager._internal();
  factory SmartOverlayManager() => _instance;
  SmartOverlayManager._internal();

  OverlayEntry? _entry;
  Timer? _timer;

 
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

    final duration = options.autoDismissDuration ?? const Duration(seconds: 5);
    _timer = Timer(duration, () {
      hide();
    });
  }

  void hide() {
    _timer?.cancel();
    _timer = null;

    _entry?.remove();
    _entry = null;
  }
}
