import 'package:desafio_loomi_flutter/core/presentation/custom_drawer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_footer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/core/presentation/header.dart';
import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:desafio_loomi_flutter/core/widgets/feedback_balloon.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/grid_news_card.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/hero_news_card.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/load_more_button.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/recent_news_card.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/ver_mais_button.dart';
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
      backgroundColor: AppColors.surfaceWhite,
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
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                                      color: AppColors.categoryGray,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Resultado da busca por ',
                                      ),
                                      TextSpan(
                                        text: '"${state.searchQuery}"',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: Responsive.footerTopSpacing(context),
                            ),
                            const CustomFooter(),
                          ],
                        ),
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
          style: GoogleFonts.inter(color: AppColors.labelHint),
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
                child: HeroNewsCard(
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
                    child: HeroNewsCard(
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
            itemBuilder: (context, index) => GridNewsCard(
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
              top: BorderSide(color: AppColors.divider),
              bottom: BorderSide(color: AppColors.divider),
            ),
            color: AppColors.sectionBg,
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
              VerMaisButton(
                onTap: () => FeedbackBalloon.showInfo(
                  context,
                  message: "Funcionalidade em breve.",
                ),
              ),
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
            itemBuilder: (context, index) => RecentNewsCard(
              news: recentNews[index],
              onTap: () => _navigateToDetails(context, recentNews[index]),
            ),
          ),
        ),

        // Load more button
        Padding(
          padding: EdgeInsets.all(padH),
          child: LoadMoreButton(
            isLoading: state.isLoading,
            onPressed: () => context.read<NewsBloc>().add(
              GetNewsEvent(page: state.currentPage + 1),
            ),
          ),
        ),
      ],
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
