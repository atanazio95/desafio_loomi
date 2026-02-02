import 'package:desafio_loomi_flutter/core/presentation/custom_footer.dart';
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

  // --- LÓGICA DE TOGGLE ---
  void _onFavoriteToggle(
    BuildContext context,
    String newsId,
    bool isCurrentlyFavorited,
  ) {
    context.read<NewsBloc>().add(ToggleFavoriteHome(newsId));

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

  // --- SNACKBAR DE AVISO (SEM MAIS ITENS) ---
  void _showNoMoreItemsSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Não há mais itens para serem exibidos',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF334155),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
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
              // [CORREÇÃO 1] Removemos o padding daqui para o footer não ser afetado
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // [CORREÇÃO 2] Adicionamos um Padding que envolve APENAS o conteúdo da notícia
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // --- 1. LINHA TOPO: CATEGORIA E FAVORITO ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: brandBlue.withOpacity(0.5),
                                ),
                              ),
                              child: Text(
                                news.category.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: textBlack,
                                ),
                              ),
                            ),

                            // Botão Favorito Principal
                            BlocBuilder<NewsBloc, NewsState>(
                              builder: (context, state) {
                                final isFavorited =
                                    state.savedNews.any(
                                      (n) => n.id == news.id,
                                    ) ||
                                    state.news.any(
                                      (n) => n.id == news.id && n.isFavorite,
                                    );

                                return GestureDetector(
                                  onTap: () => _onFavoriteToggle(
                                    context,
                                    news.id,
                                    isFavorited,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFD0D0D0),
                                        width: 1.01,
                                      ),
                                    ),
                                    child: Icon(
                                      isFavorited
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: isFavorited
                                          ? Colors.yellow
                                          : Colors.black,
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
                            color: textBlack.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // --- 4. IMAGEM ---
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            news.imageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
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

                        Center(
                          child: Text(
                            "Imagem ilustrativa da notícia",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: textGrey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --- 5. RESUMO ---
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

                        // --- 7. CATEGORIAS (TAGS) ---
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
                                border: Border.all(
                                  color: brandBlue.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                category,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textBlack,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 48),

                        // --- 8. NOTÍCIAS RELACIONADAS ---
                        if (news.relatedNews.isNotEmpty) ...[
                          // Título
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF9FAFB),
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              "Notícias relacionadas",
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Grid
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 24,
                                  childAspectRatio: 0.70,
                                ),
                            itemCount: news.relatedNews.length,
                            itemBuilder: (context, index) {
                              final related = news.relatedNews[index];
                              return InkWell(
                                onTap: () {
                                  final newsBloc = context.read<NewsBloc>();
                                  context.push(
                                    '/news/details',
                                    extra: {'news': related, 'bloc': newsBloc},
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            related.imageUrl,
                                            height: 120,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                  height: 120,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child:
                                              BlocBuilder<NewsBloc, NewsState>(
                                                builder: (context, state) {
                                                  final isRelFav =
                                                      state.savedNews.any(
                                                        (n) =>
                                                            n.id == related.id,
                                                      ) ||
                                                      state.news.any(
                                                        (n) =>
                                                            n.id ==
                                                                related.id &&
                                                            n.isFavorite,
                                                      );

                                                  return GestureDetector(
                                                    onTap: () =>
                                                        _onFavoriteToggle(
                                                          context,
                                                          related.id,
                                                          isRelFav,
                                                        ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6,
                                                          ),
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      child: Icon(
                                                        isRelFav
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: isRelFav
                                                            ? Colors.yellow
                                                            : Colors.black,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "BRAND: ${related.category.toUpperCase()}",
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      related.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: textBlack,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "12 horas atrás",
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // --- BOTÃO VER MAIS ---
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                _showNoMoreItemsSnackBar(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ver mais",
                                    style: GoogleFonts.inter(
                                      color: textBlack,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: textBlack,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        // [IMPORTANTE] Espaço extra dentro do padding antes do footer
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // [CORREÇÃO 3] O CustomFooter fica FORA do Padding, ocupando a largura total
                  const CustomFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
