import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        // Aumentamos o horizontal para 16.0 (padrão de design)
        // e reduzimos o vertical para não distanciar muito da AppBar azul
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment
              .center, // Centraliza verticalmente texto e ícone
          children: [
            // LADO ESQUERDO: Título
            // Se na NewsPage o texto começa após o ícone,
            // aqui podemos colocar um pequeno padding para simular esse alinhamento
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Image.asset(
                'assets/assets/nortus.png',
                width: 89,
                height: 20,
                fit: BoxFit
                    .contain, // Garante que a imagem se ajuste sem distorcer
              ),
            ),

            // LADO DIREITO: Lupa
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              // Aumentei levemente para 28 para manter o peso visual contra o texto de 32
              icon: const Icon(Icons.search, size: 28, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
