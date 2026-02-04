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
      category: 'Tech',
      author: 'Autor',
      description: 'Desc',
      summary: 'Resumo',
      datePublished: '2026-01-01',
      imageUrl: 'https://example.com/img.png',
      relatedNews: [],
      isFavorite: false,
    ),
  ];

  group('GetNewsUseCase', () {
    test(
      'gets news list from repository on success',
      () async {
        when(
          () => mockNewsRepository.getNews(1),
        ).thenAnswer((_) async => const Right(tNewsList));

        final result = await usecase(1);

        expect(result, const Right(tNewsList));
        verify(() => mockNewsRepository.getNews(1)).called(1);
      },
    );

    test('returns Left(ServerFailure) when repository fails', () async {
      when(
        () => mockNewsRepository.getNews(1),
      ).thenAnswer((_) async => Left(ServerFailure()));

      final result = await usecase(1);

      expect(result, Left(ServerFailure()));
      verify(() => mockNewsRepository.getNews(1)).called(1);
    });
  });
}
