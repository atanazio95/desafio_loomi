import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String title;
  final String author;
  final String summary;
  final String datePublished;
  final String imageUrl;
  final List<NewsEntity> relatedNews;
  final bool isFavorite; // Campo novo

  const NewsEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.summary,
    required this.datePublished,
    required this.imageUrl,
    this.relatedNews = const [],
    this.isFavorite = false,
  });

  // --- AQUI ESTÁ A FUNÇÃO QUE FALTAVA ---
  NewsEntity copyWith({
    String? id,
    String? title,
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
    author,
    summary,
    datePublished,
    imageUrl,
    relatedNews,
    isFavorite, // Importante estar aqui para o Bloc detectar a mudança
  ];
}
