import 'dart:math';

import 'package:flutter/material.dart';

/// Responsive layout helpers.
abstract class Responsive {
  Responsive._();

  /// Horizontal padding based on screen width.
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return min(24.0, max(16.0, w * 0.065));
  }

  /// Horizontal padding as EdgeInsets.
  static EdgeInsets horizontalPaddingInsets(BuildContext context) {
    final p = horizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: p);
  }

  /// Hero image height.
  static double imageHeightHero(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(250.0, h * 0.28);
  }

  /// Grid card image height.
  static double imageHeightGrid(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(120.0, h * 0.16);
  }

  /// Hero card image height.
  static double imageHeightHeroCard(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(200.0, h * 0.24);
  }

  /// Recent news thumbnail height.
  static double imageHeightRecentThumb(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(80.0, h * 0.1);
  }

  /// Recent news thumbnail width.
  static double imageWidthRecentThumb(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return min(120.0, w * 0.28);
  }

  /// Logo width in header.
  static double logoWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return min(95.0, max(70.0, w * 0.22));
  }

  /// Logo height in header.
  static double logoHeight(BuildContext context) {
    final width = logoWidth(context);
    return (20.0 * width / 89.0).roundToDouble();
  }

  /// Vertical spacing above footer.
  static double footerTopSpacing(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(80.0, max(40.0, h * 0.06));
  }
}
