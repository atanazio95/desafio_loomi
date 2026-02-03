import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section title with accent underline (e.g. "Noticias favoritadas" on profile).
class SectionTitle extends StatelessWidget {
  final String title;
  final Color accentColor;

  const SectionTitle({
    super.key,
    required this.title,
    this.accentColor = const Color(0xFF1876D2),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 116,
          height: 3,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}
