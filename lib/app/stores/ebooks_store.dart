import 'package:e_reader/app/data/http/exceptions.dart';
import 'package:e_reader/app/repositories/ebooks_repository.dart';
import 'package:flutter/material.dart';

class EbooksStore {
  final IEbooksRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<String>> ebooksState =
      ValueNotifier<List<String>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>('');

  EbooksStore({required this.repository});

  Future getEbooks() async {
    isLoading.value = true;
    try {
      final result = await repository.getEbooks();
      ebooksState.value = result as List<String>;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }
}
