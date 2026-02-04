import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Top message balloon widget for success, error, and info feedback.
class FeedbackBalloon extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onClose;

  const FeedbackBalloon({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  /// Shows success message.
  static void showSuccess(
    BuildContext context, {
    required String message,
    String subtitle = '',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      subtitle: subtitle,
      color: AppColors.success,
      icon: Icons.check,
      duration: duration,
    );
  }

  /// Shows error message.
  static void showError(
    BuildContext context, {
    required String message,
    String subtitle = '',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      subtitle: subtitle,
      color: AppColors.error,
      icon: Icons.close,
      duration: duration,
    );
  }

  /// Shows info message.
  static void showInfo(
    BuildContext context, {
    required String message,
    String subtitle = '',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message: message,
      subtitle: subtitle,
      color: AppColors.primary,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  /// Shows balloon using Overlay.
  static void _show(
    BuildContext context, {
    required String message,
    required String subtitle,
    required Color color,
    required IconData icon,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: FeedbackBalloon(
            title: message,
            subtitle: subtitle,
            color: color,
            icon: icon,
            onClose: () => overlayEntry.remove(),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
