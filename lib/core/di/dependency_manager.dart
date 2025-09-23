// lib/core/di/dependency_manager.dart
import 'package:lxp_platform/core/di/service_locator.dart';

class DependencyManager {
  static T registerSingleton<T extends Object>(T instance) {
    if (sl.isRegistered<T>()) {
      sl.unregister<T>();
    }
    sl.registerSingleton<T>(instance);
    return sl<T>();
  }

  static T get<T extends Object>() {
    return sl<T>();
  }

  static void unregister<T extends Object>() {
    if (sl.isRegistered<T>()) {
      sl.unregister<T>();
    }
  }

  static bool isRegistered<T extends Object>() {
    return sl.isRegistered<T>();
  }
}
