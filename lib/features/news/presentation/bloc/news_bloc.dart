import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

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
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onNewsFetched(
    NewsFetched event,
    Emitter<NewsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == NewsStatus.initial) {
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
      } else {
        final nextPage = (state.news.length ~/ 10) + 1;

        final result = await getNewsUseCase(nextPage);

        result.fold(
          (failure) => emit(state.copyWith(status: NewsStatus.failure)),
          (newNews) {
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
