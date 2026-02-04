import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:equatable/equatable.dart';

class NewsState extends Equatable {
  final List<NewsEntity> news;
  final List<NewsEntity> savedNews;
  final NewsEntity? currentDetails;
  /// ID for which the last details request was made (useful when the mocked API always returns the same response body).
  final String? lastRequestedDetailsId;
  final bool isLoading;
  final bool isLoadingDetails;
  final String? error;
  final String? detailsError;
  final int currentPage;
  final String searchQuery;

  const NewsState({
    this.news = const [],
    this.savedNews = const [],
    this.currentDetails,
    this.lastRequestedDetailsId,
    this.isLoading = false,
    this.isLoadingDetails = false,
    this.error,
    this.detailsError,
    this.currentPage = 1,
    this.searchQuery = '',
  });

  List<NewsEntity> get displayNews {
    if (searchQuery.isEmpty) return news;

    final query = searchQuery.toLowerCase();
    return news.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
    }).toList();
  }

  NewsState copyWith({
    List<NewsEntity>? news,
    List<NewsEntity>? savedNews,
    NewsEntity? currentDetails,
    String? lastRequestedDetailsId,
    bool clearCurrentDetails = false,
    bool? isLoading,
    bool? isLoadingDetails,
    String? error,
    String? detailsError,
    int? currentPage,
    String? searchQuery,
  }) {
    return NewsState(
      news: news ?? this.news,
      savedNews: savedNews ?? this.savedNews,
      currentDetails: clearCurrentDetails ? null : (currentDetails ?? this.currentDetails),
      lastRequestedDetailsId: lastRequestedDetailsId ?? this.lastRequestedDetailsId,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      error: error,
      detailsError: detailsError,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    news,
    savedNews,
    currentDetails,
    lastRequestedDetailsId,
    isLoading,
    isLoadingDetails,
    error,
    detailsError,
    currentPage,
    searchQuery,
  ];
}
