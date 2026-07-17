import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_overlay/smart_overlay.dart';

/// Demonstrates the `isAnimating` and `speed` parameters shared by every
/// indicator: freeze/resume the animation from outside without unmounting
/// the widget, and control how fast it runs. Also shows that stopping
/// "after a given time" needs no extra package API — just drive
/// `isAnimating` from a `Timer` instead of a `Switch`.
class AnimationControlDemo extends StatefulWidget {
  const AnimationControlDemo({super.key});

  @override
  State<AnimationControlDemo> createState() => _AnimationControlDemoState();
}

class _AnimationControlDemoState extends State<AnimationControlDemo> {
  bool _isAnimating = true;
  double _speedSeconds = 9;

  bool _autoStopIsAnimating = false;
  Timer? _autoStopTimer;

  bool _emailVerified = false;
  bool _profileComplete = false;
  bool _termsAccepted = false;

  bool get _allConditionsMet =>
      _emailVerified && _profileComplete && _termsAccepted;

  void _runForNineSeconds() {
    _autoStopTimer?.cancel();
    setState(() => _autoStopIsAnimating = true);
    _autoStopTimer = Timer(const Duration(seconds: 9), () {
      if (mounted) setState(() => _autoStopIsAnimating = false);
    });
  }

  @override
  void dispose() {
    _autoStopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: FluxWaveProgressIndicator(
                    waveCount: 12,
                    strokeWidth: 3,
                    size: 50,
                    isAnimating: _isAnimating,
                    speed: Duration(
                      milliseconds: (_speedSeconds * 1000).round(),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'isAnimating + speed',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _isAnimating
                          ? 'Running — flip the switch to freeze it, like you would once your async task finishes.'
                          : 'Frozen at its current frame. Flip the switch to resume.',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isAnimating,
                onChanged: (value) => setState(() => _isAnimating = value),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Speed',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  min: 0.5,
                  max: 10,
                  value: _speedSeconds,
                  label: '${_speedSeconds.toStringAsFixed(1)}s',
                  onChanged: (value) => setState(() => _speedSeconds = value),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFF334155)),
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: FluxWaveProgressIndicator(
                    waveCount: 8,
                    strokeWidth: 3,
                    size: 50,
                    isAnimating: _autoStopIsAnimating,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stop after a time, not a switch',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _autoStopIsAnimating
                          ? 'Running — will freeze itself in 3 seconds, no switch needed.'
                          : 'Tap to run for exactly 3 seconds, then it stops on its own.',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: _autoStopIsAnimating ? null : _runForNineSeconds,
                child: const Text('Run 9s'),
              ),
            ],
          ),
          const Divider(height: 24, color: Color(0xFF334155)),
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: FluxWaveProgressIndicator(
                    waveCount: 8,
                    strokeWidth: 3,
                    size: 50,
                    isAnimating: !_allConditionsMet,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2DD4BF), Color(0xFF6366F1)],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _allConditionsMet
                      ? 'All 3 conditions met — stopped automatically. No switch, no timer.'
                      : 'Driven by 3 real conditions below, not a switch.',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Email verified'),
            value: _emailVerified,
            onChanged: (value) =>
                setState(() => _emailVerified = value ?? false),
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Profile complete'),
            value: _profileComplete,
            onChanged: (value) =>
                setState(() => _profileComplete = value ?? false),
          ),
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Terms accepted'),
            value: _termsAccepted,
            onChanged: (value) =>
                setState(() => _termsAccepted = value ?? false),
          ),
        ],
      ),
    );
  }
}
