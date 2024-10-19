import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:e_reader/app/stores/ebooks_store.dart';
import 'package:e_reader/app/stores/favorite_ebook_store.dart';
import 'package:e_reader/app/views/ebook_detail_page.dart';
import 'package:e_reader/app/views/favorite_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FavoriteEbookStore favorite = FavoriteEbookStore();
  final EbooksStore store = EbooksStore();

  void toEbookDetailPage(BuildContext context, EbooksModel ebook) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EbookDetailPage(
            ebook: ebook,
            store: store,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    store.getEbooks('');
    favorite.loadFavorites().then((_) {
      setState(() {
        // Atualiza a UI após carregar os favoritos
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoriteListPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge(
          [
            store.isLoading,
            store.ebooksState,
            store.error,
            favorite.favoriteEbooks
          ],
        ),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (store.error.value.isNotEmpty) {
            return Center(
              child: Text(store.error.value),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: store.ebooksState.value.length,
            itemBuilder: (context, index) {
              final ebook = store.ebooksState.value[index];

              return InkWell(
                onTap: () {
                  toEbookDetailPage(context, ebook);
                },
                child: Stack(
                  children: [
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.network(
                              ebook.coverUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(ebook.title),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (favorite.isFavorite(ebook.id.toString())) {
                              favorite.removeFavorite(ebook.id.toString());
                              _showSnackBar(context, 'Removed from favorites');
                            } else {
                              favorite.addFavorite(ebook);
                              favorite.getFavoriteEbooks();
                              _showSnackBar(context, 'Added to favorites');
                            }
                          });
                        },
                        icon: Icon(
                          favorite.isFavorite(ebook.id.toString())
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favorite.isFavorite(ebook.id.toString())
                              ? Colors.red
                              : Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
