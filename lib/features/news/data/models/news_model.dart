import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.title,
    required super.category,
    required super.author,
    required super.summary,
    required super.datePublished,
    required super.imageUrl,
    required super.relatedNews,
    super.isFavorite,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    // Tratamento de Imagem
    String imgUrl = '';
    if (json['image'] is Map) {
      imgUrl = json['image']['src'] ?? '';
    } else if (json['imageUrl'] is String) {
      imgUrl = json['imageUrl'];
    }

    // Tratamento de Autor
    String authorName = 'Autor Desconhecido';
    if (json['authors'] != null && (json['authors'] as List).isNotEmpty) {
      authorName = json['authors'][0]['name'] ?? 'Autor Desconhecido';
    }

    // Tratamento de Categoria
    String categoryName = 'Geral';
    if (json['categories'] != null && (json['categories'] as List).isNotEmpty) {
      categoryName = json['categories'][0].toString();
    }

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      category: categoryName,
      author: authorName,
      summary: json['summary'] ?? json['description'] ?? '',
      datePublished: json['publishedAt'] ?? json['date_published'] ?? '',
      imageUrl: imgUrl,
      relatedNews: json['relatedNews'] != null
          ? (json['relatedNews'] as List)
                .map((e) => NewsModel.fromJson(e))
                .toList()
          : [],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categories': [category],
      'summary': summary,
      'publishedAt': datePublished,
      'authors': [
        {'name': author},
      ],
      'image': {'src': imageUrl},
      'isFavorite': isFavorite,
      'relatedNews': relatedNews.map((e) {
        // Se for model, usa o toJson dele, se for Entity, mapeia manualmente
        if (e is NewsModel) return e.toJson();
        return {
          'id': e.id,
          'title': e.title,
          'categories': [e.category],
          'summary': e.summary,
          'publishedAt': e.datePublished,
          'authors': [
            {'name': e.author},
          ],
          'image': {'src': e.imageUrl},
        };
      }).toList(),
    };
  }
}
