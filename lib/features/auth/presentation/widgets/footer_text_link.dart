import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text link for login footer (e.g. "Esqueci a senha", "Continuar sem conta").
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
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}
