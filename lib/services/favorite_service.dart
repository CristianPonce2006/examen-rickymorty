import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _keyFavorites = 'favorite_ids';

  /// Obtiene la lista completa de IDs de favoritos
  Future<List<String>> getAllFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
  }

  /// Obtiene un bloque paginado de IDs desde el almacenamiento local
  Future<List<String>> getPaginatedFavoriteIds({
    int page = 1,
    int pageSize = 10,
  }) async {
    final allIds = await getAllFavoriteIds();

    final startIndex = (page - 1) * pageSize;
    if (startIndex >= allIds.length || startIndex < 0) {
      return [];
    }

    final endIndex = (startIndex + pageSize > allIds.length)
        ? allIds.length
        : startIndex + pageSize;

    return allIds.sublist(startIndex, endIndex);
  }

  /// Verifica si un ID está guardado como favorito
  Future<bool> isFavorite(int id) async {
    final ids = await getAllFavoriteIds();
    return ids.contains(id.toString());
  }

  /// Agrega o elimina un ID de la lista de favoritos
  Future<bool> toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = await getAllFavoriteIds();
    final String stringId = id.toString();

    bool isNowFavorite;
    if (ids.contains(stringId)) {
      ids.remove(stringId);
      isNowFavorite = false;
    } else {
      ids.add(stringId);
      isNowFavorite = true;
    }

    await prefs.setStringList(_keyFavorites, ids);
    return isNowFavorite;
  }
}