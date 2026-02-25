import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
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
}
