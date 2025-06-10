import 'package:signals_flutter/signals_flutter.dart';
import 'package:photo/modules/details/modules/photo_details/repositories/photo_details_repositories.dart';

class PhotoDetailsController {
  final currentPageIndex = signal(0);
  final isLoading = signal(true);
  final user = signal<Map<String, dynamic>>({});
  final comments = signal<List<dynamic>>([]);
  
  final PhotoDetailsRepositories _repository;

  PhotoDetailsController(this._repository);

  Future<void> loadPhotoDetails(int photoId) async {
    try {
      isLoading.value = true;
      
      final details = await _repository.getPhotoDetails(photoId);
      final photoComments = await _repository.getPhotoComments(photoId);
      
      user.value = details;
      comments.value = photoComments;
    } catch (e) {
      print('Erro ao carregar detalhes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateCurrentPageIndex(int index) {
    currentPageIndex.value = index;
  }
}