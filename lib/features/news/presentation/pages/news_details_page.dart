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

  void _onFavoriteToggle(
    BuildContext context,
    String newsId,
    bool isCurrentlyFavorited,
  ) {
    context.read<NewsBloc>().add(ToggleFavoriteHome(newsId));
    if (isCurrentlyFavorited) {
      _showTopSnackBar(
        context,
        title: "Você removeu esta Notícia dos favoritos",
        subtitle: "",
        color: const Color(0xFFF5222D),
        icon: Icons.close,
      );
    } else {
      _showTopSnackBar(
        context,
        title: "Você favoritou esta Notícia",
        subtitle: "Você pode encontrá-la no perfil",
        color: const Color(0xFF6FCF97),
        icon: Icons.check,
      );
    }
  }

  void _showTopSnackBar(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final topPadding = MediaQuery.of(context).padding.top + 80;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - topPadding,
          left: 16,
          right: 16,
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: color,
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
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF1876D2);
    const textBlack = Color(0xFF0B1125);
    final formattedDate = DateFormat(
      "dd/MM/yyyy 'ás' HH:mm",
    ).format(DateTime.tryParse(news.datePublished) ?? DateTime.now());

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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: InkWell(
              onTap: () => context.pop(),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: textBlack, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Voltar',
                    style: GoogleFonts.inter(
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
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
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
                                ),
                              ),
                            ),
                            BlocBuilder<NewsBloc, NewsState>(
                              builder: (context, state) {
                                final isFavorited = state.savedNews.any(
                                  (n) => n.id == news.id,
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
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFD0D0D0),
                                      ),
                                    ),
                                    child: Icon(
                                      isFavorited
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: isFavorited
                                          ? Colors.yellow
                                          : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          news.title,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Publicado: $formattedDate',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            news.imageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            news.summary,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.5,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          news.description.isNotEmpty
                              ? news.description
                              : news.summary,
                          style: GoogleFonts.inter(fontSize: 16, height: 1.6),
                        ),
                        const SizedBox(height: 48),

                        // --- REINTRODUÇÃO DAS NOTÍCIAS RELACIONADAS ---
                        if (news.relatedNews.isNotEmpty) ...[
                          Text(
                            "Notícias relacionadas",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 24),
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
                                  context.push(
                                    '/news/details',
                                    extra: {
                                      'news': related,
                                      'bloc': context.read<NewsBloc>(),
                                    },
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
                                                  final isRelFav = state
                                                      .savedNews
                                                      .any(
                                                        (n) =>
                                                            n.id == related.id,
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
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      related.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                        ],
                      ],
                    ),
                  ),
                  const CustomFooter(), // Agora o Footer ocupa 100% da largura
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
