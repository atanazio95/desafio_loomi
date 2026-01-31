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
      summary: 'Resumo',
      imageUrl: 'img.png',
      datePublished: '2026-01-01',
      author: 'Jeorge',
    ),
  ];

  group('NewsBloc', () {
    test('o estado inicial deve ser NewsState padrão (status initial)', () {
      // Como você definiu valores padrão no construtor, comparamos com uma instância vazia
      expect(bloc.state, const NewsState());
    });

    blocTest<NewsBloc, NewsState>(
      'deve emitir [status: success, news: lista] quando os dados forem carregados',
      build: () {
        when(
          () => mockGetNewsUseCase(1),
        ).thenAnswer((_) async => const Right(tNewsList));
        return bloc;
      },
      act: (bloc) => bloc.add(NewsFetched()),
      expect: () => [
        // Aqui está a mágica: Criamos o objeto EXATAMENTE como esperamos que ele fique
        const NewsState(
          status: NewsStatus.success,
          news: tNewsList,
          hasReachedMax: false,
          errorMessage: '',
        ),
      ],
      verify: (_) {
        verify(() => mockGetNewsUseCase(1)).called(1);
      },
    );

    blocTest<NewsBloc, NewsState>(
      'deve emitir [status: failure] quando o UseCase falhar',
      build: () {
        when(
          () => mockGetNewsUseCase(1),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(NewsFetched()),
      expect: () => [
        // Esperamos o estado de erro com a mensagem
        const NewsState(
          status: NewsStatus.failure,
          news: [], // Lista vazia (padrão)
          errorMessage:
              "Erro no servidor. Tente novamente.", // Ou a mensagem que seu Bloc define
        ),
      ],
    );
  });
}
