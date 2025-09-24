import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lxp_platform/core/network/api_client.dart';
import 'package:lxp_platform/data/datasource/implementation/course_datasource.dart';
import 'package:lxp_platform/data/repository/implementation/course_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton(
    () => Dio()
      ..options.baseUrl = 'https://cefis.com.br/api/v1'
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.headers = {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  sl.registerLazySingleton(() => ApiClient());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerLazySingleton<CourseDataSource>(
    () => CourseDataSource(dio: sl<Dio>(), connectivity: sl<Connectivity>()),
  );

  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepository(dataSource: sl<CourseDataSource>()),
  );
}
