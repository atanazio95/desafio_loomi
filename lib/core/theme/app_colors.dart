import 'package:flutter/material.dart';

/// Central app color palette.
abstract class AppColors {
  AppColors._();

  /// Primary blue (buttons, links, accents).
  static const Color primary = Color(0xFF1876D2);

  /// Dark blue (AppBar, tabs, brand).
  static const Color primaryDark = Color(0xFF0D478C);

  /// Outline / secondary (borders, secondary buttons).
  static const Color outline = Color(0xFF163C43);

  /// Loading indicator color.
  static const Color loading = Color(0xFF1876D2);

  /// Error / danger (snackbars, destructive actions).
  static const Color error = Color(0xFFF5222D);

  /// Success (snackbars, confirmations).
  static const Color success = Color(0xFF6FCF97);

  /// Text / content dark.
  static const Color textPrimary = Color(0xFF0B1125);

  /// Form input text (fields, dropdowns).
  static const Color formText = Color(0xFF666666);

  /// Light gray background.
  static const Color surfaceLight = Color(0xFFF1F5F9);

  /// Border light gray.
  static const Color borderLight = Color(0xFFE2E8F0);
}
