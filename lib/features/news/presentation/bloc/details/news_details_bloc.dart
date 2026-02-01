import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_details_event.dart';
import 'news_details_state.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_details_usecase.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  final GetNewsDetailsUseCase getNewsDetailsUseCase;

  NewsDetailsBloc({required this.getNewsDetailsUseCase})
    : super(NewsDetailsInitial()) {
    on<GetNewsDetails>((event, emit) async {
      emit(NewsDetailsLoading());

      final result = await getNewsDetailsUseCase(event.id);

      result.fold(
        (failure) =>
            emit(NewsDetailsError("Erro ao carregar detalhes da notícia.")),
        (news) => emit(NewsDetailsLoaded(news)),
      );
    });
  }
}
