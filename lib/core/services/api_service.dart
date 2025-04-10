import 'package:dio/dio.dart';
import '../config/app_config.dart';

class ApiService {
  ApiService()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          queryParameters: {'api_key': ApiConfig.apiKey},
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
  final Dio dio;

  void configureDio() {
    dio.options.headers['Content-Type'] = 'application/json';
  }
}
