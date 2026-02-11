# CHANGELOG

## 0.2.0

* **Named API**: Introduced the `SmartOverlay` class for branded, static method access (`SmartOverlay.show`).
* **Hybrid Messages**: Implemented a professional pattern supporting both `String` and `Widget` feedback.
* **Indicator Physics**: Added granular control over `dotSize`, `radius` (spread), and `dotCount` for Fading Dots.
* **UI Refresh**: Overhauled the example app with a screenshot-ready professional theme and technical guide.

## 0.1.0

* **Feature**: Added `FadingDotsProgressIndicator` for a professional, pulse-style loading experience.
* **Architecture**: Refactored to a **Widget Injection** pattern, allowing any custom widget as an indicator.
* **Accessibility**: Added `Semantics` support to all progress indicators.
* **UX**: Made `autoDismissDuration` optional for loaders (set it to hide automatically, or keep it sticky).
* **Enhancement**: Improved gradient rendering with opacity modulation.
* **Example**: Added a standalone UI demo showcasing indicators in profile/sync cards.

## 0.0.1

* Initial release of `smart_overlay`.
* Introduced `ScallopedProgressIndicator` with gradient support.
* Unified `showLoader` extension for easy overlay management.
* Support for background blur (glassmorphism) and custom dark overlays.
* Micro-animations for professional transition effects.
* Flexible `OverlayOptions` for fine-grained control.
