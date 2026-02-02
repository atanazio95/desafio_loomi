// Em lib/features/news/presentation/bloc/news_state.dart

import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:equatable/equatable.dart';

class NewsState extends Equatable {
  final List<NewsEntity> news;
  final List<NewsEntity> savedNews;
  final bool isLoading;
  final String? error;
  final int currentPage; // [NOVO]

  const NewsState({
    this.news = const [],
    this.savedNews = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1, // [NOVO] Inicia na 1
  });

  NewsState copyWith({
    List<NewsEntity>? news,
    List<NewsEntity>? savedNews,
    bool? isLoading,
    String? error,
    int? currentPage, // [NOVO]
  }) {
    return NewsState(
      news: news ?? this.news,
      savedNews: savedNews ?? this.savedNews,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage, // [NOVO]
    );
  }

  @override
  List<Object?> get props => [news, savedNews, isLoading, error, currentPage];
}
