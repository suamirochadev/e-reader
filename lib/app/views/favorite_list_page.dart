import 'package:e_reader/app/data/http/http_client.dart';
import 'package:e_reader/app/repositories/ebooks_repository.dart';
import 'package:e_reader/app/repositories/favorite_ebook_repository.dart';
import 'package:e_reader/app/stores/ebooks_store.dart';
import 'package:flutter/material.dart';

class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({super.key});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  late FavoriteEbookRepository favoriteEbookRepository;
  List<String> favoriteEbooks = [];
  final EbooksStore store = EbooksStore(
    repository: EbooksRepository(
      client: HttpClient(),
    ),
  );

   Future<void> loadFavorites() async {
    await favoriteEbookRepository.loadFavorites();
    setState(() {
      favoriteEbooks = favoriteEbookRepository.favoriteEbooks;
    });
  }

  @override
  void initState() {
    super.initState();
    favoriteEbookRepository = FavoriteEbookRepository();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite List'),
      ),
      body:  ListView.builder(
        itemCount: favoriteEbooks.length,
        itemBuilder: (context, index) {
          final favoriteEbookId = favoriteEbooks[index];
          return ListTile(
            title: Text(favoriteEbookId),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                favoriteEbookRepository.removeFavorite(favoriteEbookId);
                loadFavorites();
              },
            ),
          );
        },
      )
    );
  }
}
