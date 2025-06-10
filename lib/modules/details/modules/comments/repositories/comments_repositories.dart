import 'package:dio/dio.dart';

class CommentsRepositories {
  final Dio dio;

  CommentsRepositories(this.dio);

  Future<dynamic> postComment(int postId, String comment) async {
    try {
      final response = await dio.post(
        '/posts/$postId/comments',
        data: {
          'postId': postId,
          'body': comment,
        },
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );
      return response.data;
    } catch (e) {
      print('Erro ao postar comentário: $e');
    }
  }
}