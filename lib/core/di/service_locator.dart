// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:lxp_platform/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services síncronos
  sl.registerLazySingleton(() => ApiService());

  // SharedPreferences (inicialização assíncrona)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
}
