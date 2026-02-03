import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section header text for forms (e.g. "Ajustes de idioma, fuso horário e data").
class FormSectionHeader extends StatelessWidget {
  final String title;

  const FormSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: const Color(0xFF0B1125),
      ),
    );
  }
}
