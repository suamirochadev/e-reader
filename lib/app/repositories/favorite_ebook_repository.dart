import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FavoriteEbookRepository {
  List<String> _favoriteEbooks = [];

  Future<void> loadFavorites() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/favorites.json');

    if (await file.exists()) {
      final contents = await file.readAsString();
      List<dynamic> jsonList = json.decode(contents);
      _favoriteEbooks = jsonList.map((e) => e.toString()).toList();
    }
  }

  Future<void> saveFavorites() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/favorites.json');
    final jsonList = jsonEncode(_favoriteEbooks);
    await file.writeAsString(jsonList);
  }

  void addFavorite(String id) {
    if (!_favoriteEbooks.contains(id)) {
      _favoriteEbooks.add(id);
      saveFavorites();
    }
  }

  void removeFavorite(String id) {
    _favoriteEbooks.remove(id);
    saveFavorites();
  }

  bool isFavorite(String id) {
    return _favoriteEbooks.contains(id);
  }

  List<String> get favoriteEbooks => _favoriteEbooks;

  List<String> getFavoriteEbooks() {
    return _favoriteEbooks;
  }
}
