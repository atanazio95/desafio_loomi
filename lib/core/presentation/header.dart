import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsHeader extends StatelessWidget {
  const NewsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o SafeArea aqui para garantir que ele fique no topo, mas sem o corte do notch
    return SafeArea(
      bottom: false,
      child: Padding(
        // Ajustamos para subir mais o header (menos padding top)
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LADO ESQUERDO: Menu Custom + Título
            Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    // Icons.notes é mais fino e moderno que o Icons.menu
                    icon: const Icon(
                      Icons.notes,
                      size: 32,
                      color: Colors.black,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Nortus',
                  style: GoogleFonts.spaceGrotesk(
                    // Alinhando com a fonte do Drawer
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // LADO DIREITO: Lupa Fina
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.search,
                size: 28,
                color: Colors.black,
                // No Flutter 3.10+, você pode usar strokes mais finos se usar Material Symbols
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
