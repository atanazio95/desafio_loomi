import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Full-width "Load more" / pagination button with optional loading state.
class LoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadMoreButton({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.loading,
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ver mais"),
                  SizedBox(width: 10),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
      ),
    );
  }
}
