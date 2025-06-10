import 'package:dio/dio.dart';

class HomeRepository {
  final Dio dio;

  HomeRepository(this.dio);

  Future<List<dynamic>> getPhotos() async {
    try {
      final response = await dio.get(
        '/photos',
        queryParameters: {'_limit': 10},
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );
      return response.data as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}