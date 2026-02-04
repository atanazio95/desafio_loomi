import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Login/register style text form field. Optional floating label (e.g. hidden for password).
class AuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool showLabel;
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
    this.showLabel = true,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
    );
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (_) => onChanged?.call(),
      style: GoogleFonts.inter(
        fontSize: 16,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      maxLength: maxLength ?? 15,
      decoration: InputDecoration(
        labelText: showLabel ? label : null,
        hintText: showLabel ? null : label,
        floatingLabelBehavior: showLabel
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
        labelStyle: GoogleFonts.inter(
          color: AppColors.labelHint,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.labelHint,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: AppColors.labelHint,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        filled: true,
        fillColor: AppColors.surfaceWhite,
        contentPadding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        suffixIcon: suffixIcon,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        errorStyle: const TextStyle(height: 0.8, fontSize: 12),
        counterText: '',
      ),
    );
  }
}
