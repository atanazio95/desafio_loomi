import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text link for login footer (e.g. "Forgot password", "Continue without account").
class FooterTextLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const FooterTextLink({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
            decorationThickness: 1.2,
          ),
        ),
      ),
    );
  }
}
