import 'package:desafio_loomi_flutter/core/presentation/custom_footer.dart';
import 'package:desafio_loomi_flutter/core/presentation/custom_home_app_bar.dart';
import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:desafio_loomi_flutter/core/widgets/feedback_balloon.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/widgets/tags_section.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailsPage extends StatefulWidget {
  final NewsEntity news;

  const NewsDetailsPage({super.key, required this.news});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  // Favorites balloon overlay control
  bool _showBallon = false;
  String _ballonTitle = "";
  String _ballonSubtitle = "";
  Color _ballonColor = const Color(0xFF6FCF97);
  IconData _ballonIcon = Icons.check;

  // Load more loading state control
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Always fetch details from API: GET /news/{id}/details; the response body is used to build the screen.
    context.read<NewsBloc>().add(LoadNewsDetailsEvent(widget.news.id));
  }

  void _onFavoriteToggle(
    BuildContext context,
    String newsId,
    bool isCurrentlyFavorited,
  ) {
    context.read<NewsBloc>().add(ToggleFavoriteHome(newsId));

    setState(() {
      _showBallon = true;
      if (isCurrentlyFavorited) {
        _ballonTitle = "Você removeu esta Notícia dos favoritos";
        _ballonSubtitle = "";
        _ballonColor = const Color(0xFFF5222D);
        _ballonIcon = Icons.close;
      } else {
        _ballonTitle = "Você favoritou esta Notícia";
        _ballonSubtitle = "Você pode encontrá-la no perfil";
        _ballonColor = const Color(0xFF6FCF97);
        _ballonIcon = Icons.check;
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showBallon = false);
    });
  }

  void _onLoadMoreRelated() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    if (mounted) {
      setState(() => _isLoadingMore = false);
      FeedbackBalloon.showInfo(
        context,
        message: "Não há mais notícias relacionadas.",
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewsBloc>().state;
    final displayNews = state.currentDetails;
    final showError = state.detailsError != null && !state.isLoadingDetails;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomHomeAppBar(
        selectedTab: 0,
        onTabChanged: (index) {
          if (index == 1) context.push('/profile');
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (state.isLoadingDetails || displayNews == null) ...[
              showError
                  ? _buildErrorState(context)
                  : _buildLoadingState(context),
            ] else ...[
              _buildDetailsContent(context, displayNews),
            ],
            // Overlay balloon
            if (_showBallon)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: FeedbackBalloon(
                  title: _ballonTitle,
                  subtitle: _ballonSubtitle,
                  color: _ballonColor,
                  icon: _ballonIcon,
                  onClose: () => setState(() => _showBallon = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (context) {
            final padH = Responsive.horizontalPadding(context);
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: padH, vertical: 16),
              child: InkWell(
                onTap: () => context.pop(),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Voltar',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const Expanded(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.loading),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final state = context.watch<NewsBloc>().state;
    return Column(
      children: [
        Builder(
          builder: (context) {
            final padH = Responsive.horizontalPadding(context);
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: padH, vertical: 16),
              child: InkWell(
                onTap: () => context.pop(),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Voltar',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.detailsError ?? 'Erro ao carregar.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.read<NewsBloc>().add(
                      LoadNewsDetailsEvent(widget.news.id),
                    ),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsContent(BuildContext context, NewsEntity displayNews) {
    final formattedDate = DateFormat(
      "dd/MM/yyyy 'ás' HH:mm",
    ).format(DateTime.tryParse(displayNews.datePublished) ?? DateTime.now());

    return Column(
      children: [
        // Back button
        Builder(
          builder: (context) {
            final padH = Responsive.horizontalPadding(context);
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: padH, vertical: 16),
              child: InkWell(
                onTap: () => context.pop(),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Voltar',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    final padH = Responsive.horizontalPadding(context);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: padH),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Header: category and favorite
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.sectionBg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFB3D4E5),
                                  ),
                                ),
                                child: Text(
                                  displayNews.category.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSlate,
                                  ),
                                ),
                              ),
                              BlocBuilder<NewsBloc, NewsState>(
                                builder: (context, state) {
                                  final isFavorited = state.savedNews.any(
                                    (n) => n.id == displayNews.id,
                                  );
                                  return GestureDetector(
                                    onTap: () => _onFavoriteToggle(
                                      context,
                                      displayNews.id,
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
                            displayNews.title,
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
                              displayNews.imageUrl,
                              height: Responsive.imageHeightHero(context),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Resumo NortusAI block (icon + title + summary)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/assets/icon_details_nortus.png',
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Resumo ',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                    Text(
                                      'NortusAI',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  displayNews.summary,
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
                          Text(
                            displayNews.description.isNotEmpty
                                ? displayNews.description
                                : displayNews.summary,
                            style: GoogleFonts.inter(fontSize: 16, height: 1.6),
                          ),

                          // Tags (categories) section – no title
                          const SizedBox(height: 32),
                          TagsSection(
                            tags: [
                              displayNews.category.toUpperCase(),
                              "NOTÍCIAS",
                              "LEITURA",
                            ],
                          ),
                          const SizedBox(height: 48),

                          // Related news section – same style as "Mais recentes" on news page
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: padH,
                              vertical: 16,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.divider),
                                bottom: BorderSide(color: AppColors.divider),
                              ),
                              color: AppColors.sectionBg,
                            ),
                            child: Text(
                              "Notícias relacionadas",
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F343A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (displayNews.relatedNews.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  "Nenhuma notícia relacionada no momento.",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          else ...[
                            _buildRelatedGrid(context, displayNews),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: _isLoadingMore
                                    ? null
                                    : _onLoadMoreRelated,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF163C43),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: _isLoadingMore
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.loading,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                            const SizedBox(height: 48),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const CustomFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedGrid(BuildContext context, NewsEntity news) {
    final imageH = Responsive.imageHeightGrid(context);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.65,
      ),
      itemCount: news.relatedNews.length,
      itemBuilder: (context, index) {
        final related = news.relatedNews[index];
        return InkWell(
          onTap: () => context.push(
            '/news/details',
            extra: {'news': related, 'bloc': context.read<NewsBloc>()},
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: related.imageUrl,
                      height: imageH,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<NewsBloc, NewsState>(
                      builder: (context, state) {
                        final isRelFav = state.savedNews.any(
                          (n) => n.id == related.id,
                        );
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRelFav ? Icons.star : Icons.star_border,
                            size: 18,
                            color: isRelFav ? Colors.yellow : Colors.black,
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
    );
  }
}
