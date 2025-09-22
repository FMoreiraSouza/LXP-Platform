// lib/core/di/service_locator.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lxp_platform/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Dio
  sl.registerLazySingleton(
    () => Dio()
      ..options.baseUrl = 'https://cefis.com.br/api/v1'
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  // ApiService (se ainda for necessário)
  sl.registerLazySingleton(() => ApiService());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
}
