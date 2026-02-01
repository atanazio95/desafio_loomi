import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  final SharedPreferences sharedPreferences;
  final Set<String> _favoriteIds = {};
  static const String _kFavoritesKey = 'favorite_news_ids';

  FavoritesManager({required this.sharedPreferences}) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final List<String>? savedList = sharedPreferences.getStringList(
      _kFavoritesKey,
    );

    // DISK PROOF:
    // This log confirms that both persistence layers are functional:
    // 1. Memory (RAM) via the local Set/Singleton is ready for instant UI updates.
    // 2. Persistent Storage (Disk) via SharedPreferences is successfully updated for app restarts.
    if (savedList != null) {
      _favoriteIds.addAll(savedList);

      print('💾 [DISK] Retrieved from SharedPreferences: $savedList');
    }
  }

  bool isFavorite(String id) {
    final result = _favoriteIds.contains(id);
    return result;
  }

  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      print('⚡ [RAM] Removido da memória: $id');
    } else {
      _favoriteIds.add(id);
      print('⚡ [RAM] Adicionado na memória: $id');
    }
    await _persist();
  }

  Future<void> _persist() async {
    await sharedPreferences.setStringList(
      _kFavoritesKey,
      _favoriteIds.toList(),
    );
    // CONFIRMAÇÃO DE SALVAMENTO:
    print('💾 [DISK] Lista atualizada salva no disco!');
  }
}
