import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;

  NewsBloc({required this.getNewsUseCase}) : super(const NewsState()) {
    on<GetNewsEvent>(_onGetNews);
    on<ToggleFavoriteHome>(_onToggleFavorite);
    on<SearchNewsEvent>(_onSearchNews);
  }

  // --- 1. Lógica de Busca Local ---
  void _onSearchNews(SearchNewsEvent event, Emitter<NewsState> emit) {
    // Apenas atualiza a string no estado.
    // O getter 'displayNews' no State faz o filtro automaticamente.
    emit(state.copyWith(searchQuery: event.query));
  }

  // --- 2. Carregamento de Notícias (API + Paginação) ---
  Future<void> _onGetNews(GetNewsEvent event, Emitter<NewsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getNewsUseCase(event.page);

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, error: "Erro ao carregar notícias."),
      ),
      (fetchedNews) {
        // Criamos um Set de IDs favoritados para busca rápida O(1)
        final savedIds = state.savedNews.map((e) => e.id).toSet();

        // Mapeamos as notícias vindas da API com o estado de favorito atual da memória
        final newsWithFavorites = fetchedNews.map((n) {
          return n.copyWith(isFavorite: savedIds.contains(n.id));
        }).toList();

        List<NewsEntity> updatedList;
        if (event.page == 1) {
          updatedList = newsWithFavorites;
        } else {
          updatedList = List.from(state.news)..addAll(newsWithFavorites);
        }

        emit(
          state.copyWith(
            isLoading: false,
            news: updatedList,
            currentPage: event.page,
          ),
        );
      },
    );
  }

  // --- 3. Lógica de Favoritos em Memória RAM ---
  void _onToggleFavorite(ToggleFavoriteHome event, Emitter<NewsState> emit) {
    final isAlreadySaved = state.savedNews.any((n) => n.id == event.id);
    List<NewsEntity> newSavedList = List.from(state.savedNews);

    if (isAlreadySaved) {
      newSavedList.removeWhere((n) => n.id == event.id);
    } else {
      try {
        // Tenta achar na lista principal ou nas relacionadas para adicionar aos salvos
        var itemToAdd = state.news.firstWhere(
          (n) => n.id == event.id,
          orElse: () => state.news
              .expand((n) => n.relatedNews)
              .firstWhere((r) => r.id == event.id),
        );
        newSavedList.add(itemToAdd.copyWith(isFavorite: true));
      } catch (e) {
        // Caso não encontre em lugar nenhum (raro), não adiciona nada
      }
    }

    // Atualiza a lista visual (Feed) para refletir a mudança no ícone imediatamente
    final newNewsList = state.news.map((newsItem) {
      if (newsItem.id == event.id) {
        return newsItem.copyWith(isFavorite: !isAlreadySaved);
      }

      // Atualiza também dentro das notícias relacionadas de cada card
      final updatedRelated = newsItem.relatedNews.map((related) {
        if (related.id == event.id) {
          return related.copyWith(isFavorite: !isAlreadySaved);
        }
        return related;
      }).toList();

      return newsItem.copyWith(relatedNews: updatedRelated);
    }).toList();

    emit(state.copyWith(savedNews: newSavedList, news: newNewsList));
  }
}
