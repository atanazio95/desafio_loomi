import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const CustomHomeAppBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF0D478C);

    return AppBar(
      backgroundColor: brandBlue,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/assets/logo_shield.png',
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 32),
          _buildNavButton('Notícias', 0),
          const SizedBox(width: 24),
          _buildNavButton('Meu perfil', 1),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
