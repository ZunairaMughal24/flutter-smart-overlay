import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_overlay/smart_overlay.dart';

void main() {
  runApp(const SmartOverlayGuide());
}

class SmartOverlayGuide extends StatelessWidget {
  const SmartOverlayGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Overlay Professional Guide',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
      ),
      home: const GuideScreen(),
    );
  }
}

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 27, 49),
      appBar: AppBar(
        title: Text(
          'Smart Overlay',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Smart Overlay Logic',
                'Managed full-screen load states',
              ),
              const SizedBox(height: 12),
              _buildOverlayGrid(context),

              const SizedBox(height: 22),
              _buildSectionHeader(
                'Widget Injection',
                'Inject indicators into any UI component',
              ),
              const SizedBox(height: 12),
              const _IndicatorDemoCard(
                title: 'Fading Dots Indicator',
                description: 'Opacity-modulated circular pulse',
                indicator: FadingDotsProgressIndicator(
                  size: 40,
                  dotCount: 12,
                  gradient: SweepGradient(
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF2DD4BF),
                      Color(0xFF6366F1),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const _IndicatorDemoCard(
                title: 'Scalloped Indicator',
                description: 'Synchronized wave-path animation',
                indicator: ScallopedProgressIndicator(
                  size: 40,
                  strokeWidth: 3,
                  gradient: LinearGradient(
                    colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const _IndicatorDemoCard(
                title: 'Liquid Indicator',
                description: 'Fluid sine-wave filling animation',
                indicator: LiquidProgressIndicator(
                  size: 40,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 50, 173, 230),
                      Color(0xFF2DD4BF),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(
                'Parameter Customization',
                'Granular control over physics and aesthetics',
              ),
              const SizedBox(height: 16),
              _buildDotsCustomizationRow(),
              const SizedBox(height: 16),
              _buildScallopedCustomizationRow(),
              const SizedBox(height: 16),
              _buildLiquidCustomizationRow(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 163, 179, 201),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            label: 'Scalloped Overlay',
            description: 'Manual hide',
            icon: Icons.lock_outline,
            color: const Color(0xFF6366F1),
            onTap: () async {
              SmartOverlay.show(
                context: context,
                message: 'Awaiting completion...',
              );
              await Future.delayed(const Duration(seconds: 3));
              SmartOverlay.hide();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionCard(
            label: 'Dotted   Overlay',
            description: 'Auto-dismiss',
            icon: Icons.timer_outlined,
            color: const Color(0xFF2DD4BF),
            onTap: () {
              SmartOverlay.show(
                context: context,
                message: 'Processing data...',
                autoDismissDuration: const Duration(seconds: 2),
                indicator: const FadingDotsProgressIndicator(
                  color: Color(0xFF2DD4BF),
                  size: 60,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionCard(
            label: 'Liquid        Overlay',
            description: 'Water fill style',
            icon: Icons.water_drop_outlined,
            color: const Color(0xFF0EA5E9),
            onTap: () async {
              SmartOverlay.show(
                context: context,
                message: 'Streaming assets...',
                indicator: const LiquidProgressIndicator(
                  size: 70,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 215, 238, 248),
                      Color.fromARGB(255, 215, 238, 248),
                      Color.fromARGB(255, 45, 201, 212),
                    ],
                  ),
                ),
              );
              await Future.delayed(const Duration(seconds: 3));
              SmartOverlay.hide();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionCard(
            label: 'Glass       Overlay',
            description: 'Blur background',
            icon: Icons.blur_on_rounded,
            color: const Color(0xFFA855F7),
            onTap: () async {
              SmartOverlay.show(
                context: context,
                messageWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'AI Processing...',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Analyzing data patterns',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                useBlur: true,
                backgroundColor: Colors.black.withAlpha(150),
                indicator: const FadingDotsProgressIndicator(
                  color: Colors.white,
                  size: 80,
                  dotSize: 4,
                  radius: 20,
                ),
              );
              await Future.delayed(const Duration(seconds: 3));
              SmartOverlay.hide();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDotsCustomizationRow() {
    return _CustomizationHost(
      children: [
        _HeroItem(
          label: 'Wide Hero',
          indicator: const FadingDotsProgressIndicator(
            size: 65,
            dotCount: 14,
            radius: 28,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        _HeroItem(
          label: 'Compact',
          indicator: const FadingDotsProgressIndicator(
            size: 65,
            dotCount: 8,
            radius: 16,
            dotSize: 6,
            gradient: LinearGradient(
              colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
            ),
          ),
        ),
        _HeroItem(
          label: 'Density',
          indicator: const FadingDotsProgressIndicator(
            size: 65,
            dotCount: 20,
            dotSize: 2,
            radius: 25,
            gradient: SweepGradient(
              colors: [Color(0xFF818CF8), Color(0xFFC084FC), Color(0xFF818CF8)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScallopedCustomizationRow() {
    return _CustomizationHost(
      children: [
        _HeroItem(
          label: 'Standard',
          indicator: const ScallopedProgressIndicator(
            size: 65,
            strokeWidth: 2,
            waveCount: 9,
            gradient: LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        _HeroItem(
          label: 'Complexity',
          indicator: const ScallopedProgressIndicator(
            size: 65,
            strokeWidth: 3,
            waveCount: 20,
            gradient: LinearGradient(
              colors: [
                Color(0xFF6366F1),
                Color.fromARGB(255, 183, 124, 238),
                Colors.white,
              ],
            ),
          ),
        ),
        _HeroItem(
          label: 'Bold Stroke',
          indicator: const ScallopedProgressIndicator(
            size: 65,
            strokeWidth: 6,
            waveCount: 6,
            gradient: LinearGradient(
              colors: [
                Color(0xFFF43F5E),
                Color(0xFFFB923C),
                Color.fromARGB(255, 218, 233, 89),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiquidCustomizationRow() {
    return _CustomizationHost(
      children: [
        _HeroItem(
          label: 'Calm',
          indicator: const LiquidProgressIndicator(
            size: 65,
            waveAmplitude: 2,
            waveFrequency: 1,
            gradient: LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        _HeroItem(
          label: 'Stormy',
          indicator: const LiquidProgressIndicator(
            size: 65,
            waveAmplitude: 8,
            waveFrequency: 2,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        _HeroItem(
          label: 'Progress',
          indicator: const LiquidProgressIndicator(
            size: 65,
            value: 0.7,
            gradient: LinearGradient(
              colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomizationHost extends StatelessWidget {
  final List<Widget> children;
  const _CustomizationHost({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            Text(
              description,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _IndicatorDemoCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget indicator;

  const _IndicatorDemoCard({
    required this.title,
    required this.description,
    required this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          _IndicatorCircle(child: indicator),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorCircle extends StatelessWidget {
  final Widget child;
  const _IndicatorCircle({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF0F172A),
      ),
      child: Center(child: child),
    );
  }
}

class _HeroItem extends StatelessWidget {
  final String label;
  final Widget indicator;

  const _HeroItem({required this.label, required this.indicator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        indicator,
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
