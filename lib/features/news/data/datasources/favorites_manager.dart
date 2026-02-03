// Example: persistence of favorites with SharedPreferences.
// The app currently keeps favorites in memory (NewsBloc.savedNews); this file
// is kept as reference for when persistence with SharedPreferences is needed.

import 'dart:convert';

import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  final SharedPreferences sharedPreferences;
  static const String _kFavoritesKey = 'favorite_news_full_cache';

  final List<NewsEntity> _cachedList = [];

  FavoritesManager({required this.sharedPreferences}) {
    _loadFromDisk();
  }

  void _loadFromDisk() {
    final List<String>? jsonList =
        sharedPreferences.getStringList(_kFavoritesKey);
    if (jsonList != null) {
      _cachedList.clear();
      for (var jsonStr in jsonList) {
        try {
          final map = jsonDecode(jsonStr);
          _cachedList.add(NewsModel.fromJson(map));
        } catch (_) {}
      }
    }
  }

  List<NewsEntity> getSavedNews() {
    return List.from(_cachedList);
  }

  bool isFavorite(String id) {
    return _cachedList.any((element) => element.id == id);
  }

  Future<void> toggleFavorite(NewsEntity news) async {
    final index = _cachedList.indexWhere((element) => element.id == news.id);

    if (index >= 0) {
      _cachedList.removeAt(index);
    } else {
      _cachedList.add(news);
    }

    await _persist();
  }

  Future<void> _persist() async {
    final List<String> stringList = _cachedList.map((news) {
      return jsonEncode({
        'id': news.id,
        'title': news.title,
        'imageUrl': news.imageUrl,
        'summary': news.summary,
        'datePublished': news.datePublished,
        'author': news.author,
        'category': news.category,
      });
    }).toList();

    await sharedPreferences.setStringList(_kFavoritesKey, stringList);
  }
}
