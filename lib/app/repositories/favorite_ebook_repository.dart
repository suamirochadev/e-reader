import 'dart:convert';
import 'dart:io';
import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteEbookRepository {
  List<EbooksModel> _favoriteEbooks = [];

  // Carrega os favoritos do arquivo
  Future<void> loadFavorites() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/favorites.json');

    if (await file.exists()) {
      final contents = await file.readAsString();
      List<dynamic> jsonList = json.decode(contents);
      _favoriteEbooks = jsonList.map((e) => EbooksModel.fromJson(e)).toList();
    }
  }

  // Salva a lista de favoritos no arquivo
  Future<void> saveFavorites() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/favorites.json');
    final jsonList =
        jsonEncode(_favoriteEbooks.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonList);
  }

  // Adiciona um eBook aos favoritos
  Future<void> addFavorite(EbooksModel ebook) async {
    if (!_favoriteEbooks.any((fav) => fav.id == ebook.id)) {
      _favoriteEbooks.add(ebook);
      await saveFavorites(); // Salva a lista atualizada
    }
  }

  // Remove um eBook dos favoritos
  Future<void> removeFavorite(String id) async {
    _favoriteEbooks.removeWhere((fav) => fav.id.toString() == id);
    await saveFavorites(); // Salva a lista atualizada
  }

  // Verifica se um eBook é favorito
  bool isFavorite(String id) {
    return _favoriteEbooks.any((fav) => fav.id.toString() == id);
  }

  // Retorna a lista de eBooks favoritos
  List<EbooksModel> getFavoriteEbooks() {
    return _favoriteEbooks;
  }
}
