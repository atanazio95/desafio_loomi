import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:desafio_loomi_flutter/features/news/data/datasources/news_local_datasource.dart';
import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';

const _keyNewsList = 'news_list_cache';
const _keyNewsDetailPrefix = 'news_detail_';

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences _prefs;

  NewsLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  @override
  Future<void> saveNewsList(List<NewsModel> list) async {
    final listJson = list.map((e) => e.toJson()).toList();
    await _prefs.setString(_keyNewsList, jsonEncode(listJson));
  }

  @override
  Future<List<NewsModel>?> getNewsList() async {
    final raw = _prefs.getString(_keyNewsList);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveNewsDetail(NewsModel detail) async {
    await _prefs.setString(
      '$_keyNewsDetailPrefix${detail.id}',
      jsonEncode(detail.toJson()),
    );
  }

  @override
  Future<NewsModel?> getNewsDetail(String id) async {
    final raw = _prefs.getString('$_keyNewsDetailPrefix$id');
    if (raw == null) return null;
    try {
      return NewsModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }
}
