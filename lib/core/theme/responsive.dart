import 'dart:math';

import 'package:flutter/material.dart';

/// Responsive layout helpers (padding, image heights, logo size).
abstract class Responsive {
  Responsive._();

  /// Horizontal padding for content. Scales with screen width (min 16, max 24).
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return min(24.0, max(16.0, w * 0.065));
  }

  /// Horizontal padding as EdgeInsets for symmetric padding.
  static EdgeInsets horizontalPaddingInsets(BuildContext context) {
    final p = horizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: p);
  }

  /// Max height for hero/large news images (e.g. hero card, details hero).
  static double imageHeightHero(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(250.0, h * 0.28);
  }

  /// Height for grid/small card images.
  static double imageHeightGrid(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(120.0, h * 0.16);
  }

  /// Height for hero card on list (top big cards).
  static double imageHeightHeroCard(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(200.0, h * 0.24);
  }

  /// Height for recent list item thumbnail.
  static double imageHeightRecentThumb(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(80.0, h * 0.1);
  }

  /// Width for recent list item thumbnail (keep aspect ~1.5).
  static double imageWidthRecentThumb(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return min(120.0, w * 0.28);
  }

  /// Logo width in header. Clamped for small/large screens.
  static double logoWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return min(95.0, max(70.0, w * 0.22));
  }

  /// Logo height in header (proportional to standard 89x20).
  static double logoHeight(BuildContext context) {
    final width = logoWidth(context);
    return (20.0 * width / 89.0).roundToDouble();
  }

  /// Vertical space between last content and footer. Scales with screen height.
  static double footerTopSpacing(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return min(80.0, max(40.0, h * 0.06));
  }
}
