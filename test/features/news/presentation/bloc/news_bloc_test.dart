import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_details_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNewsUseCase extends Mock implements GetNewsUseCase {}

class MockGetNewsDetailsUseCase extends Mock implements GetNewsDetailsUseCase {}

void main() {
  late NewsBloc bloc;
  late MockGetNewsUseCase mockGetNewsUseCase;
  late MockGetNewsDetailsUseCase mockGetNewsDetailsUseCase;

  setUp(() {
    mockGetNewsUseCase = MockGetNewsUseCase();
    mockGetNewsDetailsUseCase = MockGetNewsDetailsUseCase();
    bloc = NewsBloc(
      getNewsUseCase: mockGetNewsUseCase,
      getNewsDetailsUseCase: mockGetNewsDetailsUseCase,
    );
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

  const tNewsDetails = NewsEntity(
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
  );

  group('NewsBloc', () {
    test('initial state is default NewsState', () {
      expect(bloc.state, const NewsState());
    });

    group('GetNewsEvent', () {
      blocTest<NewsBloc, NewsState>(
        'emits [loading, loaded] when getNews succeeds',
        build: () {
          when(() => mockGetNewsUseCase(1))
              .thenAnswer((_) async => const Right(tNewsList));
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
        verify: (_) => verify(() => mockGetNewsUseCase(1)).called(1),
      );

      blocTest<NewsBloc, NewsState>(
        'emits [loading, error] when getNews fails',
        build: () {
          when(() => mockGetNewsUseCase(1))
              .thenAnswer((_) async => Left(ServerFailure()));
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
    });

    group('SearchNewsEvent', () {
      blocTest<NewsBloc, NewsState>(
        'atualiza searchQuery no estado',
        build: () => bloc,
        act: (b) => b.add(const SearchNewsEvent('tec')),
        expect: () => [
          const NewsState(searchQuery: 'tec'),
        ],
      );
    });

    group('ToggleFavoriteHome', () {
      blocTest<NewsBloc, NewsState>(
        'updates savedNews and news when item is favorited',
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

    group('LoadNewsDetailsEvent', () {
      blocTest<NewsBloc, NewsState>(
        'emite [loadingDetails, currentDetails] quando getNewsDetails tem sucesso',
        build: () {
          when(() => mockGetNewsDetailsUseCase('1'))
              .thenAnswer((_) async => const Right(tNewsDetails));
          return bloc;
        },
        act: (b) => b.add(const LoadNewsDetailsEvent('1')),
        expect: () => [
          NewsState(
            lastRequestedDetailsId: '1',
            isLoadingDetails: true,
            detailsError: null,
          ),
          NewsState(
            currentDetails: tNewsDetails,
            lastRequestedDetailsId: '1',
            isLoadingDetails: false,
            detailsError: null,
          ),
        ],
        verify: (_) => verify(() => mockGetNewsDetailsUseCase('1')).called(1),
      );

      blocTest<NewsBloc, NewsState>(
        'emits [loadingDetails, detailsError] when getNewsDetails fails',
        build: () {
          when(() => mockGetNewsDetailsUseCase('1'))
              .thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (b) => b.add(const LoadNewsDetailsEvent('1')),
        expect: () => [
          NewsState(
            lastRequestedDetailsId: '1',
            isLoadingDetails: true,
            detailsError: null,
          ),
          NewsState(
            lastRequestedDetailsId: '1',
            isLoadingDetails: false,
            detailsError: 'Não foi possível carregar os detalhes.',
          ),
        ],
      );
    });
  });
}
