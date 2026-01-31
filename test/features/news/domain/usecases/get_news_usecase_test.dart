import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late GetNewsUseCase usecase;
  late MockNewsRepository mockNewsRepository;
  setUp(() {
    mockNewsRepository = MockNewsRepository();
    usecase = GetNewsUseCase(mockNewsRepository);
  });
  const tNewsList = [
    NewsEntity(
      id: '1',
      title: 'Teste',
      summary: 'Resumo',
      imageUrl: 'img.png',
      datePublished: '2026-01-01',
      author: 'Jeorge',
    ),
  ];

  test(
    'deve obter lista de noticias do repositorio quando for sucesso',
    () async {
      when(
        () => mockNewsRepository.getNews(1),
      ).thenAnswer((_) async => Right(tNewsList));

      final result = await usecase(1);
      expect(result, const Right(tNewsList));
      verify(() => mockNewsRepository.getNews(1)).called(1);
      verifyNoMoreInteractions(mockNewsRepository);
    },
  );

  test('deve retornar uma Failure quando o repositório falhar', () async {
    // ARRANGE
    // Agora simulamos um erro (ServerFailure)
    when(
      () => mockNewsRepository.getNews(1),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // ACT
    final result = await usecase(1);

    // ASSERT
    expect(result, Left(ServerFailure()));
    verify(() => mockNewsRepository.getNews(1)).called(1);
  });
}
