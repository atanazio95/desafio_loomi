import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tJson = {
    'id': '123',
    'title': 'Flutter é incrível',
    'summary': 'Um resumo sobre Flutter',
    'description': 'Conteúdo completo',
    'publishedAt': '2026-01-31T10:00:00Z',
    'authors': [
      {'name': 'Jeorge Atanazio'},
    ],
    'image': {'src': 'https://example.com/image.png'},
    'categories': ['Tech'],
  };

  const tNewsModel = NewsModel(
    id: '123',
    title: 'Flutter é incrível',
    category: 'Tech',
    author: 'Jeorge Atanazio',
    summary: 'Um resumo sobre Flutter',
    description: 'Conteúdo completo',
    datePublished: '2026-01-31T10:00:00Z',
    imageUrl: 'https://example.com/image.png',
    relatedNews: [],
    isFavorite: false,
  );

  group('NewsModel', () {
    test('is a subclass of NewsEntity', () {
      expect(tNewsModel, isA<NewsEntity>());
    });

    test(
      'fromJson returns valid NewsModel with nested structure',
      () {
        final result = NewsModel.fromJson(tJson);

        expect(result.id, '123');
        expect(result.title, 'Flutter é incrível');
        expect(result.category, 'Tech');
        expect(result.author, 'Jeorge Atanazio');
        expect(result.summary, 'Um resumo sobre Flutter');
        expect(result.description, 'Conteúdo completo');
        expect(result.datePublished, '2026-01-31T10:00:00Z');
        expect(result.imageUrl, 'https://example.com/image.png');
        expect(result.relatedNews, isEmpty);
        expect(result.isFavorite, false);
      },
    );

    test(
      'fromJson deve retornar valores padrão quando JSON vazio',
      () {
        final result = NewsModel.fromJson({});

        expect(result.author, 'Autor Desconhecido');
        expect(result.isFavorite, false);
        expect(result.relatedNews, isEmpty);
      },
    );

    test('toJson returns Map with id and title', () {
      final result = tNewsModel.toJson();

      expect(result['id'], '123');
      expect(result['title'], 'Flutter é incrível');
    });
  });
}
