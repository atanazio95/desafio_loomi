import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.author,
    required super.title,
    required super.summary,
    required super.imageUrl,
    required super.datePublished,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    // 1. Extração do Autor
    String authorName = 'Autor Desconhecido';
    if (json['authors'] != null && (json['authors'] as List).isNotEmpty) {
      authorName = json['authors'][0]['name'] ?? authorName;
    }

    // 2. Extração da Imagem
    String img = 'https://via.placeholder.com/300x200.png?text=No+Image';
    if (json['image'] != null && json['image'] is Map) {
      img = json['image']['src'] ?? img;
    }

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Sem Título',
      summary: json['summary'] ?? '', // Mapeamento direto e único
      author: authorName,
      imageUrl: img,
      datePublished: json['date_published'] ?? '', // Mapeamento fiel
    );
  }
}
