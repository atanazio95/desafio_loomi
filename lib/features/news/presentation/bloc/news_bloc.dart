// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/core/services/favorites_manager.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;
  final FavoritesManager favoritesManager;

  NewsBloc({required this.getNewsUseCase, required this.favoritesManager})
    : super(const NewsState()) {
    on<NewsFetched>(_onNewsFetched);

    // Evento para o clique no coração do Card
    on<ToggleFavoriteHome>(_onToggleFavoriteHome);

    // ADICIONADO: Evento para sincronizar ao voltar da tela de detalhes
    on<RefreshFavorites>(_onRefreshFavorites);
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
          (news) {
            final newsWithFavs = news.map((n) {
              return n.copyWith(isFavorite: favoritesManager.isFavorite(n.id));
            }).toList();

            emit(
              state.copyWith(
                status: NewsStatus.success,
                news: newsWithFavs,
                hasReachedMax: false,
              ),
            );
          },
        );
      } else {
        final nextPage = (state.news.length ~/ 10) + 1;
        final result = await getNewsUseCase(nextPage);

        result.fold(
          (failure) => emit(state.copyWith(status: NewsStatus.failure)),
          (newNews) {
            if (newNews.isEmpty) {
              emit(state.copyWith(hasReachedMax: true));
            } else {
              final newNewsWithFavs = newNews.map((n) {
                return n.copyWith(
                  isFavorite: favoritesManager.isFavorite(n.id),
                );
              }).toList();

              emit(
                state.copyWith(
                  status: NewsStatus.success,
                  news: List.of(state.news)..addAll(newNewsWithFavs),
                  hasReachedMax: false,
                ),
              );
            }
          },
        );
      }
    } catch (_) {
      emit(state.copyWith(status: NewsStatus.failure));
    }
  }

  Future<void> _onToggleFavoriteHome(
    ToggleFavoriteHome event,
    Emitter<NewsState> emit,
  ) async {
    await favoritesManager.toggleFavorite(event.id);

    final updatedList = state.news.map((n) {
      if (n.id == event.id) {
        return n.copyWith(isFavorite: !n.isFavorite);
      }
      return n;
    }).toList();

    emit(state.copyWith(news: updatedList));
  }

  // ADICIONADO: Lógica de sincronização sem nova chamada de API
  void _onRefreshFavorites(RefreshFavorites event, Emitter<NewsState> emit) {
    // Apenas mapeia a lista atual e pergunta ao manager o status real
    final refreshedList = state.news.map((n) {
      return n.copyWith(isFavorite: favoritesManager.isFavorite(n.id));
    }).toList();

    emit(state.copyWith(news: refreshedList));
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return 'Erro no servidor. Tente novamente.';
    if (failure is CacheFailure) return 'Erro ao carregar dados locais.';
    return 'Erro desconhecido.';
  }
}
