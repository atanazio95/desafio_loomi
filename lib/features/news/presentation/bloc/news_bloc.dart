import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news_details_usecase.dart';
import '../../domain/usecases/get_news_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNewsUseCase;
  final GetNewsDetailsUseCase getNewsDetailsUseCase;

  NewsBloc({
    required this.getNewsUseCase,
    required this.getNewsDetailsUseCase,
  }) : super(const NewsState()) {
    on<GetNewsEvent>(_onGetNews);
    on<ToggleFavoriteHome>(_onToggleFavorite);
    on<SearchNewsEvent>(_onSearchNews);
    on<LoadNewsDetailsEvent>(_onLoadNewsDetails);
  }

  Future<void> _onLoadNewsDetails(
    LoadNewsDetailsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(state.copyWith(
      clearCurrentDetails: true,
      lastRequestedDetailsId: event.id,
      isLoadingDetails: true,
      detailsError: null,
    ));
    final result = await getNewsDetailsUseCase(event.id);
    result.fold(
      (_) => emit(state.copyWith(
        clearCurrentDetails: true,
        isLoadingDetails: false,
        detailsError: 'Não foi possível carregar os detalhes.',
      )),
      (details) {
        final savedIds = state.savedNews.map((e) => e.id).toSet();
        final withFav = details.copyWith(
          isFavorite: savedIds.contains(details.id),
          relatedNews: details.relatedNews.map((r) {
            return r.copyWith(isFavorite: savedIds.contains(r.id));
          }).toList(),
        );
        emit(state.copyWith(
          currentDetails: withFav,
          isLoadingDetails: false,
          detailsError: null,
        ));
      },
    );
  }

  void _onSearchNews(SearchNewsEvent event, Emitter<NewsState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onGetNews(GetNewsEvent event, Emitter<NewsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getNewsUseCase(event.page);

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, error: "Erro ao carregar notícias."),
      ),
      (fetchedNews) {
        final savedIds = state.savedNews.map((e) => e.id).toSet();
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

  void _onToggleFavorite(ToggleFavoriteHome event, Emitter<NewsState> emit) {
    final isAlreadySaved = state.savedNews.any((n) => n.id == event.id);
    List<NewsEntity> newSavedList = List.from(state.savedNews);

    if (isAlreadySaved) {
      newSavedList.removeWhere((n) => n.id == event.id);
    } else {
      try {
        var itemToAdd = state.news.firstWhere(
          (n) => n.id == event.id,
          orElse: () => state.news
              .expand((n) => n.relatedNews)
              .firstWhere((r) => r.id == event.id),
        );
        newSavedList.add(itemToAdd.copyWith(isFavorite: true));
      } catch (_) {}
    }

    final newNewsList = state.news.map((newsItem) {
      if (newsItem.id == event.id) {
        return newsItem.copyWith(isFavorite: !isAlreadySaved);
      }

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
