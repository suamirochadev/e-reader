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

  final ValueNotifier<EbooksModel?> selectedEbook = ValueNotifier<EbooksModel?>(null);

  EbooksStore({required this.repository});

  Future getEbooks() async {
    isLoading.value = true;
    try {
      final result = await repository.getEbooks();
      ebooksState.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }

  Future getEbook(String id) async {
    isLoading.value = true;
    try {
      final result = await repository.getEbook(id);
      selectedEbook.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }
}

