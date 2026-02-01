import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.title,
    required super.author,
    required super.summary,
    required super.datePublished,
    required super.imageUrl,
    required super.relatedNews,
    super.isFavorite,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String imgUrl = '';

    if (json['image'] is Map) {
      imgUrl = json['image']['src'] ?? '';
    } else if (json['imageUrl'] is String) {
      imgUrl = json['imageUrl'] ?? '';
    } else if (json['image'] is String) {
      imgUrl = json['image'] ?? '';
    }

    String authorName = 'Autor Desconhecido';
    if (json['authors'] != null && (json['authors'] as List).isNotEmpty) {
      authorName = json['authors'][0]['name'] ?? 'Autor Desconhecido';
    }

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: authorName,
      summary:
          json['description'] ?? json['summary'] ?? json['newsResume'] ?? '',
      datePublished: json['date_published'] ?? json['publishedAt'] ?? '',
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
      'summary': summary,
      'date_published': datePublished,

      'authors': [
        {'name': author},
      ],
      'image': {'src': imageUrl},
      'isFavorite': isFavorite,
      'relatedNews': relatedNews.map((e) {
        if (e is NewsModel) return e.toJson();
        return {
          'id': e.id,
          'title': e.title,
          'authors': [
            {'name': e.author},
          ],
          'summary': e.summary,
          'date_published': e.datePublished,
          'image': {'src': e.imageUrl},
        };
      }).toList(),
    };
  }
}
