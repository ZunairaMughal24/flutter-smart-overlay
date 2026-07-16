# smart_overlay 🌊

<p align="center">
  <img src="https://raw.githubusercontent.com/ZunairaMughal24/flutter-smart-overlay/main/assets/Indicator%20Demo%20Gif.gif" width="370px" alt="Smart Overlay Premium Demo">
</p>

A **premium, lightweight loading overlay manager** for Flutter. Featuring the unique **FluxWave (Wavy) Progress Indicator** with full gradient support.

---

## ✨ Features

- **Multiple Styles**: Choose between the unique `FluxWaveProgressIndicator` or the professional `LuminaProgressIndicator`.
- **Custom Indicators**: Inject any custom widget as your progress indicator.
- **Built-in Accessibility**: All loaders come with `Semantics` support out of the box.
- **Gradients Galore**: Apply beautiful gradients to your loaders for a high-end feel.
- **Micro-Animations**: Smooth scale and fade transitions for a premium UX.
- **Glassmorphism**: Optional background blur (`useBlur`) for the full-screen loader.
- **Simple API**: Easy-to-use `SmartOverlay` static methods or `BuildContext` extensions.
- **Elite Customization**: Control `dotSize`, `dotCount`, and spread `radius` for indicators.
- **Hybrid Messages**: Use simple `String` messages or complex `Widget` message builders.

---

## 🚀 Quick Start

### 1. Installation
Add `smart_overlay` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_overlay: ^0.0.1
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
  backgroundColor: Colors.indigo.withOpacity(0.4),
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

Each indicator also has its own visual-specific parameters (`waveCount`, `dotCount`, `rippleCount`, etc.) — see each class's dartdoc for details. A live, runnable example of all three `isAnimating` patterns above is in [example/lib/widgets/animation_control_demo.dart](example/lib/widgets/animation_control_demo.dart).

---

## 🛠️ Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `backgroundColor` | Background color of the overlay | `Colors.black54` (dark) |
| `textColor` | Color of the message text | `Colors.white` |
| `useBlur` | Enable background glassmorphism blur | `false` |
| `gradient` | Apply a gradient to the progress indicator | `null` |
| `indicator` | Inject a custom indicator widget | `FluxWaveProgressIndicator` |
| `message` | Optional text to display below the loader | `null` |
| `messageWidget` | Inject a custom widget as the message | `null` |
| `autoDismissDuration` | If set, the overlay hides automatically | `null` (sticky) |

---

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
