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
