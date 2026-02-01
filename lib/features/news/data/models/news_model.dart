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

    String authorName = 'Loomi News';
    if (json['authors'] != null && (json['authors'] as List).isNotEmpty) {
      authorName = json['authors'][0]['name'] ?? 'Loomi News';
    }

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      author: authorName,
      summary:
          json['description'] ?? json['summary'] ?? json['newsResume'] ?? '',
      datePublished: json['publishedAt'] ?? '',
      imageUrl: imgUrl,

      relatedNews: json['relatedNews'] != null
          ? (json['relatedNews'] as List)
                .map((e) => NewsModel.fromJson(e))
                .toList()
          : [],
    );
  }
}
