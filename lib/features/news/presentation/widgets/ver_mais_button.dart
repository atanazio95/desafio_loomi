import 'package:flutter/material.dart';

/// "Ver mais" compact button with border (e.g. in news section header).
class VerMaisButton extends StatelessWidget {
  final VoidCallback onTap;

  const VerMaisButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0F172A)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ver mais", style: TextStyle(fontSize: 12)),
            SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }
}
