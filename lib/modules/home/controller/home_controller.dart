import 'package:signals_flutter/signals_flutter.dart';
import 'package:photo/modules/home/repositories/home_repositories.dart';

class HomeController {
  final photos = signal<List<dynamic>>([]);
  final searchText = signal('');
  final isLoading = signal(true);
  
  final HomeRepository _repository;

  HomeController(this._repository);

  Future<void> loadPhotos() async {
    try {
      isLoading.value = true;
      final photosApi = await _repository.getPhotos();
      photos.value = photosApi;
    } catch (e) {
      print('Erro ao carregar fotos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchText(String value) {
    searchText.value = value;
  }

  void clearSearch() {
    searchText.value = '';
  }

  List<dynamic> get filteredPhotos {
    return photos.value.where((photo) {
      final title = (photo['title'] ?? '').toString();
      return title.toLowerCase().contains(searchText.value.toLowerCase());
    }).toList();
  }
}