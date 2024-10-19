import 'package:e_reader/app/data/http/exceptions.dart';
import 'package:e_reader/app/data/http/http_client.dart';
import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:e_reader/app/repositories/ebooks_repository.dart';
import 'package:flutter/material.dart';

class EbooksStore {
  final EbooksRepository repository = EbooksRepository(client: HttpClient());

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<EbooksModel>> ebooksState =
      ValueNotifier<List<EbooksModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>('');

  final ValueNotifier<String> downloadStatus = ValueNotifier<String>('');
  final ValueNotifier<double> downloadProgress = ValueNotifier<double>(0.0);

  final ValueNotifier<String?> downloadError = ValueNotifier<String?>(null);

  Future getEbooks(String url) async {
    isLoading.value = true;
    try {
      final result = await repository.getEbooks(url);
      ebooksState.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }
}
