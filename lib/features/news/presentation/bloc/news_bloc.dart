import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

// Constante para evitar chamadas excessivas no scroll (Debounce/Throttle)
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;

  NewsBloc({required this.getNewsUseCase}) : super(const NewsState()) {
    on<NewsFetched>(
      _onNewsFetched,
      // O transformador evita spam de eventos quando o usuário rola rápido
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onNewsFetched(
    NewsFetched event,
    Emitter<NewsState> emit,
  ) async {
    // 1. Se já chegou no fim (API retornou vazio antes), para tudo.
    if (state.hasReachedMax) return;

    try {
      // 2. Verifica se é a Primeira Carga (Lista vazia/Estado inicial)
      if (state.status == NewsStatus.initial) {
        // Pede a página 1
        final result = await getNewsUseCase(1);

        result.fold(
          (failure) => emit(
            state.copyWith(
              status: NewsStatus.failure,
              errorMessage: _mapFailureToMessage(failure),
            ),
          ),
          (news) => emit(
            state.copyWith(
              status: NewsStatus.success,
              news: news,
              hasReachedMax: false,
            ),
          ),
        );
      }
      // 3. Carga Incremental (Rolou para baixo)
      else {
        // Cálculo da próxima página baseado no tamanho atual da lista
        // Ex: 10 itens ~/ 10 = 1.  1 + 1 = Página 2.
        final nextPage = (state.news.length ~/ 10) + 1;

        final result = await getNewsUseCase(nextPage);

        result.fold(
          (failure) => emit(state.copyWith(status: NewsStatus.failure)),
          (newNews) {
            // Se a lista veio vazia, significa que acabou as notícias
            emit(
              newNews.isEmpty
                  ? state.copyWith(hasReachedMax: true)
                  : state.copyWith(
                      status: NewsStatus.success,
                      news: List.of(state.news)..addAll(newNews),
                      hasReachedMax: false,
                    ),
            );
          },
        );
      }
    } catch (_) {
      // Captura erros genéricos não tratados pelo UseCase
      emit(state.copyWith(status: NewsStatus.failure));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Erro no servidor. Tente novamente.';
      case CacheFailure:
        return 'Erro ao carregar dados locais.';
      default:
        return 'Erro desconhecido.';
    }
  }
}
