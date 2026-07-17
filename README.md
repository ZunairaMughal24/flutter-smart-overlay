# smart_overlay 🌊

<p align="center">
  <a href="https://pub.dev/packages/smart_overlay"><img src="https://img.shields.io/pub/v/smart_overlay.svg" alt="Pub Version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
</p>

A **premium, lightweight loading overlay manager** for Flutter. Featuring the unique **FluxWave (Wavy) Progress Indicator** with full gradient support.

---

## ✨ Features

- **10 Unique Indicators**: `FluxWave`, `Lumina`, `Hydra`, `Aura`, `Nova`, `Orbit`, `Eclipse`, `Nexus`, `Zenith`, and `Vortex` — no other loading package has this much visual variety in one place.
- **Full Animation Control**: Every indicator supports `isAnimating` (stop/resume from any condition — a switch, a timer, or a real async result) and `speed` (how fast it loops), independent of each other.
- **Determinate or Indeterminate**: `FluxWave` and `Hydra` accept a real `value: 0.0–1.0` for actual upload/download progress, not just endless spinning.
- **Two Overlay Styles**: `SmartOverlay.show()` for a full-screen block, `SmartOverlay.showCustom()` for a lightweight, non-blocking toast card.
- **Custom Indicators**: Inject any custom widget as your progress indicator or toast icon.
- **Built-in Accessibility**: All loaders come with `Semantics` support out of the box.
- **Gradients Galore**: Apply beautiful gradients to your loaders for a high-end feel.
- **Glassmorphism**: Optional background blur (`useBlur`) for the full-screen loader.
- **Respects Your App's Theme**: No forced fonts — overlay text uses your app's existing `TextTheme` automatically.
- **Simple API**: Easy-to-use `SmartOverlay` static methods or `BuildContext` extensions.
- **Hybrid Messages**: Use simple `String` messages or complex `Widget` message builders.

---

## 🎬 Gallery

<p align="center">
  <img src="https://raw.githubusercontent.com/ZunairaMughal24/flutter-smart-overlay/main/assets/gif1.gif" width="200px" alt="Full-screen loading overlay and compact toast notification">
  <img src="https://raw.githubusercontent.com/ZunairaMughal24/flutter-smart-overlay/main/assets/gif2.gif" width="200px" alt="All 10 indicator styles">
  <img src="https://raw.githubusercontent.com/ZunairaMughal24/flutter-smart-overlay/main/assets/gif3.gif" width="200px" alt="Live animation control - start, stop, and adjust speed">
  <img src="https://raw.githubusercontent.com/ZunairaMughal24/flutter-smart-overlay/main/assets/gif4.gif" width="200px" alt="Customization playground for every indicator">
</p>

---

## 🚀 Quick Start

### 1. Installation
Add `smart_overlay` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_overlay: ^0.1.0
```

### 2. Basic Usage
Show a simple full-screen loader using the named API (Professional) or extensions (Convenient):

```dart
// Named API
SmartOverlay.show(context: context, message: "Setting things up...");

// Access via context
context.showLoader(message: "Setting things up...");

// To hide
SmartOverlay.hide(); // Or context.hideOverlay();
```

### 3. Premium Gradient Style
Bring your UI to life with gradients and blur:

```dart
SmartOverlay.show(
  context: context,
  message: "Syncing your data...",
  useBlur: true,
  backgroundColor: Colors.indigo.withValues(alpha: 0.4),
  gradient: LinearGradient(
    colors: [Colors.purple, Colors.blueAccent],
  ),
);
```

### 4. Hybrid Messages (Advanced)
Inject complex widgets or rich text as your loading message:

```dart
SmartOverlay.show(
  context: context,
  messageWidget: Column(
    children: [
      Text("AI Syncing", style: TextStyle(fontWeight: FontWeight.bold)),
      Text("Analyzing patterns...", style: TextStyle(fontSize: 12)),
    ],
  ),
);
```

### 5. Custom Indicator Style
Switch to the new professional fading dots or use your own widget:

```dart
context.showLoader(
  message: "Premium experience...",
  indicator: LuminaProgressIndicator(
    size: 80,
    color: Colors.white,
  ),
);
```

### 6. Direct Indicator Usage
All indicators can be used as standalone widgets anywhere in your UI:

```dart
// Standalone Lumina Dots
LuminaProgressIndicator(
  size: 60,
  gradient: SweepGradient(
    colors: [Colors.blue, Colors.cyan],
  ),
)
```

### 7. Controlling Animation (Start / Stop / Speed / Progress)

Every indicator keeps animating **indefinitely** by default — that's not a bug, it's the point of a loading indicator. It stops only when *you* tell it to, via the `isAnimating` parameter. `isAnimating` is a plain `bool`, so it can be driven by absolutely anything: a switch, a timer, or a real condition in your app. `speed` and `value` are separate, independent controls — see the breakdown below.

**a) Driven by a real async result (the common case)**

```dart
bool _isSigningUp = false;

