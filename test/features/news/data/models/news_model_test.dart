import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tJson = {
    "id": "123",
    "title": "Flutter é incrível",
    "summary": "Um resumo sobre Flutter",
    "date_published": "2026-01-31T10:00:00Z",
    "authors": [
      {"name": "Jeorge Atanazio"},
    ],
    "image": {"src": "https://example.com/image.png"},
  };

  const tNewsModel = NewsModel(
    id: "123",
    title: "Flutter é incrível",
    summary: "Um resumo sobre Flutter",
    datePublished: "2026-01-31T10:00:00Z",
    author: "Jeorge Atanazio",
    imageUrl: "https://example.com/image.png",
    relatedNews: [],
  );

  group('NewsModel', () {
    test('deve ser uma subclasse de NewsEntity', () async {
      // Assert
      expect(tNewsModel, isA<NewsEntity>());
    });

    test(
      'deve retornar um modelo válido quando o JSON for fornecido corretamente (com estrutura aninhada)',
      () async {
        // Act (Ação: Converter)
        final result = NewsModel.fromJson(tJson);

        // Assert (Verificação)
        expect(result, tNewsModel);
      },
    );

    test(
      'deve retornar valores padrão quando o JSON vier vazio ou nulo',
      () async {
        // Arrange
        final Map<String, dynamic> emptyJson = {};

        // Act
        final result = NewsModel.fromJson(emptyJson);

        // Assert
        expect(result.author, 'Autor Desconhecido');
        expect(
          result.imageUrl,
          contains('via.placeholder.com'),
        ); // Checa se pegou o placeholder
      },
    );
  });
}
