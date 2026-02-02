import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedTab;
  // Removi o onTabChanged pois usaremos o GoRouter para mudar a stack

  const CustomHomeAppBar({
    super.key,
    required this.selectedTab,
    required Null Function(dynamic index) onTabChanged,
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
          // Passamos o contexto para o builder de botões
          _buildNavButton(context, 'Notícias', 0, '/news'),
          const SizedBox(width: 24),
          _buildNavButton(context, 'Meu perfil', 1, '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String label,
    int index,
    String route,
  ) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        // Se já estiver na aba, não faz nada, senão navega
        if (!isSelected) {
          context.go(route);
        }
      },
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
