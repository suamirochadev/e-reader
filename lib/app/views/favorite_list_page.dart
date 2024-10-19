import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:e_reader/app/stores/ebooks_store.dart';
import 'package:e_reader/app/stores/favorite_ebook_store.dart';
import 'package:flutter/material.dart';

class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({super.key});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  FavoriteEbookStore favs = FavoriteEbookStore();
  final EbooksStore store = EbooksStore();

  @override
  void initState() {
    super.initState();
    favs.favoriteEbooks;
    favs.getFavoriteEbooks();
    _loadFavorites();
  }

  // Método para carregar os favoritos armazenados
  Future<void> _loadFavorites() async {
    await favs.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite List'),
      ),
      body: ValueListenableBuilder<List<EbooksModel>>(
        valueListenable: favs.favoriteEbooks,
        builder: (context, favoriteEbooks, child) {
          if (favoriteEbooks.isEmpty) {
            return const Center(
              child: Text('No favorites yes'),
            );
          }

          return ListView.builder(
              itemCount: favoriteEbooks.length,
              itemBuilder: (context, index) {
                final ebook = favoriteEbooks[index];

                return ListTile(
                  title: Text(ebook.title),
                  subtitle: Text(ebook.author),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      // Remove o favorito
                      await favs.removeFavorite(
                        ebook.id.toString()
                      );

                      // Atualiza a lista de favoritos
                      setState(() {
                        favoriteEbooks.remove(ebook);
                      });
                    },
                  ),
                );
              });
        },
      ),
    );
  }
}
