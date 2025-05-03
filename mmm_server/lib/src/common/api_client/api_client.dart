import 'package:dio/dio.dart';
import 'package:mmm_server/src/common/constants/ivi_api_constants.dart';

FilmApiClient apiClient = FilmApiClient(baseUrl: apiUrl);

class FilmApiClient {
  FilmApiClient({required String baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParametrs,
  }) async {
    return _dio.get(path, queryParameters: queryParametrs);
  }
}
