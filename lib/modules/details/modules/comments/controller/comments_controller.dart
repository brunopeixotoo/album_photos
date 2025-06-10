import 'package:signals_flutter/signals_flutter.dart';
import 'package:photo/modules/details/modules/comments/repositories/comments_repositories.dart';

class CommentsController {
  final comments = signal<List<dynamic>>([]);
  final isLoading = signal(false);
  final title = signal('');
  final comment = signal('');
  final photoId = signal<int?>(null);

  final CommentsRepositories _repository;

  CommentsController(this._repository);

  void setPhotoId(int id) {
    photoId.value = id;
  }

  void updateTitle(String value) {
    title.value = value;
  }

  void updateComment(String value) {
    comment.value = value;
  }

  Future<bool> saveComment() async {
    if (title.value.isEmpty || comment.value.isEmpty) {
      return false;
    }

    try {
      isLoading.value = true;
      final response = await _repository.postComment(
        photoId.value!,
        comment.value,
      );
      comments.value = response;
      return true;
    } catch (e) {
      print('Erro ao fazer comentário: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    title.value = '';
    comment.value = '';
    comments.value = [];
  }
}