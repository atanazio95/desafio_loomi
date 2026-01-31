// lib/features/news/domain/entities/news_entity.dart
import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String author;
  final String title;
  final String summary; // Substitui description e content
  final String imageUrl; // Nome mais limpo que urlToImage
  final String datePublished; // Mais fiel ao date_published da API

  const NewsEntity({
    required this.id,
    required this.author,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.datePublished,
  });

  @override
  // Removemos content e description do props também
  List<Object?> get props => [id, title, datePublished];
}
