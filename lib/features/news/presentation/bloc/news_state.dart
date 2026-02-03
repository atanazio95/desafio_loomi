// Em lib/features/news/presentation/bloc/news_state.dart

import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:equatable/equatable.dart';

class NewsState extends Equatable {
  final List<NewsEntity> news;
  final List<NewsEntity> savedNews;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final String searchQuery; // [NOVO] Termo de busca

  const NewsState({
    this.news = const [],
    this.savedNews = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.searchQuery = '', // [NOVO] Inicia vazio
  });

  // [LÓGICA DE FILTRO] Getter que a UI usará para exibir as notícias
  // Ele filtra a lista 'news' baseada na 'searchQuery' localmente.
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
    bool? isLoading,
    String? error,
    int? currentPage,
    String? searchQuery, // [NOVO]
  }) {
    return NewsState(
      news: news ?? this.news,
      savedNews: savedNews ?? this.savedNews,
      isLoading: isLoading ?? this.isLoading,
      error:
          error, // Aqui costuma-se manter nulo se não passado para limpar erros antigos
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery, // [NOVO]
    );
  }

  @override
  List<Object?> get props => [
    news,
    savedNews,
    isLoading,
    error,
    currentPage,
    searchQuery, // [NOVO] Adicionado aos props para o Equatable detectar mudanças
  ];
}
