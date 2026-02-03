import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Small label text for form fields.
class FormLabel extends StatelessWidget {
  final String text;

  const FormLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: const Color(0xFF0B1125),
        ),
      ),
    );
  }
}
