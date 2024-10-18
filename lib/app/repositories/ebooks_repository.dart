import 'dart:convert';
import 'dart:io';

import 'package:e_reader/app/data/http/exceptions.dart';
import 'package:e_reader/app/data/http/http_client.dart';
import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class IEbooksRepository {
  Future<List<EbooksModel>> getEbooks(String url);
  Future<dynamic> downloadEbook(String downloadUrl, String fileName);
  // Future<Ebook> addEbook(Ebook ebook);
  // Future<Ebook> updateEbook(Ebook ebook);
  // Future<void> deleteEbook(String id);
}

class EbooksRepository implements IEbooksRepository {
  final IHttpClient client;
  EbooksRepository({required this.client});
  @override
  Future<List<EbooksModel>> getEbooks(String url) async {
    final response = await client.get(url: url);

    if (response.statusCode == 200) {
      final List<EbooksModel> data = [];
      final body = jsonDecode(response.body);
      // ignore: avoid_print
      print(body);

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

  @override
  Future downloadEbook(String downloadUrl, String fileName) async {
    String filePath = '';
    final result = await HttpClient().get(url: downloadUrl);

    if (result.statusCode == 200) {
      final path = (await getApplicationDocumentsDirectory()).path;
      final file = File('$path/$fileName');

      await file.writeAsBytes(result.bodyBytes);
      print('File downloaded at: $path/$fileName');
    } else {
      throw Exception(
          'Failed to download file at: $downloadUrl with status code: ${result.statusCode}');
    }
  }
}