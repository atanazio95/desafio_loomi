import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String author;
  final String summary;
  final String datePublished;
  final String imageUrl;
  final List<NewsEntity> relatedNews;
  final bool isFavorite;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.summary,
    required this.datePublished,
    required this.imageUrl,
    required this.relatedNews,
    this.isFavorite = false,
  });

  // O método copyWith permite atualizar campos específicos (como isFavorite)
  // sem perder o restante dos dados da entidade.
  NewsEntity copyWith({
    String? id,
    String? title,
    String? category,
    String? author,
    String? summary,
    String? datePublished,
    String? imageUrl,
    List<NewsEntity>? relatedNews,
    bool? isFavorite,
  }) {
    return NewsEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      author: author ?? this.author,
      summary: summary ?? this.summary,
      datePublished: datePublished ?? this.datePublished,
      imageUrl: imageUrl ?? this.imageUrl,
      relatedNews: relatedNews ?? this.relatedNews,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    author,
    summary,
    datePublished,
    imageUrl,
    relatedNews,
    isFavorite,
  ];
}
