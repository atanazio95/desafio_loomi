import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:equatable/equatable.dart';

enum NewsStatus { initial, success, failure }

class NewsState extends Equatable {
  final NewsStatus status;
  final List<NewsEntity> news;
  final List<NewsEntity> savedNews;
  final bool hasReachedMax;
  final String errorMessage;

  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const <NewsEntity>[],
    this.savedNews = const <NewsEntity>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  NewsState copyWith({
    NewsStatus? status,
    List<NewsEntity>? news,
    List<NewsEntity>? savedNews,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      savedNews: savedNews ?? this.savedNews,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, news, hasReachedMax, errorMessage];
}
