

class FavoriteEbookStore {
  final List<String> _favoriteEbooks = [];

  List<String> get favoriteEbooks => _favoriteEbooks;

  void addFavorite(String id) {
    if (!_favoriteEbooks.contains(id)){_favoriteEbooks.add(id);}
  }

  void removeFavorite(String id) {
    _favoriteEbooks.remove(id);
  }

  bool isFavorite(String id) {
    return _favoriteEbooks.contains(id);
  }
}