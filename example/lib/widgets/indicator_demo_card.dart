import 'package:flutter/material.dart';

class IndicatorDemoCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget indicator;

  const IndicatorDemoCard({
    super.key,
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
