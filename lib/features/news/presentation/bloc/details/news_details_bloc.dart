import 'package:desafio_loomi_flutter/core/services/favorites_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_details_event.dart';
import 'news_details_state.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_details_usecase.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  final GetNewsDetailsUseCase getNewsDetailsUseCase;
  final FavoritesManager favoritesManager;

  NewsDetailsBloc({
    required this.getNewsDetailsUseCase,
    required this.favoritesManager,
  }) : super(NewsDetailsInitial()) {
    on<GetNewsDetails>((event, emit) async {
      emit(NewsDetailsLoading());

      final result = await getNewsDetailsUseCase(event.id);

      result.fold(
        (failure) => emit(NewsDetailsError("Erro ao carregar detalhes.")),
        (news) {
          final isFav = favoritesManager.isFavorite(news.id);
          final newsWithFav = news.copyWith(isFavorite: isFav);

          emit(NewsDetailsLoaded(newsWithFav));
        },
      );
    });

    on<ToggleFavoriteNews>((event, emit) async {
      if (state is NewsDetailsLoaded) {
        final currentNews = (state as NewsDetailsLoaded).news;
        await favoritesManager.toggleFavorite(currentNews);

        final updatedNews = currentNews.copyWith(
          isFavorite: !currentNews.isFavorite,
        );

        emit(NewsDetailsLoaded(updatedNews));
      }
    });
  }
}
