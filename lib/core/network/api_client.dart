// lib/core/services/api_service.dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio() {
    dio.options.baseUrl = 'https://cefis.com.br/api/v1';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }
}
