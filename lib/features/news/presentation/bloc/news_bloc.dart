import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

// Constante para evitar chamadas excessivas no scroll (Debounce)
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;
  int _page = 1; // Controle interno da página

  NewsBloc({required this.getNewsUseCase}) : super(const NewsState()) {
    on<NewsFetched>(
      _onNewsFetched,
      // O transformador evita que o usuário faça 10 chamadas se rolar muito rápido
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onNewsFetched(
    NewsFetched event,
    Emitter<NewsState> emit,
  ) async {
    // 1. Se já chegou no fim, não faz nada
    if (state.hasReachedMax) return;

    try {
      // 2. Se é a primeira carga (estado inicial)
      if (state.status == NewsStatus.initial) {
        final result = await getNewsUseCase(1);

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: NewsStatus.failure,
              errorMessage: "Erro ao carregar",
            ),
          ),
          (newsList) {
            _page = 2; // Prepara para a próxima
            return emit(
              state.copyWith(
                status: NewsStatus.success,
                news: newsList,
                hasReachedMax: newsList.isEmpty, // Se vier vazio, acabou
              ),
            );
          },
        );
        return;
      }

      // 3. Se é paginação (já tem dados carregados)
      final result = await getNewsUseCase(_page);

      result.fold(
        (failure) => emit(state.copyWith(status: NewsStatus.failure)),
        (newNews) {
          if (newNews.isEmpty) {
            emit(state.copyWith(hasReachedMax: true));
          } else {
            _page++;
            emit(
              state.copyWith(
                status: NewsStatus.success,
                // Junta a lista antiga com a nova
                news: List.of(state.news)..addAll(newNews),
                hasReachedMax: false,
              ),
            );
          }
        },
      );
    } catch (_) {
      emit(state.copyWith(status: NewsStatus.failure));
    }
  }
}
