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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Não há mais notícias relacionadas."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF1876D2);
    const textBlack = Color(0xFF0B1125);
    final formattedDate = DateFormat(
      "dd/MM/yyyy 'ás' HH:mm",
    ).format(DateTime.tryParse(widget.news.datePublished) ?? DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomHomeAppBar(
        selectedTab: 0,
        onTabChanged: (index) {
          if (index == 1) context.push('/profile');
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Back button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: brandBlue.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    widget.news.category.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                BlocBuilder<NewsBloc, NewsState>(
                                  builder: (context, state) {
                                    final isFavorited = state.savedNews.any(
                                      (n) => n.id == widget.news.id,
                                    );
                                    return GestureDetector(
                                      onTap: () => _onFavoriteToggle(
                                        context,
                                        widget.news.id,
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
                              widget.news.title,
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
                                widget.news.imageUrl,
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
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Text(
                                widget.news.summary,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              widget.news.description.isNotEmpty
                                  ? widget.news.description
                                  : widget.news.summary,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),

                            // Categories section
                            const SizedBox(height: 32),
                            _buildTagsSection(),
                            const SizedBox(height: 48),

                            // Related news section
                            if (widget.news.relatedNews.isNotEmpty) ...[
                              Text(
                                "Notícias relacionadas",
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildRelatedGrid(context),
                              const SizedBox(height: 32),

                              // See more button
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
                                            color: Color(0xFF163C43),
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
                      ),

                      const CustomFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Overlay balloon
          if (_showBallon)
            Positioned(
              top: 10,
              left: 16,
              right: 16,
              child: _TopBallonWidget(
                title: _ballonTitle,
                subtitle: _ballonSubtitle,
                color: _ballonColor,
                icon: _ballonIcon,
                onClose: () => setState(() => _showBallon = false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categorias",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12, // Horizontal spacing between tags
          runSpacing: 12, // Vertical spacing when wrapping
          children: [
            // Main category tag
            _buildTagChip(widget.news.category.toUpperCase()),

            // Static tags for example (or from API)
            _buildTagChip("NOTÍCIAS"),
            _buildTagChip("LEITURA"),
          ],
        ),
      ],
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Very light gray
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildRelatedGrid(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.65,
      ),
      itemCount: widget.news.relatedNews.length,
      itemBuilder: (context, index) {
        final related = widget.news.relatedNews[index];
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
                    child: Image.network(
                      related.imageUrl,
                      height: 120,
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

// Custom balloon widget
class _TopBallonWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onClose;

  const _TopBallonWidget({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: onClose,
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
