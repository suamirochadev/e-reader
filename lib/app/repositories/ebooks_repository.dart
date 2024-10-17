import 'dart:convert';

import 'package:e_reader/app/data/http/exceptions.dart';
import 'package:e_reader/app/data/http/http_client.dart';
import 'package:e_reader/app/models/ebooks_model.dart';

abstract class IEbooksRepository {
  Future<List<EbooksModel>> getEbooks();
  // Future<Ebook> getEbook(String id);
  // Future<Ebook> addEbook(Ebook ebook);
  // Future<Ebook> updateEbook(Ebook ebook);
  // Future<void> deleteEbook(String id);
}

class EbooksRepository implements IEbooksRepository {
  final IHttpClient client;
  EbooksRepository({required this.client});
  @override
  Future<List<EbooksModel>> getEbooks() async {
    final response = await client.get(url: 'https://escribo.com/books.json');

    if (response.statusCode == 200) {
      final List<EbooksModel> data = [];
      final body = jsonDecode(response.body);

      body.map((ebook) {
        final ebookModel = EbooksModel.fromMap(ebook);
        data.add(ebookModel);
      }).toList();
      return data;
    } else if (response.statusCode == 404) {
      throw NotFoundException(message: 'Not Found, try again later');
    } else {
      throw Exception('Failed to load data');
    }
  }
}
