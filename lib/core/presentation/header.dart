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
                  builder: (context) => ElevatedButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Image.asset(
                      'assets/assets/menu_loomi.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(
                  'assets/assets/nortus.png',
                  width: 89,
                  height: 20,
                  fit: BoxFit
                      .contain, // Garante que a imagem se ajuste sem distorcer
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