Future<void> _submit() async {
  setState(() => _isSigningUp = true);
  try {
    await signUpApi(email, password);
  } finally {
    if (mounted) setState(() => _isSigningUp = false);
  }
}

// in build():
_isSigningUp
    ? const FluxWaveProgressIndicator(size: 24)
    : ElevatedButton(onPressed: _submit, child: const Text('Sign Up')),
```

Or, for a full-screen block, use `SmartOverlay` directly — it manages the same lifecycle for you, no state variable needed:

```dart
SmartOverlay.show(context: context, message: 'Creating your account...');
await signUpApi(email, password);
SmartOverlay.hide();
```

**b) Driven by a fixed time, not a result**

```dart
bool _isAnimating = true;

Timer(const Duration(seconds: 5), () {
  setState(() => _isAnimating = false); // stops itself after 5 seconds
});

FluxWaveProgressIndicator(isAnimating: _isAnimating)
```

**c) Driven by any condition — including combining several**

```dart
FluxWaveProgressIndicator(
  isAnimating: !(emailVerified && profileComplete && termsAccepted),
)
```

Whatever the expression is, the indicator reacts the moment it changes — there's no special "condition API" beyond passing a `bool`.

**Speed** controls how fast the loop runs — independent of whether it's running at all:

```dart
FluxWaveProgressIndicator(
  isAnimating: _isUploading,
  speed: const Duration(seconds: 2), // faster loop
)
```

### 8. Compact Toast Style
For a lighter-weight, non-blocking confirmation (e.g. "Saved!"), use `showCustom` instead of `show`. It renders a small card with an icon (or your own `customWidget`) beside a message, rather than a full-screen loader:

```dart
SmartOverlay.showCustom(
  context: context,
  message: 'Saved!',
  customWidget: const Icon(Icons.check_circle, color: Colors.green),
  boxColor: Colors.white,
  textColor: Colors.black87,
  autoDismissDuration: const Duration(seconds: 2),
);

