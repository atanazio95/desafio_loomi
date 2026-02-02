import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback onFavoriteToggle;

  const NewsCard({
    super.key,
    required this.news,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Pegamos a instância atual do Bloc
            final newsBloc = context.read<NewsBloc>();
            // Navegamos passando o Map
            context.push(
              '/news/details',
              extra: {'news': news, 'bloc': newsBloc},
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Imagem com a Estrela no canto
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        news.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),

                    // O ÍCONE DE ESTRELA (Favorito)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            // [NOVO] Borda adicionada para igualar ao DetailsPage
                            border: Border.all(
                              color: const Color(0xFFD0D0D0),
                              width: 1.01,
                            ),
                          ),
                          child: Icon(
                            news.isFavorite ? Icons.star : Icons.star_border,
                            color: news.isFavorite
                                ? Colors.yellow
                                : Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2. Categoria e Título
                Text(
                  news.category.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D478C),
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  news.title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),

                // 3. Descrição Curta
                Text(
                  news.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Divisor
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
