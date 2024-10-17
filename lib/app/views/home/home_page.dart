import 'package:e_reader/app/data/http/http_client.dart';
import 'package:e_reader/app/repositories/ebooks_repository.dart';
import 'package:e_reader/app/stores/ebooks_store.dart';
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

  @override
  void initState() {
    super.initState();
    store.getEbooks();
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
          return GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: store.ebooksState.value
                .map(
                  (ebook) => Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            ebook.cover_url,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(ebook.title),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
