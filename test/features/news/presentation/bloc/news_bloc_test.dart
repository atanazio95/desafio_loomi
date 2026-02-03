import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNewsUseCase extends Mock implements GetNewsUseCase {}

void main() {
  late NewsBloc bloc;
  late MockGetNewsUseCase mockGetNewsUseCase;

  setUp(() {
    mockGetNewsUseCase = MockGetNewsUseCase();
    bloc = NewsBloc(getNewsUseCase: mockGetNewsUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tNewsList = [
    NewsEntity(
      id: '1',
      title: 'Teste BLoC',
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

  group('NewsBloc', () {
    test('estado inicial é NewsState padrão', () {
      expect(bloc.state, const NewsState());
    });

    blocTest<NewsBloc, NewsState>(
      'emite estado com news e isLoading false quando GetNewsEvent(1) tem sucesso',
      build: () {
        when(
          () => mockGetNewsUseCase(1),
        ).thenAnswer((_) async => const Right(tNewsList));
        return bloc;
      },
      act: (b) => b.add(const GetNewsEvent(page: 1)),
      expect: () => [
        const NewsState(isLoading: true, error: null),
        NewsState(
          isLoading: false,
          news: tNewsList,
          currentPage: 1,
        ),
      ],
      verify: (_) {
        verify(() => mockGetNewsUseCase(1)).called(1);
      },
    );

    blocTest<NewsBloc, NewsState>(
      'emite estado com error quando GetNewsEvent falha',
      build: () {
        when(
          () => mockGetNewsUseCase(1),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (b) => b.add(const GetNewsEvent(page: 1)),
      expect: () => [
        const NewsState(isLoading: true, error: null),
        const NewsState(
          isLoading: false,
          error: 'Erro ao carregar notícias.',
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'SearchNewsEvent atualiza searchQuery no estado',
      build: () => bloc,
      act: (b) => b.add(const SearchNewsEvent('tec')),
      expect: () => [
        const NewsState(searchQuery: 'tec'),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'ToggleFavoriteHome atualiza savedNews e news quando item é favoritado',
      build: () => bloc,
      seed: () => NewsState(news: tNewsList),
      act: (b) => b.add(const ToggleFavoriteHome('1')),
      expect: () => [
        NewsState(
          news: [
            const NewsEntity(
              id: '1',
              title: 'Teste BLoC',
              category: 'Tech',
              author: 'Autor',
              description: 'Desc',
              summary: 'Resumo',
              datePublished: '2026-01-01',
              imageUrl: 'https://example.com/img.png',
              relatedNews: [],
              isFavorite: true,
            ),
          ],
          savedNews: [
            const NewsEntity(
              id: '1',
              title: 'Teste BLoC',
              category: 'Tech',
              author: 'Autor',
              description: 'Desc',
              summary: 'Resumo',
              datePublished: '2026-01-01',
              imageUrl: 'https://example.com/img.png',
              relatedNews: [],
              isFavorite: true,
            ),
          ],
        ),
      ],
    );
  });
}
