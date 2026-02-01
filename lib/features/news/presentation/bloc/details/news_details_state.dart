import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';

abstract class NewsDetailsState {}

class NewsDetailsInitial extends NewsDetailsState {}

class NewsDetailsLoading extends NewsDetailsState {}

class NewsDetailsLoaded extends NewsDetailsState {
  final NewsEntity news;
  NewsDetailsLoaded(this.news);
}

class NewsDetailsError extends NewsDetailsState {
  final String message;
  NewsDetailsError(this.message);
}
