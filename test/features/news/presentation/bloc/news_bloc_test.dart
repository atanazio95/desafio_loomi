// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:desafio_loomi_flutter/core/services/favorites_manager.dart'; // Import necessário
// import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
// import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
// import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
// import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
// import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockGetNewsUseCase extends Mock implements GetNewsUseCase {}

// class MockFavoritesManager extends Mock
//     implements FavoritesManager {} // Mock do Manager

// void main() {
//   late NewsBloc bloc;
//   late MockGetNewsUseCase mockGetNewsUseCase;
//   late MockFavoritesManager mockFavoritesManager;

//   setUp(() {
//     mockGetNewsUseCase = MockGetNewsUseCase();
//     mockFavoritesManager = MockFavoritesManager();

//     // Injetamos o mock no lugar do null
//     bloc = NewsBloc(
//       getNewsUseCase: mockGetNewsUseCase,
//       favoritesManager: mockFavoritesManager,
//     );
//   });

//   tearDown(() {
//     bloc.close();
//   });

//   const tNewsList = [
//     NewsEntity(
//       id: '1',
//       title: 'Teste BLoC',
//       summary: 'Resumo',
//       imageUrl: 'img.png',
//       datePublished: '2026-01-01',
//       author: 'Jeorge',
//       isFavorite: false, // Importante definir no teste
//     ),
//   ];

//   group('NewsBloc', () {
//     test('o estado inicial deve ser NewsState padrão (status initial)', () {
//       expect(bloc.state, const NewsState());
//     });

//     blocTest<NewsBloc, NewsState>(
//       'deve emitir [status: success] com favoritos mapeados quando os dados forem carregados',
//       build: () {
//         // Simulamos que a API retorna a lista
//         when(
//           () => mockGetNewsUseCase(1),
//         ).thenAnswer((_) async => const Right(tNewsList));

//         // Simulamos que o Manager diz que a notícia NÃO é favorita
//         when(() => mockFavoritesManager.isFavorite(any())).thenReturn(false);

//         return bloc;
//       },
//       act: (bloc) => bloc.add(NewsFetched()),
//       expect: () => [
//         const NewsState(
//           status: NewsStatus.success,
//           news: tNewsList, // A lista aqui já deve estar mapeada pelo Bloc
//           hasReachedMax: false,
//           errorMessage: '',
//         ),
//       ],
//       verify: (_) {
//         verify(() => mockGetNewsUseCase(1)).called(1);
//         verify(() => mockFavoritesManager.isFavorite('1')).called(1);
//       },
//     );

//     blocTest<NewsBloc, NewsState>(
//       'deve emitir [status: success] refletindo o favorito verdadeiro do manager',
//       build: () {
//         when(
//           () => mockGetNewsUseCase(1),
//         ).thenAnswer((_) async => const Right(tNewsList));

//         // Simulamos que o Manager diz que a notícia É favorita (true)
//         when(() => mockFavoritesManager.isFavorite('1')).thenReturn(true);

//         return bloc;
//       },
//       act: (bloc) => bloc.add(NewsFetched()),
//       expect: () => [
//         NewsState(
//           status: NewsStatus.success,
//           news: [
//             tNewsList[0].copyWith(isFavorite: true),
//           ], // Esperamos true no estado
//           hasReachedMax: false,
//         ),
//       ],
//     );
//   });
// }
