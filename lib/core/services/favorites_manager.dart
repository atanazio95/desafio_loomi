import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Importe seu model que tenha o fromJson
import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';

class FavoritesManager {
  final SharedPreferences sharedPreferences;
  static const String _kFavoritesKey = 'favorite_news_full_cache'; // Nova chave

  // Cache em memória para acesso rápido
  final List<NewsEntity> _cachedList = [];

  FavoritesManager({required this.sharedPreferences}) {
    _loadFromDisk();
  }

  void _loadFromDisk() {
    final List<String>? jsonList = sharedPreferences.getStringList(
      _kFavoritesKey,
    );
    if (jsonList != null) {
      _cachedList.clear();
      for (var jsonStr in jsonList) {
        try {
          // Converte String -> Map -> Model
          final map = jsonDecode(jsonStr);
          // IMPORTANTE: Aqui assumo que você tem o NewsModel.
          // Se estiver usando Entity pura, precisará de um adaptador.
          _cachedList.add(NewsModel.fromJson(map));
        } catch (e) {
          print("Erro ao ler cache: $e");
        }
      }
    }
  }

  // Retorna a lista completa IMEDIATAMENTE (sem API)
  List<NewsEntity> getSavedNews() {
    return List.from(_cachedList);
  }

  bool isFavorite(String id) {
    return _cachedList.any((element) => element.id == id);
  }

  Future<void> toggleFavorite(NewsEntity news) async {
    final index = _cachedList.indexWhere((element) => element.id == news.id);

    if (index >= 0) {
      // Remover
      _cachedList.removeAt(index);
    } else {
      // Adicionar (Salvamos o objeto que veio da tela anterior)
      _cachedList.add(news);
    }

    await _persist();
  }

  Future<void> _persist() async {
    // Transforma a lista de Objetos em lista de Strings JSON
    final List<String> stringList = _cachedList.map((news) {
      // Se sua entity não tem toJson, você precisará converter para Model aqui
      // return jsonEncode((news as NewsModel).toJson());
      // Ou usar um adapter manual:
      return jsonEncode({
        'id': news.id,
        'title': news.title,
        'imageUrl': news.imageUrl,
        'summary': news.summary, // ou description
        'datePublished': news.datePublished, // ajuste o nome do campo
        'author': news.author,
        'category': news.category,
      });
    }).toList();

    await sharedPreferences.setStringList(_kFavoritesKey, stringList);
  }
}
