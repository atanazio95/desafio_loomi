import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';

/// Local cache for offline access: news list and details.
abstract class NewsLocalDataSource {
  Future<void> saveNewsList(List<NewsModel> list);
  Future<List<NewsModel>?> getNewsList();
  Future<void> saveNewsDetail(NewsModel detail);
  Future<NewsModel?> getNewsDetail(String id);
}
