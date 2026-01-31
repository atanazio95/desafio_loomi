import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/news_entity.dart';

class NewsCard extends StatelessWidget {
  final NewsEntity news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2, // Elevação sutil
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip
          .antiAlias, // Garante que a imagem respeite as bordas arredondadas
      child: InkWell(
        onTap: () {
          context.push('/news/details', extra: news);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGEM (Topo)
            Hero(
              tag: 'news_image_${news.id}',
              child: Image.network(
                news.imageUrl,
                height: 160, // Altura fixa para manter padrão na lista
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

            // 2. CONTEÚDO (Título e Descrição)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    news.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // "..." se for muito longo
                  ),

                  const SizedBox(height: 8),

                  // Breve Descrição (Summary)
                  Text(
                    news.summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height:
                          1.4, // Espaçamento entre linhas para leitura melhor
                    ),
                    maxLines: 3, // Limita a 3 linhas para ser "breve"
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
