import 'package:flutter/material.dart';

/// App color palette.
abstract class AppColors {
  AppColors._();

  /// Primary blue color.
  static const Color primary = Color(0xFF1876D2);

  /// Dark blue color.
  static const Color primaryDark = Color(0xFF0D478C);

  /// Outline/secondary color.
  static const Color outline = Color(0xFF163C43);

  /// Loading indicator color.
  static const Color loading = Color(0xFF1876D2);

  /// Error color.
  static const Color error = Color(0xFFF5222D);

  /// Success color.
  static const Color success = Color(0xFF6FCF97);

  /// Primary text color.
  static const Color textPrimary = Color(0xFF0B1125);

  /// Form input text color.
  static const Color formText = Color(0xFF666666);

  /// Light background color.
  static const Color surfaceLight = Color(0xFFF1F5F9);

  /// Light border color.
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Input border color.
  static const Color inputBorder = Color(0xFFB4B4B4);

  /// Label and hint text color.
  static const Color labelHint = Color(0xFF9CA3AF);

  /// Dark slate text color.
  static const Color textSlate = Color(0xFF0F172A);

  /// Category/secondary text color.
  static const Color categoryGray = Color(0xFF64748B);

  /// Muted text color.
  static const Color textMuted = Color(0xFF94A3B8);

  /// Section background color.
  static const Color sectionBg = Color(0xFFFAFAFA);

  /// Divider color.
  static const Color divider = Color(0xFFEEEEEE);

  /// Icon placeholder color.
  static const Color iconPlaceholder = Color(0xFFD0D0D0);

  /// Footer background color.
  static const Color footerBg = Color(0xFF0F172A);

  /// Footer accent color.
  static const Color footerAccent = Color(0xFF1E88E5);

  /// White surface color.
  static const Color surfaceWhite = Color(0xFFFFFFFF);
}
