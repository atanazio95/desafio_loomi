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

  /// Input/card border gray (e.g. auth fields, recent card bottom).
  static const Color inputBorder = Color(0xFFB4B4B4);

  /// Label and hint text (e.g. form labels, placeholders).
  static const Color labelHint = Color(0xFF9CA3AF);

  /// Dark slate text (headings, card titles).
  static const Color textSlate = Color(0xFF0F172A);

  /// Category/secondary text (e.g. news category).
  static const Color categoryGray = Color(0xFF64748B);

  /// Muted text (timestamps, secondary info).
  static const Color textMuted = Color(0xFF94A3B8);

  /// Section background (e.g. "Mais recentes" header).
  static const Color sectionBg = Color(0xFFFAFAFA);

  /// Divider and thin borders.
  static const Color divider = Color(0xFFEEEEEE);

  /// Image placeholder / icon gray.
  static const Color iconPlaceholder = Color(0xFFD0D0D0);

  /// Footer background.
  static const Color footerBg = Color(0xFF0F172A);

  /// Footer accent (e.g. "Nortus" brand).
  static const Color footerAccent = Color(0xFF1E88E5);

  /// Surface white (scaffold, cards).
  static const Color surfaceWhite = Color(0xFFFFFFFF);
}
