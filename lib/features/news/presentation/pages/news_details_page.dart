import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter/material.dart';

class NewsDetailsPage extends StatelessWidget {
  final NewsEntity news;

  const NewsDetailsPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,

            // 2. ISSO É O IMPORTANTE: Mantém a barra visível ao rolar
            pinned: true,

            // 3. Define a cor do botão de voltar (Seta)
            iconTheme: const IconThemeData(
              color: Colors
                  .white, // Seta branca para contrastar com a imagem/barra preta
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 10,
                ), // Sombra pra garantir leitura
              ],
            ),

            // 4. Cor da barra quando ela estiver "fechada" (lá no topo)
            backgroundColor: Colors.black,
            // ... configurações ...
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'news_image_${news.id}',
                child: Image.network(
                  news.imageUrl, // <--- CAMPO ATUALIZADO
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[300]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    // ... style ...
                  ),
                  const SizedBox(height: 16),

                  // ... Linhas de Autor e Data ...
                  // Use news.author e news.datePublished aqui
                  const Divider(height: 32),

                  // O CONTEÚDO REAL
                  Text(
                    news.summary, // <--- USAMOS O CAMPO REAL AGORA
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
