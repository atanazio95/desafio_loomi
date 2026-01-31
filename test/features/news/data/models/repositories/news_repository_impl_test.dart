import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:desafio_loomi_flutter/features/news/data/repositories/news_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Dublê do DataSource
class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

void main() {
  late NewsRepositoryImpl repository;
  late MockNewsRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockNewsRemoteDataSource();
    repository = NewsRepositoryImpl(dataSource: mockRemoteDataSource);
  });

  // Dados Fake
  const tNewsModelList = [
    NewsModel(
      id: '1',
      title: 'Teste Repo',
      summary: 'Resumo',
      imageUrl: 'img.png',
      datePublished: '2026-01-01',
      author: 'Jeorge',
    ),
  ];

  // Como NewsModel estende NewsEntity, podemos usar a mesma lista para comparar
  final List<NewsEntity> tNewsEntityList = tNewsModelList;

  group('getNews', () {
    test(
      'deve retornar dados (Right) quando a chamada ao datasource for bem sucedida',
      () async {
        // ARRANGE
        when(
          () => mockRemoteDataSource.getNews(1),
        ).thenAnswer((_) async => tNewsModelList);

        // ACT
        final result = await repository.getNews(1);

        // ASSERT
        // Verifica se o lado Direito (Right) contém a lista de Entidades
        expect(result, equals(Right(tNewsEntityList)));
        verify(() => mockRemoteDataSource.getNews(1)).called(1);
      },
    );

    test(
      'deve retornar ServerFailure (Left) quando o datasource lançar uma ServerException',
      () async {
        // ARRANGE
        // Simulamos que o servidor explodiu (Exception)
        when(() => mockRemoteDataSource.getNews(1)).thenThrow(ServerFailure());

        // ACT
        final result = await repository.getNews(1);

        // ASSERT
        // Verifica se o repositório capturou a exceção e devolveu a falha correta
        expect(result, equals(Left(ServerFailure())));
        verify(() => mockRemoteDataSource.getNews(1)).called(1);
      },
    );
  });
}
