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
         builder: (context, child){
          if (store.isLoading.value) {
            return const CircularProgressIndicator();
          }
          if (store.error.value.isNotEmpty) {
            return Center(
              child: Text(store.error.value),
            );
          }
          return ListView.builder(
            itemCount: store.ebooksState.value.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(store.ebooksState.value[index].title),
              );
            },
          );
         },
         ),
    );
  }
}