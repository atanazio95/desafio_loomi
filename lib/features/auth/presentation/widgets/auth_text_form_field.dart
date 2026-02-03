import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Login/register style text form field with floating label.
class AuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final VoidCallback? onChanged;

  const AuthTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (_) => onChanged?.call(),
      style: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      maxLength: maxLength ?? 15,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: GoogleFonts.inter(
          color: controller.text.isNotEmpty
              ? const Color(0xFF0D478C)
              : Colors.grey[500],
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: const Color(0xFF1876D2),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.fromLTRB(16, 30, 16, 12),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(height: 0.8, fontSize: 12),
      ),
    );
  }
}
