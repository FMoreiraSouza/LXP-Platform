import 'package:lxp_platform/core/di/service_locator.dart';

class DependencyManager {
  static T registerSingleton<T extends Object>(T instance) {
    if (!sl.isRegistered<T>()) {
      sl.registerSingleton<T>(instance);
    }
    return sl<T>();
  }

  static T get<T extends Object>() {
    return sl<T>();
  }

  static void unregister<T extends Object>() {
    sl.unregister<T>();
  }

  static bool isRegistered<T extends Object>() {
    return sl.isRegistered<T>();
  }
}
