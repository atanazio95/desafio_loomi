import 'package:desafio_loomi_flutter/core/presentation/custom_drawer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_footer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/core/presentation/header.dart'; // Seu Header
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<NewsBloc>();

    // Só adiciona o evento se a lista estiver vazia (primeiro carregamento)
    if (bloc.state.news.isEmpty) {
      bloc.add(const GetNewsEvent(page: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Drawer para o menu lateral
      drawer: const CustomDrawer(),

      // AppBar com abas
      appBar: CustomHomeAppBar(
        selectedTab: 0,
        onTabChanged: (index) {
          if (index == 1) context.push('/profile');
        },
      ),

      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          // Loading Inicial (Tela inteira vazia)
          if (state.isLoading && state.news.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Erro (Tela inteira vazia)
          if (state.error != null && state.news.isEmpty) {
            return Center(child: Text(state.error!));
          }

          // --- FATIAMENTO DA LISTA ---
          // Hero: Primeiros 2 itens
          final List<NewsEntity> heroNews = state.news.take(2).toList();
          // Grid: Do 3º ao 6º item
          final List<NewsEntity> gridNews = state.news.skip(2).take(4).toList();
          // Recentes: Do 7º em diante (Cresce com a paginação)
          final List<NewsEntity> recentNews = state.news.skip(6).toList();

          return SingleChildScrollView(
            // [CORREÇÃO] Padding zero aqui para o Footer encostar nas bordas
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER (Importado)
                const NewsHeader(),

                const SizedBox(height: 16),

                // --- 1. HERO SECTION (Cards Grandes) ---
                if (heroNews.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: heroNews.map((news) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _HeroNewsCard(
                            news: news,
                            onTap: () => _navigateToDetails(context, news),
                            onFavorite: () => _toggleFavorite(context, news.id),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // --- 2. GRID SECTION (Cards Pequenos) ---
                if (gridNews.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: gridNews.length,
                      itemBuilder: (context, index) {
                        final news = gridNews[index];
                        return _GridNewsCard(
                          news: news,
                          onTap: () => _navigateToDetails(context, news),
                          onFavorite: () => _toggleFavorite(context, news.id),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 32),

                // --- 3. CABEÇALHO "MAIS RECENTES" ---
                // Este container ocupa a largura total (sem padding no pai)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFEEEEEE)),
                      bottom: BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    color: Color(0xFFFAFAFA),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mais recentes",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),

                      // [ALTERAÇÃO] Botão agora é clicável com InkWell
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Funcionalidade ainda não implementada.",
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Para o clique respeitar a borda
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF0F172A)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Ver mais",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: Color(0xFF0F172A),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- 4. LISTA RECENTES ---
                if (recentNews.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recentNews.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final news = recentNews[index];
                        return _RecentNewsCard(
                          news: news,
                          onTap: () => _navigateToDetails(context, news),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 32),

                // --- 5. BOTÃO "VER MAIS" (Paginação) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56, // Altura conforme spec
                    child: OutlinedButton(
                      // Bloqueia clique durante carregamento
                      onPressed: state.isLoading
                          ? null
                          : () {
                              final newsBloc = context.read<NewsBloc>();
                              final nextPage = newsBloc.state.currentPage + 1;
                              newsBloc.add(GetNewsEvent(page: nextPage));
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF163C43)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      // Troca texto por Loading girando
                      child: state.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF163C43),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Ver mais",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF163C43),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF163C43),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // --- 6. FOOTER ---
                // Fora de qualquer Padding horizontal para ocupar tudo
                const CustomFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetails(BuildContext context, NewsEntity news) {
    final newsBloc = context.read<NewsBloc>();
    context.push('/news/details', extra: {'news': news, 'bloc': newsBloc});
  }

  void _toggleFavorite(BuildContext context, String newsId) {
    context.read<NewsBloc>().add(ToggleFavoriteHome(newsId));
  }
}

// ==========================================================
// COMPONENTES VISUAIS (Cards)
// ==========================================================

// 1. HERO CARD
class _HeroNewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _HeroNewsCard({
    required this.news,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  news.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 200, color: Colors.grey[200]),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD0D0D0),
                        width: 1.01,
                      ),
                    ),
                    child: Icon(
                      news.isFavorite ? Icons.star : Icons.star_border,
                      color: news.isFavorite ? Colors.yellow : Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            news.category.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            news.title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            news.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "12 horas atrás",
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. GRID CARD
class _GridNewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _GridNewsCard({
    required this.news,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  news.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 120, color: Colors.grey[200]),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD0D0D0),
                        width: 1.01,
                      ),
                    ),
                    child: Icon(
                      news.isFavorite ? Icons.star : Icons.star_border,
                      color: news.isFavorite ? Colors.yellow : Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "BRAND: ${news.category.toUpperCase()}",
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            news.title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              height: 1.2,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "12 horas atrás",
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. RECENT CARD
class _RecentNewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback onTap;

  const _RecentNewsCard({required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              news.imageUrl,
              height: 80,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(height: 80, width: 120, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.category.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  news.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "12 horas atrás",
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
