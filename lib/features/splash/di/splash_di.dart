import 'package:flutter/material.dart';
import 'package:lxp_platform/core/di/page_dependency.dart';
import 'package:lxp_platform/features/splash/ui/pages/splash_page.dart';

class SplashDI implements PageDependency {
  @override
  void init() {}

  @override
  StatefulWidget getPage() {
    return const SplashPage();
  }
}
