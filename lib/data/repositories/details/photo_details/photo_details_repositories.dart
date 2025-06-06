import 'package:dio/dio.dart';

class PhotoDetailsRepositories {
  final Dio _dio;

  PhotoDetailsRepositories(this._dio);

  Future<Map<String, dynamic>> getPhotoDetails(int id) async {
    try {
      final response = await _dio.get(
        '/users/$id',
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load photo details: $e');
    }
  }
}