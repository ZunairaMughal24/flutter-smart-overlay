# CHANGELOG

## 0.1.0

* **New: `SmartOverlay.showCustom()`**: The compact, card-style toast (`SmartOverlayType.custom`) was previously unreachable through the public API — `SmartOverlay.show()` always hardcoded `type: SmartOverlayType.loader`, leaving `boxColor`, `iconColor`, and `customWidget` on `OverlayOptions` dead. `showCustom()` (and the matching `context.showCustom()` extension) now exposes this style properly.
* **Animation Control**: Added `isAnimating` to every indicator — set it to `false` to freeze the indicator at its current frame from outside (e.g. once an async task completes), without unmounting the widget.
* **Consistent Speed API**: `FluxWaveProgressIndicator` and `HydraProgressIndicator` now expose a `speed` parameter (previously hardcoded). `LuminaProgressIndicator`'s `duration` parameter is renamed to `speed` to match the other 8 indicators. **Breaking:** update any `LuminaProgressIndicator(duration: ...)` usage to `speed: ...`.
* **No more forced font**: Removed the `google_fonts` dependency. Overlay message text now inherits `Theme.of(context).textTheme` instead of a hardcoded font, so it matches your app's existing typography.
* **Documentation**: Added dartdoc comments to all public indicator classes and fields.

## 0.0.1

* Initial release of `smart_overlay`.
* **Named API**: Introduced the `SmartOverlay` class for branded, static method access (`SmartOverlay.show`).
* **Hybrid Messages**: Professional pattern supporting both `String` and `Widget` feedback.
* **Indicator Physics**: Added granular control over `dotSize`, `radius`, and `dotCount`.
* **Professional UI**: Overhauled example app with a screenshot-ready theme.
* **Fancy Indicators**: Introduced a high-end **Cosmic & Elemental** theme: `FluxWave`, `Lumina`, `Hydra`, `Aura`, `Nova`, `Orbit`, `Eclipse`, `Nexus`, `Zenith`, and `Vortex`.
* **Accessibility**: Added `Semantics` support to all progress indicators.
* **Glassmorphism**: Support for background blur and custom dark overlays.
* **Micro-animations**: Smooth transitions for a premium UX.
