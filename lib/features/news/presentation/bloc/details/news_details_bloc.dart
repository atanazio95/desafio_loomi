import 'package:desafio_loomi_flutter/core/services/favorites_manager.dart'; // <--- IMPORTANTE: Importe o Manager
import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_details_event.dart';
import 'news_details_state.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_details_usecase.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  final GetNewsDetailsUseCase getNewsDetailsUseCase;
  final FavoritesManager favoritesManager; // <--- IMPORTANTE: Dependência nova

  NewsDetailsBloc({
    required this.getNewsDetailsUseCase,
    required this.favoritesManager, // <--- IMPORTANTE: Receber no construtor
  }) : super(NewsDetailsInitial()) {
    // --- 1. Ao Carregar a Notícia ---
    on<GetNewsDetails>((event, emit) async {
      emit(NewsDetailsLoading());

      final result = await getNewsDetailsUseCase(event.id);

      result.fold(
        (failure) => emit(NewsDetailsError("Erro ao carregar detalhes.")),
        (news) {
          final isFav = favoritesManager.isFavorite(news.id);

          // Sobrescrevemos o valor da API com o valor do disco
          final newsWithFav = news.copyWith(isFavorite: isFav);

          emit(NewsDetailsLoaded(newsWithFav));
        },
      );
    });

    // --- 2. Ao Clicar no Coração ---
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
