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
    isFavorite: false, // Adicionado para refletir a nova estrutura
  );

  group('NewsModel', () {
    test('deve ser uma subclasse de NewsEntity', () async {
      // Assert
      expect(tNewsModel, isA<NewsEntity>());
    });

    test(
      'deve retornar um modelo válido quando o JSON for fornecido corretamente (com estrutura aninhada)',
      () async {
        // Act
        final result = NewsModel.fromJson(tJson);

        // Assert
        expect(result, tNewsModel);
        // Verifica especificamente o favorito inicial
        expect(result.isFavorite, false);
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
          result.isFavorite,
          false,
        ); // Favorito deve ser sempre falso ao vir da API
        expect(result.imageUrl, contains(''));
      },
    );

    test('deve converter o modelo para um JSON válido (toJson)', () {
      // Act
      final result = tNewsModel.toJson();

      // Assert
      // O toJson deve refletir a estrutura que seu repositório/cache espera
      expect(result["id"], "123");
      expect(result["title"], "Flutter é incrível");
    });
  });
}
