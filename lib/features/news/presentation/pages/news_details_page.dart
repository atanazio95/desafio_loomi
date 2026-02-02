import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailsPage extends StatelessWidget {
  final NewsEntity news;

  const NewsDetailsPage({super.key, required this.news});

  // --- 1. LÓGICA DE TOGGLE ---
  void _onFavoriteToggle(BuildContext context, bool isCurrentlyFavorited) {
    context.read<NewsBloc>().add(ToggleFavoriteHome(news.id));

    if (isCurrentlyFavorited) {
      _showRemoveSnackBar(context);
    } else {
      _showSuccessSnackBar(context);
    }
  }

  // --- SNACKBAR DE SUCESSO (VERDE) ---
  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF6FCF97),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Color(0xFF6FCF97),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Você favoritou esta Notícia",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Você pode encontrá-la no perfil",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- SNACKBAR DE REMOÇÃO ---
  void _showRemoveSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removido dos favoritos'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF1876D2);
    const textBlack = Color(0xFF0B1125);
    const textGrey = Color(0xFF6D7A9C);

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(news.datePublished);
    } catch (e) {
      parsedDate = DateTime.now();
    }
    final formattedDate = DateFormat(
      "dd/MM/yyyy 'ás' HH:mm",
    ).format(parsedDate);
    final categories = [news.category.toUpperCase(), "INOVAÇÃO", "MERCADO"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomHomeAppBar(
        selectedTab: 0,
        onTabChanged: (index) {
          if (index == 1) context.push('/profile');
        },
      ),
      body: Column(
        children: [
          // HEADER "VOLTAR"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, color: textBlack, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Voltar',
                    style: GoogleFonts.inter(
                      color: textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // --- 1. LINHA TOPO: CATEGORIA E FAVORITO ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge Categoria
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors
                              .white, // Fundo branco (ou brandBlue opaco se preferir o estilo antigo)
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: brandBlue.withOpacity(
                              0.5,
                            ), // Borda azul sutil
                          ),
                        ),
                        child: Text(
                          news.category.toUpperCase(), // Ex: Economia
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textBlack, // Texto preto conforme imagem
                          ),
                        ),
                      ),

                      // Botão Favorito (Reactive)
                      BlocBuilder<NewsBloc, NewsState>(
                        builder: (context, state) {
                          final isFavorited =
                              state.savedNews.any((n) => n.id == news.id) ||
                              state.news.any(
                                (n) => n.id == news.id && n.isFavorite,
                              );

                          return GestureDetector(
                            onTap: () =>
                                _onFavoriteToggle(context, isFavorited),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                // Borda exata solicitada
                                border: Border.all(
                                  color: const Color(0xFFD0D0D0),
                                  width: 1.01,
                                ),
                              ),
                              child: Icon(
                                isFavorited ? Icons.star : Icons.star_border,
                                color: isFavorited
                                    ? Colors
                                          .yellow // Amarelo se ativo
                                    : Colors.black, // Preto se inativo
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // --- 2. TÍTULO ---
                  Text(
                    news.title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: textBlack,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- 3. DATA ---
                  Text(
                    'Publicado: $formattedDate',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: textBlack.withOpacity(0.7), // Um pouco mais escuro
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- 4. IMAGEM (Sem Stack) ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      news.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Legenda
                  Center(
                    child: Text(
                      "Imagem ilustrativa da notícia", // Ou news.caption se tiver
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- 5. RESUMO (Card) ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 18,
                              color: Color(0xFF0F172A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Resumo",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          news.summary,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.5,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- 6. DESCRIÇÃO ---
                  Text(
                    news.description.isNotEmpty
                        ? news.description
                        : news.summary,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.6,
                      color: textBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- 7. CATEGORIAS ---
                  Text(
                    "Categorias",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: brandBlue.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: brandBlue,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
