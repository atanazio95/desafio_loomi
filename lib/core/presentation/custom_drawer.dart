import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // 20% de espaço acima
          const Spacer(flex: 1),

          // --- HEADER: NOTÍCIAS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Ícone de retorno com 20px e rotação de -180 graus
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new, // Ou o ícone que você está usando
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Notícias',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 22,
                    fontWeight: FontWeight.w700, // Bold
                    height: 1.0, // line-height: 100%
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // --- LISTA DE DEMAIS ITENS ---
          Expanded(
            flex: 6,
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              children: [
                // Exemplo de item (Categorias)
                _buildDrawerItem('Tecnologia'),
                _buildDrawerItem('Inovação'),
                _buildDrawerItem('Política'),
              ],
            ),
          ),

          // 20% de espaço abaixo
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  // Widget auxiliar para os demais itens (18px)
  Widget _buildDrawerItem(String label) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w700, // Bold
          height: 1.0, // line-height: 100%
          letterSpacing: 0,
          color: Colors.black,
        ),
      ),
      onTap: () {},
    );
  }
}
