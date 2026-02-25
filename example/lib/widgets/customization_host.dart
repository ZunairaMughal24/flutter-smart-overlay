import 'package:flutter/material.dart';

class CustomizationHost extends StatelessWidget {
  final List<Widget> children;
  const CustomizationHost({super.key, required this.children});

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

class HeroItem extends StatelessWidget {
  final String label;
  final Widget indicator;

  const HeroItem({super.key, required this.label, required this.indicator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        indicator,
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color.fromARGB(255, 111, 133, 162),
          ),
        ),
      ],
    );
  }
}
