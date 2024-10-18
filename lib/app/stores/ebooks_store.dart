import 'package:e_reader/app/data/http/exceptions.dart';
import 'package:e_reader/app/models/ebooks_model.dart';
import 'package:e_reader/app/repositories/ebooks_repository.dart';
import 'package:flutter/material.dart';

class EbooksStore {
  final IEbooksRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<EbooksModel>> ebooksState =
      ValueNotifier<List<EbooksModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>('');


  EbooksStore({required this.repository});

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
