class FavoriteManager {
  static final List<Map<String, dynamic>> favorites = [];

  static bool isFavorite(Map<String, dynamic> property) {
    return favorites.any((item) => item['id'] == property['id']);
  }

  static void toggleFavorite(Map<String, dynamic> property) {
    if (isFavorite(property)) {
      favorites.removeWhere((item) => item['id'] == property['id']);
    } else {
      favorites.add(property);
    }
  }
}
