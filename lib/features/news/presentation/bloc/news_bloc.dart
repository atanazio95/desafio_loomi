import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;

  // Não precisamos mais de FavoriteManager injetado, pois é tudo memória
  NewsBloc({required this.getNewsUseCase}) : super(const NewsState()) {
    on<GetNewsEvent>(_onGetNews);
    on<ToggleFavoriteHome>(_onToggleFavorite);
  }

  // Dentro do método _onGetNews
  Future<void> _onGetNews(GetNewsEvent event, Emitter<NewsState> emit) async {
    // [CORREÇÃO] Removemos o 'if (event.page == 1)'
    // Agora emitimos isLoading: true para QUALQUER página.
    // A UI saberá lidar (se a lista estiver vazia = loading tela toda; se tiver itens = loading botão).
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getNewsUseCase(event.page);

    result.fold(
      (failure) {
        emit(
          state.copyWith(isLoading: false, error: "Erro ao carregar notícias."),
        );
      },
      (fetchedNews) {
        final savedIds = state.savedNews.map((e) => e.id).toSet();

        final newsWithFavorites = fetchedNews.map((n) {
          return n.copyWith(isFavorite: savedIds.contains(n.id));
        }).toList();

        List<NewsEntity> updatedList;

        if (event.page == 1) {
          // Refresh: Substitui tudo
          updatedList = newsWithFavorites;
        } else {
          // Paginação: Mantém os antigos e adiciona os novos
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

  void _onToggleFavorite(ToggleFavoriteHome event, Emitter<NewsState> emit) {
    // 1. Identificar se já é favorito olhando para a lista em memória
    final isAlreadySaved = state.savedNews.any((n) => n.id == event.id);

    // 2. Criar a NOVA lista de favoritos
    List<NewsEntity> newSavedList = List.from(state.savedNews);

    if (isAlreadySaved) {
      // REMOVER: Filtra tirando o item com esse ID
      newSavedList.removeWhere((n) => n.id == event.id);
    } else {
      // ADICIONAR: Acha o item na lista principal e adiciona nos salvos
      // (Fallback: se não achar na lista principal, tenta achar nos relacionados de alguém)
      try {
        // Tenta achar na lista principal
        var itemToAdd = state.news.firstWhere((n) => n.id == event.id);
        newSavedList.add(itemToAdd.copyWith(isFavorite: true));
      } catch (e) {
        // Se não achou na lista principal, pode ser uma notícia relacionada (nested)
        // Por simplificação, se não achar na root, ignoramos ou buscamos recursivamente.
        // Como o Mock/API deve retornar tudo, isso é raro.
      }
    }

    // 3. Atualizar a lista PRINCIPAL (Feed) para a estrela mudar de cor na Home
    final newNewsList = state.news.map((newsItem) {
      if (newsItem.id == event.id) {
        return newsItem.copyWith(isFavorite: !isAlreadySaved);
      }

      // [Opcional] Atualizar também dentro das relatedNews se necessário
      // (Para quando clicar no coração do card pequeno dentro do detalhe)
      final updatedRelated = newsItem.relatedNews.map((related) {
        if (related.id == event.id) {
          return related.copyWith(isFavorite: !isAlreadySaved);
        }
        return related;
      }).toList();

      return newsItem.copyWith(relatedNews: updatedRelated);
    }).toList();

    // 4. Emitir novo estado
    emit(state.copyWith(savedNews: newSavedList, news: newNewsList));
  }
}
