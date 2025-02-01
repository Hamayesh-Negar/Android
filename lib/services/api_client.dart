import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.3.2:8000';
  late Dio _dio;
  String? _token;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Token $_token';
        }
        return handler.next(options);
      },
    ));
  }

  void setToken(String token) {
    _token = token;
  }

  String? getToken() {
    return _token;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }
}
