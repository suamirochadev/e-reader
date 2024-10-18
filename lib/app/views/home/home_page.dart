import 'package:e_reader/app/data/http/http_client.dart';
import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:e_reader/app/repositories/ebooks_repository.dart';
import 'package:e_reader/app/stores/ebooks_store.dart';
import 'package:e_reader/app/views/ebook_detail_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EbooksStore store = EbooksStore(
    repository: EbooksRepository(
      client: HttpClient(),
    ),
  );

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Reader'),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge(
          [store.isLoading, store.ebooksState, store.error],
        ),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const CircularProgressIndicator();
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
                child: Card(
                  child: Column(
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
              );
            },
          );
        },
      ),
    );
  }
}
