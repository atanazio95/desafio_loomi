import 'package:desafio_loomi_flutter/core/presentation/custom_drawer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_footer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/core/presentation/header.dart';
import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
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
    if (bloc.state.news.isEmpty) {
      bloc.add(const GetNewsEvent(page: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: CustomHomeAppBar(
        selectedTab: 0,
        onTabChanged: (index) {
          if (index == 1) context.push('/profile');
        },
      ),
      body: SafeArea(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state.isLoading && state.news.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.loading),
              );
            }

            if (state.error != null && state.news.isEmpty) {
              return Center(child: Text(state.error!));
            }

            final isSearching = state.searchQuery.isNotEmpty;
            final displayList = state.displayNews;
            final padH = Responsive.horizontalPadding(context);

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const NewsHeader(),

                            if (isSearching)
                              Padding(
                                padding: EdgeInsets.fromLTRB(padH, 24, padH, 8),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: const Color(0xFF64748B),
                                    ),
                                    children: [
                                      const TextSpan(text: 'Resultado da busca por '),
                                      TextSpan(
                                        text: '"${state.searchQuery}"',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            if (isSearching)
                              _buildSearchResults(context, displayList)
                            else
                              _buildComplexLayout(context, state),
                          ],
                        ),
                        const CustomFooter(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, List<NewsEntity> results) {
    if (results.isEmpty) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: Text(
          "Nenhuma notícia encontrada.",
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    final padH = Responsive.horizontalPadding(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padH),
      child: Column(
        children: results
            .map(
              (news) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _HeroNewsCard(
                  news: news,
                  onTap: () => _navigateToDetails(context, news),
                  onFavorite: () => _toggleFavorite(context, news.id),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildComplexLayout(BuildContext context, NewsState state) {
    final List<NewsEntity> heroNews = state.news.take(2).toList();
    final List<NewsEntity> gridNews = state.news.skip(2).take(4).toList();
    final List<NewsEntity> recentNews = state.news.skip(6).toList();
    final padH = Responsive.horizontalPadding(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padH),
          child: Column(
            children: heroNews
                .map(
                  (news) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _HeroNewsCard(
                      news: news,
                      onTap: () => _navigateToDetails(context, news),
                      onFavorite: () => _toggleFavorite(context, news.id),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: padH),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.65,
            ),
            itemCount: gridNews.length,
            itemBuilder: (context, index) => _GridNewsCard(
              news: gridNews[index],
              onTap: () => _navigateToDetails(context, gridNews[index]),
              onFavorite: () => _toggleFavorite(context, gridNews[index].id),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Recent news section header
        Container(
          padding: EdgeInsets.symmetric(horizontal: padH, vertical: 16),
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
                ),
              ),
              _buildVerMaisHeader(context),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Recent news list
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padH),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: recentNews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) => _RecentNewsCard(
              news: recentNews[index],
              onTap: () => _navigateToDetails(context, recentNews[index]),
            ),
          ),
        ),

        // Load more button
        Padding(
          padding: EdgeInsets.all(padH),
          child: _buildPaginationButton(context, state),
        ),
      ],
    );
  }

  Widget _buildVerMaisHeader(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Funcionalidade em breve."))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0F172A)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Text("Ver mais", style: TextStyle(fontSize: 12)),
            Icon(Icons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationButton(BuildContext context, NewsState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: state.isLoading
            ? null
            : () {
                context.read<NewsBloc>().add(
                  GetNewsEvent(page: state.currentPage + 1),
                );
              },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF163C43)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: state.isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.loading,
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ver mais"),
                  SizedBox(width: 10),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, NewsEntity news) {
    context.push(
      '/news/details',
      extra: {'news': news, 'bloc': context.read<NewsBloc>()},
    );
  }

  void _toggleFavorite(BuildContext context, String newsId) {
    context.read<NewsBloc>().add(ToggleFavoriteHome(newsId));
  }
}

// Hero news card (featured at top)
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
                  height: Responsive.imageHeightHeroCard(context),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: Responsive.imageHeightHeroCard(context),
                    color: Colors.grey[200],
                  ),
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

// Grid news card (2-column layout)
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
                  height: Responsive.imageHeightGrid(context),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: Responsive.imageHeightGrid(context),
                    color: Colors.grey[200],
                  ),
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

// Recent news list item card
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
              height: Responsive.imageHeightRecentThumb(context),
              width: Responsive.imageWidthRecentThumb(context),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: Responsive.imageHeightRecentThumb(context),
                width: Responsive.imageWidthRecentThumb(context),
                color: Colors.grey[200],
              ),
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
