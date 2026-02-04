import 'package:cached_network_image/cached_network_image.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hero-style news card (featured at top of list or in search results).
class HeroNewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const HeroNewsCard({
    super.key,
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
                child: CachedNetworkImage(
                  imageUrl: news.imageUrl,
                  height: Responsive.imageHeightHeroCard(context),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
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