// Or via the context extension:
context.showCustom(message: 'Saved!', customWidget: const Icon(Icons.check_circle));
```

---

## 🎛️ Indicator Parameters

Every indicator (`FluxWave`, `Lumina`, `Hydra`, `Aura`, `Nova`, `Orbit`, `Eclipse`, `Nexus`, `Zenith`, `Vortex`) shares this common set of parameters:

| Parameter | Description | Default |
|--------|-------------|---------|
| `size` | Width and height of the indicator's bounding box | Varies per indicator |
| `color` | Primary color. Defaults to the theme's primary color | `null` |
| `gradient` | Overrides `color` with a gradient fill/stroke | `null` |
| `speed` | How long a single animation loop takes — controls how fast it looks, not whether it's running | Varies per indicator |
| `isAnimating` | Whether the loop is running at all. Set to `false` to freeze the indicator at its current frame instead of unmounting it | `true` |
| `curve` | Easing curve applied to the animation | `Curves.linear` |

`FluxWaveProgressIndicator` and `HydraProgressIndicator` additionally accept:

| Parameter | Description |
|--------|-------------|
| `value` | `null` (default) → indeterminate, loops forever. `0.0`–`1.0` → **determinate**: draws a fixed arc/fill for that exact fraction instead of looping. This does not animate on its own — update it yourself as your real progress changes (e.g. from an upload's byte-progress callback). `speed` still applies to the ring's background rotation even in determinate mode. |

Each indicator also has its own visual-specific parameters (`waveCount`, `dotCount`, `rippleCount`, etc.) — see each class's dartdoc for details, or the full reference below. A live, runnable example of all three `isAnimating` patterns above is in [example/lib/widgets/animation_control_demo.dart](example/lib/widgets/animation_control_demo.dart).

---

## 🛠️ Configuration Options

**`SmartOverlay.show()`** — full-screen loader:

| Option | Description | Default |
|--------|-------------|---------|
| `backgroundColor` | Background scrim color behind the overlay | `Colors.black.withAlpha(200)` |
| `textColor` | Color of the message text | `Colors.white` |
| `useBlur` | Enable background glassmorphism blur | `false` |
| `gradient` | Apply a gradient to the progress indicator | `null` |
| `indicator` | Inject a custom indicator widget | `FluxWaveProgressIndicator` |
| `message` | Optional text to display below the loader | `null` |
| `messageWidget` | Inject a custom widget as the message | `null` |
| `autoDismissDuration` | If set, the overlay hides automatically | `null` (sticky) |

**`SmartOverlay.showCustom()`** — compact card toast (accepts `message`, `messageWidget`, `indicator`, `backgroundColor`, `gradient`, and `autoDismissDuration` above, plus):

| Option | Description | Default |
|--------|-------------|---------|
| `boxColor` | Background color of the card itself | `Colors.white` |
| `iconColor` | Color of the default indicator's icon/stroke | `Colors.blue` |
| `customWidget` | Replaces the leading icon/indicator entirely — e.g. a success checkmark | `null` |
| `textColor` | Color of the message text | `Colors.black87` |
| `backgroundColor` | Background scrim behind the card | `Colors.white.withAlpha(200)` |

> **Opacity isn't a separate parameter** — `backgroundColor`, `boxColor`, `textColor`, and `iconColor` are all plain `Color`, and opacity is just the alpha channel of that color. Use `Colors.black.withValues(alpha: 0.6)` for a darker, more solid scrim, `Colors.indigo.withValues(alpha: 0.2)` for a light tint, or `Colors.transparent` for none at all.

Both accept a full `OverlayOptions` object via the `options:` parameter as an escape hatch for anything not listed above.

---

## 📖 Complete Parameter Reference

Every parameter on every indicator, in one place — each block below uses **all** of that indicator's own fields.

**FluxWave** — synchronized scalloped wave path. Supports `value` for real progress.
```dart
FluxWaveProgressIndicator(
  size: 64,
  strokeWidth: 3,
  waveCount: 10,
  color: Colors.cyan,
  backgroundColor: Colors.cyan.withValues(alpha: 0.15),
  gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]),
  speed: const Duration(seconds: 2),
  isAnimating: true,
  curve: Curves.easeInOut,
  value: null, // or 0.0–1.0 for determinate progress
)
```

**Lumina** — dots fading and scaling in sequence around a ring.
```dart
LuminaProgressIndicator(
  size: 60,
  dotCount: 12,
  dotSize: 5,
  radius: 24,
  color: Colors.deepPurple,
  gradient: const SweepGradient(colors: [Colors.purple, Colors.pink]),
  speed: const Duration(milliseconds: 1000),
  isAnimating: true,
  curve: Curves.linear,
)
```

**Hydra** — a liquid fill with an animated wavy surface. Supports `value` for real progress.
```dart
HydraProgressIndicator(
  size: 70,
  value: 0.6, // or null for indeterminate
  waveAmplitude: 5,
  waveFrequency: 2,
  color: Colors.blue,
  backgroundColor: Colors.blue.withValues(alpha: 0.1),
  gradient: const LinearGradient(colors: [Colors.lightBlue, Colors.teal]),
  speed: const Duration(seconds: 2),
  isAnimating: true,
  curve: Curves.linear,
)
```

**Aura** — pulsing concentric ripples from a center dot.
```dart
AuraProgressIndicator(
  size: 65,
  rippleCount: 4,
  showCenter: true,
  color: Colors.teal,
  gradient: const LinearGradient(colors: [Colors.teal, Colors.cyan]),
  speed: const Duration(milliseconds: 2400),
  isAnimating: true,
  curve: Curves.easeOut,
)
```

**Nova** — a pulsing center with expanding rings that briefly bloom into petals.
```dart
NovaProgressIndicator(
  size: 65,
  ringCount: 3,
  strokeWidth: 2,
  petalCount: 8, // 0 disables petals
  color: Colors.deepOrange,
  gradient: const LinearGradient(colors: [Colors.orange, Colors.red]),
  speed: const Duration(milliseconds: 2400),
  isAnimating: true,
  curve: Curves.linear,
)
```

**Orbit** — dots orbiting a track with a comet trail, or optional sparkles.
```dart
OrbitProgressIndicator(
  size: 65,
  dotCount: 3,
  dotSize: 5,
  showSparkle: true,
  sparkleCount: 12,
  sparkleColor: Colors.amber,
  color: Colors.indigo,
  secondaryColor: Colors.indigo.withValues(alpha: 0.3),
  gradient: const LinearGradient(colors: [Colors.indigo, Colors.blue]),
  speed: const Duration(milliseconds: 1800),
  isAnimating: true,
  curve: Curves.fastOutSlowIn,
)
```

**Eclipse** — two circles growing and shrinking out of phase.
```dart
EclipseProgressIndicator(
  size: 65,
  color: Colors.pink,
  secondaryColor: Colors.pink.withValues(alpha: 0.4),
  gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
  speed: const Duration(seconds: 2),
  isAnimating: true,
  curve: Curves.easeInOut,
)
```

**Nexus** — radial tick marks whose opacity sweeps around, like a clock face.
```dart
NexusProgressIndicator(
  size: 50,
  barCount: 12,
  strokeWidth: 3.5,
  color: Colors.green,
  gradient: const LinearGradient(colors: [Colors.green, Colors.teal]),
  speed: const Duration(seconds: 1),
  isAnimating: true,
  curve: Curves.linear,
)
```

**Zenith** — flower-petal shapes fading in and out in sequence.
```dart
ZenithProgressIndicator(
  size: 50,
  leafCount: 12,
  color: Colors.deepPurple,
  gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
  speed: const Duration(milliseconds: 1200),
  isAnimating: true,
  curve: Curves.linear,
)
```

**Vortex** — arrow-tipped arcs chasing each other around a track.
```dart
VortexProgressIndicator(
  size: 50,
  arrowCount: 3,
  strokeWidth: 3.5,
  color: Colors.blue,
  gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
  speed: const Duration(milliseconds: 1500),
  isAnimating: true,
  curve: Curves.linear,
)
```

---

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
