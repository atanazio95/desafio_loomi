import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:equatable/equatable.dart';

enum NewsStatus { initial, success, failure }

class NewsState extends Equatable {
  final NewsStatus status;
  final List<NewsEntity> news;
  final bool hasReachedMax;
  final String errorMessage;

  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const <NewsEntity>[],
    this.hasReachedMax = false,
    this.errorMessage = '',
  });

  // Copiar o estado mantendo os valores anteriores (Imutabilidade)
  NewsState copyWith({
    NewsStatus? status,
    List<NewsEntity>? news,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, news, hasReachedMax, errorMessage];
}
