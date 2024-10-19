import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:e_reader/app/repositories/favorite_ebook_repository.dart';
import 'package:flutter/foundation.dart';
// Certifique-se de importar o repositório

class FavoriteEbookStore {
  final FavoriteEbookRepository _repository = FavoriteEbookRepository();
  ValueNotifier<List<EbooksModel>> get favoriteEbooks => _favoriteEbooks;
  final ValueNotifier<List<EbooksModel>> _favoriteEbooks =
      ValueNotifier<List<EbooksModel>>([]);
      


  // Carrega os favoritos do repositório
  Future<void> loadFavorites() async {
    await _repository.loadFavorites();
    _favoriteEbooks.value = _repository.getFavoriteEbooks();
  }

  // Adiciona um eBook aos favoritos
  Future<void> addFavorite(EbooksModel ebook) async {
    if (!_favoriteEbooks.value.any((fav) => fav.id == ebook.id)) {
      _favoriteEbooks.value = List.from(_favoriteEbooks.value)..add(ebook);
      await _repository.addFavorite(ebook); // Salva o favorito no repositório
    }
  }

  // Remove um eBook dos favoritos
  Future<void> removeFavorite(String id) async {
    _favoriteEbooks.value.removeWhere((fav) => fav.id.toString() == id);
    await _repository.removeFavorite(id); // Remove o favorito no repositório
  }

  // Verifica se um eBook é favorito
  bool isFavorite(String id) {
    return _favoriteEbooks.value.any((fav) => fav.id.toString() == id);
  }

  // Retorna a lista de eBooks favoritos
  List<EbooksModel> getFavoriteEbooks() {
    return _favoriteEbooks.value;
  }
}
