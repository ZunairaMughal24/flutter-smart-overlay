import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_overlay/smart_overlay.dart';
import 'widgets/section_header.dart';
import 'widgets/action_card.dart';
import 'widgets/indicator_demo_card.dart';
import 'widgets/customization_host.dart';
import 'widgets/animation_control_demo.dart';

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
              const SectionHeader(
                title: 'Overlay Manager',
                subtitle: 'Global full-screen load states',
              ),
              const SizedBox(height: 12),
              _buildOverlayGrid(context),

              const SizedBox(height: 20),
              const SectionHeader(
                title: 'Standalone Indicators',
                subtitle: 'Modular widgets for any UI',
              ),
              const SizedBox(height: 12),
              const IndicatorDemoCard(
                title: 'Lumina Indicator',
                description: 'Opacity-modulated circular pulse',
                indicator: LuminaProgressIndicator(
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
              const IndicatorDemoCard(
                title: 'FluxWave Indicator',
                description: 'Synchronized wave-path animation',
                indicator: FluxWaveProgressIndicator(
                  size: 40,
                  strokeWidth: 3,
                  gradient: LinearGradient(
                    colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const IndicatorDemoCard(
                title: 'Hydra Indicator',
                description: 'Fluid sine-wave filling animation',
                indicator: HydraProgressIndicator(
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
              const SizedBox(height: 8),
              const IndicatorDemoCard(
                title: 'Aura Indicator',
                description: 'Expanding concentric ripple rings',
                indicator: AuraProgressIndicator(
                  size: 40,
                  gradient: LinearGradient(
                    colors: [Color(0xFF2DD4BF), Color(0xFF0EA5E9)],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const IndicatorDemoCard(
                title: 'Nova Indicator',
                description: 'Strobed ring expansion with petals',
                indicator: NovaProgressIndicator(
                  size: 40,
                  gradient: LinearGradient(
                    colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const IndicatorDemoCard(
                title: 'Orbit Indicator',
                description: 'Orbiting dots with motion trails',
                indicator: OrbitProgressIndicator(
                  size: 40,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const IndicatorDemoCard(
                title: 'Zenith Indicator',
                description: 'Organic petal-shaped rotation',
                indicator: ZenithProgressIndicator(
                  size: 40,
                  leafCount: 12,
                  gradient: LinearGradient(
                    colors: [Color(0xFF2DD4BF), Color(0xFF6366F1)],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const IndicatorDemoCard(
                title: 'Eclipse Indicator',
                description: 'Two circles breathing in opposite rhythm',
                indicator: EclipseProgressIndicator(
                  size: 40,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                  ),
                ),
              ),
              const IndicatorDemoCard(
                title: 'Vortex Indicator',
                description: 'Solid rotating arrows in a sync pattern',
                indicator: VortexProgressIndicator(
                  size: 40,
                  arrowCount: 3,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const IndicatorDemoCard(
                title: 'Nexus Indicator',
                description: 'Cascading radiating bars',
                indicator: NexusProgressIndicator(
                  size: 40,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const SectionHeader(
                title: 'Animation Control',
                subtitle: 'Stop and resume from outside, at any speed',
              ),
              const SizedBox(height: 12),
              const AnimationControlDemo(),

              const SizedBox(height: 20),
              const SectionHeader(
                title: 'Indicator Playground',
                subtitle: 'Live physics and style tuning',
              ),
              const SizedBox(height: 16),
              _buildLuminaCustomizationRow(),
              const SizedBox(height: 16),
              _buildFluxWaveCustomizationRow(),
              const SizedBox(height: 16),
              _buildHydraCustomizationRow(),
              const SizedBox(height: 16),
              _buildAuraCustomizationRow(),
              const SizedBox(height: 16),
              _buildZenithCustomizationRow(),
              const SizedBox(height: 16),
              _buildNovaCustomizationRow(),
              const SizedBox(height: 16),
              _buildOrbitCustomizationRow(),
              const SizedBox(height: 16),
              _buildEclipseCustomizationRow(),
              const SizedBox(height: 16),
              _buildNexusCustomizationRow(),

              const SizedBox(height: 16),
              _buildVortexCustomizationRow(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionCard(
            label: 'FluxWave Overlay',
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
          child: ActionCard(
            label: 'Lumina Overlay',
            description: 'Auto-dismiss',
            icon: Icons.timer_outlined,
            color: const Color(0xFF2DD4BF),
            onTap: () {
              SmartOverlay.show(
                context: context,
                message: 'Processing data...',
                autoDismissDuration: const Duration(seconds: 2),
                indicator: const LuminaProgressIndicator(
                  color: Color(0xFF2DD4BF),
                  size: 60,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ActionCard(
            label: 'Hydra Overlay',
            description: 'Water fill',
            icon: Icons.water_drop_outlined,
            color: const Color(0xFF0EA5E9),
            onTap: () async {
              SmartOverlay.show(
                context: context,
                message: 'Streaming assets...',
                indicator: const HydraProgressIndicator(
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
          child: ActionCard(
            label: 'Aura Overlay',
            description: 'Glass bloom',
            icon: Icons.blur_on_rounded,
            color: const Color(0xFFA855F7),
            onTap: () async {
              SmartOverlay.show(
                context: context,
                messageWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Syncing...',
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
                        'Establishing connection',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                useBlur: true,
                backgroundColor: Colors.black.withAlpha(150),
                indicator: const AuraProgressIndicator(
                  color: Colors.white,
                  size: 80,
                  rippleCount: 3,
                  strokeWidth: 2,
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

  Widget _buildLuminaCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Wide Hero',
          indicator: LuminaProgressIndicator(
            size: 65,
            dotCount: 14,
            radius: 28,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Compact',
          indicator: LuminaProgressIndicator(
            size: 65,
            dotCount: 8,
            radius: 16,
            dotSize: 6,
            gradient: LinearGradient(
              colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Density',
          indicator: LuminaProgressIndicator(
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

  Widget _buildFluxWaveCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Standard',
          indicator: FluxWaveProgressIndicator(
            size: 65,
            strokeWidth: 3,
            waveCount: 10,
            gradient: LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Complexity',
          indicator: FluxWaveProgressIndicator(
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
        const HeroItem(
          label: 'Bold Stroke',
          indicator: FluxWaveProgressIndicator(
            size: 65,
            strokeWidth: 5,
            waveCount: 6,
            curve: Curves.easeInOut,
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

  Widget _buildHydraCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Calm',
          indicator: HydraProgressIndicator(
            size: 60,
            waveAmplitude: 3,
            waveFrequency: 1,

            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 171, 224, 248),
                Color.fromARGB(255, 41, 186, 215),
              ],
            ),
          ),
        ),
        const HeroItem(
          label: 'Stormy',
          indicator: HydraProgressIndicator(
            size: 60,
            waveAmplitude: 6,
            waveFrequency: 2,

            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Progress',
          indicator: HydraProgressIndicator(
            size: 60,
            value: 0.6,
            waveAmplitude: 2,
            waveFrequency: 2,

            gradient: LinearGradient(
              colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuraCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Gentle',
          indicator: AuraProgressIndicator(
            size: 65,
            rippleCount: 2,
            strokeWidth: 1.5,
            gradient: LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Bloom',
          indicator: AuraProgressIndicator(
            size: 65,
            rippleCount: 4,
            strokeWidth: 2.5,
            gradient: LinearGradient(
              colors: [Color(0xFFF43F5E), Color(0xFFFB923C)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Pulse',
          indicator: AuraProgressIndicator(
            size: 65,
            rippleCount: 3,
            strokeWidth: 3,
            showCenter: false,
            gradient: LinearGradient(
              colors: [Color(0xFFFB923C), Color(0xFFF43F5E), Color(0xFFA855F7)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNovaCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Subtle',
          indicator: NovaProgressIndicator(
            size: 65,
            ringCount: 2,
            strokeWidth: 1.5,
            petalCount: 4,
            gradient: LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Radiant',
          indicator: NovaProgressIndicator(
            size: 65,
            ringCount: 3,
            strokeWidth: 2.5,
            petalCount: 8,
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color(0xFFF43F5E)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Clean',
          indicator: NovaProgressIndicator(
            size: 65,
            ringCount: 4,
            strokeWidth: 2,
            petalCount: 0,
            curve: Curves.easeInOut,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF818CF8), Color(0xFFC084FC)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrbitCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Duo',
          indicator: OrbitProgressIndicator(
            size: 65,
            dotCount: 2,
            dotSize: 5,
            curve: Curves.linear,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),

        const HeroItem(
          label: 'Swarm',
          indicator: OrbitProgressIndicator(
            size: 65,
            dotCount: 5,
            dotSize: 4,
            curve: Curves.fastOutSlowIn,
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color(0xFFF43F5E)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Comet',
          indicator: OrbitProgressIndicator(
            size: 65,
            dotCount: 1,
            dotSize: 6,
            curve: Curves.easeInOut,
            gradient: LinearGradient(
              colors: [Color(0xFFFB923C), Color(0xFFF43F5E)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEclipseCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Classic',
          indicator: EclipseProgressIndicator(
            size: 65,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Contrast',
          indicator: EclipseProgressIndicator(
            size: 65,
            color: Color(0xFFF43F5E),
            secondaryColor: Color(0xFF2DD4BF),
          ),
        ),
        const HeroItem(
          label: 'Neon',
          indicator: EclipseProgressIndicator(
            size: 65,
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color(0xFFC084FC), Color(0xFF818CF8)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNexusCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Standard',
          indicator: NexusProgressIndicator(
            size: 65,
            barCount: 12,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Dense',
          indicator: NexusProgressIndicator(
            size: 65,
            barCount: 20,
            strokeWidth: 2,
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color(0xFFF43F5E)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Bold',
          indicator: NexusProgressIndicator(
            size: 65,
            barCount: 8,
            strokeWidth: 6,
            gradient: LinearGradient(
              colors: [Color(0xFFFB923C), Color(0xFFF43F5E)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZenithCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Standard',
          indicator: ZenithProgressIndicator(
            size: 65,
            leafCount: 12,
            gradient: LinearGradient(
              colors: [Color(0xFF2DD4BF), Color(0xFF6366F1)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Petals',
          indicator: ZenithProgressIndicator(
            size: 65,
            leafCount: 18,
            curve: Curves.easeInOut,
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color(0xFFF43F5E)],
            ),
          ),
        ),

        const HeroItem(
          label: 'Minimal',
          indicator: ZenithProgressIndicator(
            size: 65,
            leafCount: 6,
            curve: Curves.linear,
            gradient: LinearGradient(
              colors: [Color(0xFFFB923C), Color.fromARGB(255, 238, 153, 43)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVortexCustomizationRow() {
    return CustomizationHost(
      children: [
        const HeroItem(
          label: 'Sync',
          indicator: VortexProgressIndicator(
            size: 65,
            arrowCount: 2,
            strokeWidth: 4,
            curve: Curves.linearToEaseOut,
            gradient: LinearGradient(
              colors: [Color(0xFFA855F7), Color.fromARGB(255, 214, 14, 114)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Triple',
          indicator: VortexProgressIndicator(
            size: 65,
            arrowCount: 3,
            strokeWidth: 3,
            curve: Easing.legacy,
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)],
            ),
          ),
        ),
        const HeroItem(
          label: 'Bold',
          indicator: VortexProgressIndicator(
            size: 65,
            arrowCount: 1,
            strokeWidth: 6,
            curve: Curves.easeInOut,
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 247, 202, 54), Color(0xFFF43F5E)],
            ),
          ),
        ),
      ],
    );
  }
}
