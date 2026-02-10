# smart_overlay 🌊

A **premium, lightweight loading overlay manager** for Flutter. Featuring the unique **Scalloped (Wavy) Progress Indicator** with full gradient support.

---

## ✨ Features

- **Unique Aesthetics**: Stand out with the customizable `ScallopedProgressIndicator`.
- **Gradients Galore**: Apply beautiful linear gradients to your loaders for a high-end feel.
- **Micro-Animations**: Smooth scale and fade transitions for a premium UX.
- **Glassmorphism**: Optional background blur (`useBlur`) for the full-screen loader.
- **Ultra Lightweight**: Zero bulky dependencies, keeping your app fast and sleek.
- **Simple API**: Easy-to-use `BuildContext` extensions.

---

## 🚀 Quick Start

### 1. Installation
Add `smart_overlay` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_overlay: ^0.0.1
```

### 2. Basic Usage
Show a simple full-screen loader:

```dart
context.showLoader(message: "Setting things up...");

// Later...
context.hideOverlay();
```

### 3. Premium Gradient Style
Bring your UI to life with gradients and blur:

```dart
context.showLoader(
  message: "Syncing your data...",
  options: OverlayOptions(
    useBlur: true,
    gradient: LinearGradient(
      colors: [Colors.purple, Colors.blueAccent],
    ),
  ),
);
```

### 4. Direct Indicator Usage
The `ScallopedProgressIndicator` can also be used as a standalone widget anywhere in your UI:

```dart
ScallopedProgressIndicator(
  size: 60,
  waveCount: 12,
  gradient: LinearGradient(
    colors: [Colors.orange, Colors.redAccent],
  ),
)
```

---

## 🛠️ Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `backgroundColor` | Background color of the overlay | `Colors.black54` |
| `useBlur` | Enable background glassmorphism blur | `false` |
| `gradient` | Apply a gradient to the progress indicator | `null` |
| `message` | Optional text to display below the loader | `null` |
| `waveCount` | Density of the scalloped waves | `14` |

---

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
